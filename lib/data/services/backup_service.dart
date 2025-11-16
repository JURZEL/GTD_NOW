import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/energy_level.dart';
import '../models/inbox_item.dart';
import '../models/project.dart';
import '../models/review_log.dart';
import '../models/task.dart';
import '../models/task_context.dart';
import '../models/task_status.dart';
import '../repositories/inbox_repository.dart';
import '../repositories/projects_repository.dart';
import '../repositories/review_repository.dart';
import '../repositories/tasks_repository.dart';

class BackupService {
  BackupService(
    this._tasksRepository,
    this._projectsRepository,
    this._inboxRepository,
    this._reviewRepository,
  );

  final ITasksRepository _tasksRepository;
  final IProjectsRepository _projectsRepository;
  final InboxRepository _inboxRepository;
  final ReviewRepository _reviewRepository;

  Future<File> exportData() async {
    final file = await _defaultFile();
    final payload = <String, dynamic>{
      'tasks': _tasksRepository.allTasks().map((e) => _taskToJson(e)).toList(),
      'projects':
          _projectsRepository.allProjects().map((e) => _projectToJson(e)).toList(),
    'inbox':
      _inboxRepository.items().map((e) => _inboxItemToJson(e)).toList(),
      'reviews': _reviewRepository.logs().map((e) => _reviewToJson(e)).toList(),
    };
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(payload));
    return file;
  }

  Future<void> importData(File file) async {
    if (!await file.exists()) return;
    final content = await file.readAsString();
    final Map<String, dynamic> data = jsonDecode(content);
    final tasksBox = _tasksRepository;
    final projectsBox = _projectsRepository;

    for (final project in (data['projects'] as List<dynamic>? ?? [])) {
      await projectsBox.upsert(Project(
        id: project['id'] as String,
        name: project['name'] as String,
        description: project['description'] as String?,
        deadline: project['deadline'] != null
            ? DateTime.parse(project['deadline'] as String)
            : null,
        taskIds: (project['taskIds'] as List<dynamic>).cast<String>(),
      ));
    }

    for (final task in (data['tasks'] as List<dynamic>? ?? [])) {
      await tasksBox.upsertTask(Task(
        id: task['id'] as String,
        title: task['title'] as String,
        description: task['description'] as String?,
        context: TaskContext.values[task['context'] as int],
        projectId: task['projectId'] as String?,
        dueDate: task['dueDate'] != null
            ? DateTime.parse(task['dueDate'] as String)
            : null,
        status: TaskStatus.values[task['status'] as int],
        createdAt: DateTime.parse(task['createdAt'] as String),
        energyLevel: EnergyLevel.values[task['energyLevel'] as int],
        durationMinutes: task['durationMinutes'] as int?,
        isTwoMinuteCandidate: task['isTwoMinuteCandidate'] as bool? ?? false,
      ));
    }

    for (final inbox in (data['inbox'] as List<dynamic>? ?? [])) {
      await _inboxRepository.addItem(InboxItem(
        id: inbox['id'] as String,
        content: inbox['content'] as String,
        createdAt: DateTime.parse(inbox['createdAt'] as String),
        processed: inbox['processed'] as bool? ?? false,
      ));
    }

    for (final review in (data['reviews'] as List<dynamic>? ?? [])) {
      await _reviewRepository.addLog(ReviewLog(
        id: review['id'] as String,
        date: DateTime.parse(review['date'] as String),
        notes: review['notes'] as String,
      ));
    }
  }

  Future<void> importLatestBackup() async {
    final file = await _defaultFile();
    await importData(file);
  }

  Future<File> _defaultFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/gtd_student_backup.json');
  }

  Map<String, dynamic> _taskToJson(Task task) => {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'context': task.context.index,
        'projectId': task.projectId,
        'dueDate': task.dueDate?.toIso8601String(),
        'status': task.status.index,
        'createdAt': task.createdAt.toIso8601String(),
        'energyLevel': task.energyLevel.index,
        'durationMinutes': task.durationMinutes,
        'isTwoMinuteCandidate': task.isTwoMinuteCandidate,
      };

  Map<String, dynamic> _projectToJson(Project project) => {
        'id': project.id,
        'name': project.name,
        'description': project.description,
        'deadline': project.deadline?.toIso8601String(),
        'taskIds': project.taskIds,
      };

  Map<String, dynamic> _inboxItemToJson(InboxItem item) => {
        'id': item.id,
        'content': item.content,
        'createdAt': item.createdAt.toIso8601String(),
        'processed': item.processed,
      };

  Map<String, dynamic> _reviewToJson(ReviewLog log) => {
        'id': log.id,
        'date': log.date.toIso8601String(),
        'notes': log.notes,
      };
}
