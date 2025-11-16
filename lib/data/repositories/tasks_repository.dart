import 'package:hive_flutter/hive_flutter.dart';

import '../local/hive_boxes.dart';
import '../models/task.dart';
import '../models/task_status.dart';

abstract class ITasksRepository {
  List<Task> allTasks();
  Stream<List<Task>> watchAll();
  List<Task> tasksByStatus(TaskStatus status);
  Future<void> upsertTask(Task task);
  Future<void> deleteTask(String id);
  Task? byId(String id);
}

class TasksRepository implements ITasksRepository {
  TasksRepository() : _box = Hive.box<Task>(HiveBoxes.tasks);

  final Box<Task> _box;

  @override
  List<Task> allTasks() => _box.values.toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  @override
  Stream<List<Task>> watchAll() async* {
    yield allTasks();
    await for (final _ in _box.watch()) {
      yield allTasks();
    }
  }

  @override
  List<Task> tasksByStatus(TaskStatus status) => allTasks()
      .where((task) => task.status == status)
      .toList();

  @override
  Future<void> upsertTask(Task task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  Task? byId(String id) => _box.get(id);
}
