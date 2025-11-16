import 'package:uuid/uuid.dart';

import '../models/inbox_item.dart';
import '../models/task_context.dart';
import '../models/task_status.dart';
import '../models/energy_level.dart';
import '../repositories/inbox_repository.dart';
import 'task_service.dart';

class InboxService {
  InboxService(this._repository, this._taskService);

  final InboxRepository _repository;
  final TaskService _taskService;
  final _uuid = const Uuid();

  Future<void> captureQuick(String content) async {
    if (content.trim().isEmpty) return;
    final item = InboxItem(
      id: _uuid.v4(),
      content: content.trim(),
      createdAt: DateTime.now(),
    );
    await _repository.addItem(item);
  }

  Future<void> delete(String id) async => _repository.deleteItem(id);

  Future<void> toggleProcessed(String id, bool processed) async =>
      _repository.markProcessed(id, processed: processed);

  Future<void> convertToTask({
    required InboxItem item,
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
    bool twoMinuteRule = false,
  }) async {
    await _taskService.createTask(
      title: title,
      description: description,
      context: context,
      projectId: projectId,
      dueDate: dueDate,
      status: status,
      energyLevel: energyLevel,
      durationMinutes: durationMinutes,
      markDone: markDone,
      notify: notify,
      isTwoMinuteCandidate: twoMinuteRule,
    );
    await _repository.deleteItem(item.id);
  }
}
