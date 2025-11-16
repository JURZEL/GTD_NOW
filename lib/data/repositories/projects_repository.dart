import 'package:hive_flutter/hive_flutter.dart';

import '../local/hive_boxes.dart';
import '../models/project.dart';

abstract class IProjectsRepository {
  List<Project> allProjects();
  Stream<List<Project>> watchAll();
  Future<void> upsert(Project project);
  Future<void> delete(String id);
  Project? byId(String id);
  Future<void> attachTask(String projectId, String taskId);
  Future<void> detachTask(String projectId, String taskId);
}

class ProjectsRepository implements IProjectsRepository {
  ProjectsRepository() : _box = Hive.box<Project>(HiveBoxes.projects);

  final Box<Project> _box;

  @override
  List<Project> allProjects() => _box.values.toList()
    ..sort((a, b) => a.name.compareTo(b.name));

  @override
  Stream<List<Project>> watchAll() async* {
    yield allProjects();
    await for (final _ in _box.watch()) {
      yield allProjects();
    }
  }

  @override
  Future<void> upsert(Project project) async {
    await _box.put(project.id, project);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Project? byId(String id) => _box.get(id);

  @override
  Future<void> attachTask(String projectId, String taskId) async {
    final project = _box.get(projectId);
    if (project == null) return;
    if (!project.taskIds.contains(taskId)) {
      project.taskIds = [...project.taskIds, taskId];
      await project.save();
    }
  }

  @override
  Future<void> detachTask(String projectId, String taskId) async {
    final project = _box.get(projectId);
    if (project == null) return;
    project.taskIds = project.taskIds.where((id) => id != taskId).toList();
    await project.save();
  }
}
