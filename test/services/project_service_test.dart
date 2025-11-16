import 'package:flutter_test/flutter_test.dart';
import 'package:gtd_student/data/models/project.dart';
import 'package:gtd_student/data/repositories/projects_repository.dart';
import 'package:gtd_student/data/services/project_service.dart';

class _FakeRepo implements IProjectsRepository {
  final Map<String, Project> _data = {};

  @override
  Future<void> attachTask(String projectId, String taskId) async {}

  @override
  Future<void> detachTask(String projectId, String taskId) async {}

  @override
  Project? byId(String id) => _data[id];

  @override
  List<Project> allProjects() => _data.values.toList();

  @override
  Future<void> delete(String id) async {
    _data.remove(id);
  }

  @override
  Stream<List<Project>> watchAll() async* {
    yield allProjects();
  }

  @override
  Future<void> upsert(Project project) async {
    _data[project.id] = project;
  }
}

void main() {
  test('ProjectService create and delete', () async {
    final repo = _FakeRepo();
    final service = ProjectService(repo);

    final project = await service.createProject(name: 'T1', description: 'D', deadline: null);
    expect(project.name, 'T1');
    expect(repo.byId(project.id) != null, true);

    await repo.delete(project.id);
    expect(repo.byId(project.id), isNull);
  });
}
