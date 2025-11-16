import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';

import '../data/local/hive_boxes.dart';

import '../data/local/hive_initializer.dart';
import '../data/repositories/inbox_repository.dart';
import '../data/repositories/projects_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/tasks_repository.dart';
import '../data/services/backup_service.dart';
import '../data/services/dummy_data_seeder.dart';
import '../data/services/notification_service.dart';
import '../data/services/task_service.dart';
import '../data/services/inbox_service.dart';
import '../data/services/review_service.dart';
import '../data/services/project_service.dart';
import '../data/repositories/settings_repository.dart';
import '../core/constants/time_window.dart';
import '../data/models/energy_level.dart';
import '../data/models/task_context.dart';
import '../data/models/task_status.dart';

final hiveInitializerProvider = Provider((ref) => const HiveInitializer());

final tasksRepositoryProvider = Provider<ITasksRepository>((ref) => TasksRepository());
final projectsRepositoryProvider = Provider<IProjectsRepository>((ref) => ProjectsRepository());
final inboxRepositoryProvider = Provider((ref) => InboxRepository());
final reviewRepositoryProvider = Provider((ref) => ReviewRepository());

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('NotificationService not initialized');
});

final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) => SettingsRepository(Hive.box(HiveBoxes.settings)));

/// Settings Hive box provider
final settingsBoxProvider = Provider((ref) => Hive.box(HiveBoxes.settings));

/// Notifications enabled flag persisted in settings box.
class NotificationsEnabledNotifier extends StateNotifier<bool> {
  NotificationsEnabledNotifier(this._box) : super(_box.get('notifications_enabled', defaultValue: true) as bool) {
    // watch for external changes
    _box.watch(key: 'notifications_enabled').listen((_) {
      state = _box.get('notifications_enabled', defaultValue: true) as bool;
    });
  }

  final Box _box;

  Future<void> setEnabled(bool enabled) async {
    await _box.put('notifications_enabled', enabled);
    state = enabled;
  }
}

final notificationsEnabledProvider = StateNotifierProvider<NotificationsEnabledNotifier, bool>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return NotificationsEnabledNotifier(box);
});

/// App locale provider: null => system default, otherwise an override like 'de_DE' or 'en_GB'
class AppLocaleNotifier extends StateNotifier<String?> {
  AppLocaleNotifier(this._repo) : super(_repo.appLocale());

  final ISettingsRepository _repo;

  Future<void> setLocale(String? localeTag) async {
    // Persist and update Intl locale and date formatting.
    await _repo.setAppLocale(localeTag);
    try {
      if (localeTag != null) {
        await initializeDateFormatting(localeTag);
        intl.Intl.defaultLocale = localeTag;
      } else {
        // Fall back to system/default formatting
        await initializeDateFormatting();
        intl.Intl.defaultLocale = null;
      }
    } catch (_) {
      // ignore formatting initialization errors - app can still run
    }
    state = _repo.appLocale();
  }
}

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, String?>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return AppLocaleNotifier(repo);
});

/// Theme mode provider persisted in settings. Values are 'system', 'light', 'dark'.
class AppThemeModeNotifier extends StateNotifier<ThemeMode> {
  AppThemeModeNotifier(this._repo) : super(_readMode(((_repo) as dynamic).themeMode()));

  final ISettingsRepository _repo;

  static ThemeMode _readMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    final str = mode == ThemeMode.light ? 'light' : mode == ThemeMode.dark ? 'dark' : 'system';
    await ((_repo) as dynamic).setThemeMode(str);
    state = mode;
  }
}

final appThemeModeProvider = StateNotifierProvider<AppThemeModeNotifier, ThemeMode>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return AppThemeModeNotifier(repo);
});

/// Snooze presets provider persisted in settings repository (list of minutes)
class SnoozePresetsNotifier extends StateNotifier<List<int>> {
  SnoozePresetsNotifier(this._repo) : super(_repo.snoozePresets());

  final ISettingsRepository _repo;

  Future<void> setPresets(List<int> presets) async {
    await _repo.setSnoozePresets(presets);
    state = presets;
  }
}

final snoozePresetsProvider = StateNotifierProvider<SnoozePresetsNotifier, List<int>>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SnoozePresetsNotifier(repo);
});

final backupServiceProvider = Provider((ref) => BackupService(
      ref.watch(tasksRepositoryProvider),
      ref.watch(projectsRepositoryProvider),
      ref.watch(inboxRepositoryProvider),
      ref.watch(reviewRepositoryProvider),
    ));

final dummyDataSeederProvider = FutureProvider<void>((ref) async {
  final seeder = DummyDataSeeder(
    ref.watch(tasksRepositoryProvider),
    ref.watch(projectsRepositoryProvider),
  );
  await seeder.seedIfEmpty();
});

final taskServiceProvider = Provider((ref) => TaskService(
      ref.watch(tasksRepositoryProvider),
  ref.watch(projectsRepositoryProvider),
  ref.watch(notificationServiceProvider),
  ref.watch(settingsRepositoryProvider),
    ));

final inboxServiceProvider = Provider((ref) => InboxService(
      ref.watch(inboxRepositoryProvider),
      ref.watch(taskServiceProvider),
    ));

final reviewServiceProvider = Provider((ref) => ReviewService(
      ref.watch(reviewRepositoryProvider),
      ref.watch(tasksRepositoryProvider),
      ref.watch(inboxRepositoryProvider),
      ref.watch(projectsRepositoryProvider),
    ));

final projectServiceProvider = Provider((ref) => ProjectService(
      ref.watch(projectsRepositoryProvider),
    ));

final inboxItemsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(inboxRepositoryProvider).watchAll();
});

final tasksProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(tasksRepositoryProvider).watchAll();
});

final projectsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(projectsRepositoryProvider).watchAll();
});

final reviewLogsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(reviewRepositoryProvider).watchAll();
});

final selectedContextFilterProvider = StateProvider<TaskContext?>((ref) => null);
final selectedEnergyFilterProvider = StateProvider<EnergyLevel?>((ref) => null);
final selectedTimeFilterProvider = StateProvider<TimeWindow?>((ref) => null);
final selectedStatusProvider = StateProvider<TaskStatus>((ref) => TaskStatus.nextAction);
