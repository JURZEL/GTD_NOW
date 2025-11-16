import 'package:hive_flutter/hive_flutter.dart';

/// Interface for settings repository to make testing easier.
abstract class ISettingsRepository {
  bool notificationsEnabled();
  Future<void> setNotificationsEnabled(bool enabled);
  /// Returns stored app locale tag (e.g. 'de_DE', 'en_GB') or null when using system default
  String? appLocale();

  /// Persist app locale tag. Pass null to clear override and use system default.
  Future<void> setAppLocale(String? localeTag);
  /// Get snooze presets in minutes (e.g. [10,30,60])
  List<int> snoozePresets();

  /// Persist snooze presets
  Future<void> setSnoozePresets(List<int> presets);
}

class SettingsRepository implements ISettingsRepository {
  SettingsRepository(this._box);

  final Box _box;

  @override
  bool notificationsEnabled() {
    return _box.get('notifications_enabled', defaultValue: true) as bool;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _box.put('notifications_enabled', enabled);
  }

  @override
  String? appLocale() => _box.get('app_locale') as String?;

  @override
  Future<void> setAppLocale(String? localeTag) async {
    if (localeTag == null) {
      await _box.delete('app_locale');
    } else {
      await _box.put('app_locale', localeTag);
    }
  }

  String themeMode() => _box.get('theme_mode', defaultValue: 'system') as String;

  Future<void> setThemeMode(String mode) async {
    await _box.put('theme_mode', mode);
  }

  @override
  List<int> snoozePresets() {
    final raw = _box.get('snooze_presets') as List<dynamic>?;
    if (raw == null) return [10, 30, 60];
    return raw.map((e) => e as int).toList();
  }

  @override
  Future<void> setSnoozePresets(List<int> presets) async {
    await _box.put('snooze_presets', presets);
  }
}
