import 'package:uuid/uuid.dart';

import '../models/review_log.dart';
import '../models/task_status.dart';
import '../repositories/inbox_repository.dart';
import '../repositories/projects_repository.dart';
import '../repositories/review_repository.dart';
import '../repositories/tasks_repository.dart';

class ReviewService {
  ReviewService(
    this._reviewRepository,
    this._tasksRepository,
    this._inboxRepository,
    this._projectsRepository,
  );

  final ReviewRepository _reviewRepository;
  final ITasksRepository _tasksRepository;
  final InboxRepository _inboxRepository;
  final IProjectsRepository _projectsRepository;
  final _uuid = const Uuid();

  Future<void> logReview(String notes) async {
    final log = ReviewLog(
      id: _uuid.v4(),
      date: DateTime.now(),
      notes: notes,
    );
    await _reviewRepository.addLog(log);
  }

  Future<void> clearInbox() => _inboxRepository.clear();

  Future<Map<String, int>> openTasksPerProject() async {
    final projects = _projectsRepository.allProjects();
    final tasks = _tasksRepository.allTasks();
    return {
      for (final project in projects)
        project.name: tasks
            .where((task) => task.projectId == project.id &&
                task.status != TaskStatus.done)
            .length
    };
  }
}
