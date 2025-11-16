import 'package:uuid/uuid.dart';

import '../models/energy_level.dart';
import '../models/task.dart';
import '../models/task_context.dart';
import '../models/task_status.dart';
import '../repositories/projects_repository.dart';
import '../repositories/tasks_repository.dart';
import 'notification_service.dart';
import '../repositories/settings_repository.dart';

class TaskService {
  TaskService(this._tasksRepository, this._projectsRepository, this._notificationService, this._settingsRepository);

  final ITasksRepository _tasksRepository;
  final IProjectsRepository _projectsRepository;
  final NotificationService _notificationService;
  final ISettingsRepository _settingsRepository;
  final _uuid = const Uuid();

  Future<Task> createTask({
    required String title,
    String? description,
    required TaskContext context,
    String? projectId,
    DateTime? dueDate,
    TaskStatus status = TaskStatus.nextAction,
    EnergyLevel energyLevel = EnergyLevel.medium,
    int? durationMinutes,
    bool markDone = false,
    bool notify = false,
    bool isTwoMinuteCandidate = false,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      context: context,
      projectId: projectId,
      dueDate: dueDate,
      status: markDone ? TaskStatus.done : status,
      createdAt: DateTime.now(),
      energyLevel: energyLevel,
      durationMinutes: durationMinutes,
      isTwoMinuteCandidate: isTwoMinuteCandidate,
    );
    await upsertTask(task, notify: notify && dueDate != null);
    return task;
  }

  Future<void> upsertTask(Task task, {bool notify = false}) async {
    final existing = _tasksRepository.byId(task.id);
    if (existing?.projectId != task.projectId) {
      if (existing?.projectId != null) {
        await _projectsRepository.detachTask(existing!.projectId!, task.id);
      }
      if (task.projectId != null) {
        await _projectsRepository.attachTask(task.projectId!, task.id);
      }
    }
    await _tasksRepository.upsertTask(task);
    final notificationsEnabled = _settingsRepository.notificationsEnabled();

    if (notify && task.dueDate != null && notificationsEnabled) {
      await _notificationService.scheduleDueDateNotification(
        id: task.id,
        title: task.title,
        dueDate: task.dueDate!,
      );
    } else {
      // Either no notify requested, no due date, or notifications disabled -> cancel existing
      await _notificationService.cancelNotification(task.id);
    }
  }

  Future<void> deleteTask(Task task) async {
    if (task.projectId != null) {
      await _projectsRepository.detachTask(task.projectId!, task.id);
    }
    await _notificationService.cancelNotification(task.id);
    await _tasksRepository.deleteTask(task.id);
  }

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    final task = _tasksRepository.byId(taskId);
    if (task == null) return;
    await _tasksRepository.upsertTask(task.copyWith(status: status));
  }
}
