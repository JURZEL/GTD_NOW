import 'package:uuid/uuid.dart';

import '../models/project.dart';
import '../repositories/projects_repository.dart';

class ProjectService {
  ProjectService(this._repository);

  final IProjectsRepository _repository;
  final _uuid = const Uuid();

  Future<Project> createProject({
    required String name,
    String? description,
    DateTime? deadline,
  }) async {
    final project = Project(
      id: _uuid.v4(),
      name: name,
      description: description,
      deadline: deadline,
    );
    await _repository.upsert(project);
    return project;
  }

  Future<void> updateProject(Project project) => _repository.upsert(project);
}
