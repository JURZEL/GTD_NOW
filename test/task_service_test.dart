import 'package:flutter_test/flutter_test.dart';
import 'package:gtd_student/data/models/task.dart';
import 'package:gtd_student/data/models/task_context.dart';
// unused imports removed
import 'package:gtd_student/data/services/task_service.dart';
import 'package:gtd_student/data/services/notification_service.dart';
import 'package:gtd_student/data/repositories/settings_repository.dart';
import 'package:gtd_student/data/repositories/tasks_repository.dart';
import 'package:gtd_student/data/repositories/projects_repository.dart';
import 'package:gtd_student/data/models/project.dart';

// Fake implementations
class FakeTasksRepository implements ITasksRepository {
  final Map<String, Task> _store = {};
  @override
  Task? byId(String id) => _store[id];

  @override
  Future<void> upsertTask(Task task) async => _store[task.id] = task;

  @override
  Future<void> deleteTask(String id) async => _store.remove(id);

  @override
  List<Task> allTasks() => _store.values.toList();

  @override
  Stream<List<Task>> watchAll() async* {
    yield allTasks();
  }

  @override
  List<Task> tasksByStatus(status) => allTasks();
}

class FakeProjectsRepository implements IProjectsRepository {
  @override
  Future<void> attachTask(String projectId, String taskId) async {}

  @override
  Future<void> detachTask(String projectId, String taskId) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Project? byId(String id) => null;

  @override
  List<Project> allProjects() => [];

  @override
  Stream<List<Project>> watchAll() async* {
    yield [];
  }

  @override
  Future<void> upsert(Project project) async {}
}

class FakeNotificationService implements NotificationService {
  final List<String> scheduled = [];
  final List<String> cancelled = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleDueDateNotification({required String id, required String title, required DateTime dueDate}) async {
    scheduled.add(id);
  }

  @override
  Future<void> cancelNotification(String id) async {
    cancelled.add(id);
  }

  // The interface has other methods; implement as no-op
  @override
  Future<bool> requestPermissions() async => true;

  @override
  bool get hasPermissions => true;

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> setLocalizedStrings({
    required String channelName,
    required String channelDescription,
    required String notificationTitleTemplate,
    required String notificationBody,
    required String linuxDefaultActionName,
  }) async {}

  @override
  List<Map<String, dynamic>> getFallbackScheduled() => [];

  @override
  Future<void> clearFallbackScheduled() async {}
}

class FakeSettingsRepository implements ISettingsRepository {
  FakeSettingsRepository(this._enabled);
  bool _enabled;
  @override
  bool notificationsEnabled() => _enabled;
  @override
  Future<void> setNotificationsEnabled(bool enabled) async => _enabled = enabled;
  @override
  String? appLocale() => null;

  @override
  Future<void> setAppLocale(String? localeTag) async {}

  @override
  List<int> snoozePresets() => [10, 30, 60];

  @override
  Future<void> setSnoozePresets(List<int> presets) async {}
}

void main() {
  test('schedules notification when enabled and notify flag true', () async {
    final tasksRepo = FakeTasksRepository();
    final projectsRepo = FakeProjectsRepository();
    final notif = FakeNotificationService();
    final settings = FakeSettingsRepository(true);

    final service = TaskService(tasksRepo as dynamic, projectsRepo as dynamic, notif, settings);

    final task = Task(
      id: 't1',
      title: 'Test',
      context: TaskContext.laptop,
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(minutes: 30)),
    );

    await service.upsertTask(task, notify: true);

    expect(notif.scheduled, contains('t1'));
  });

  test('cancels notification when disabled', () async {
    final tasksRepo = FakeTasksRepository();
    final projectsRepo = FakeProjectsRepository();
    final notif = FakeNotificationService();
    final settings = FakeSettingsRepository(false);

    final service = TaskService(tasksRepo as dynamic, projectsRepo as dynamic, notif, settings);

    final task = Task(
      id: 't2',
      title: 'Test2',
      context: TaskContext.laptop,
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(hours: 1)),
    );

    await service.upsertTask(task, notify: true);

    expect(notif.scheduled, isEmpty);
    expect(notif.cancelled, contains('t2'));
  });
}
