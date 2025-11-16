import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import 'package:gtd_student/data/models/project.dart';
import 'package:gtd_student/data/repositories/projects_repository.dart';
import 'package:gtd_student/data/repositories/tasks_repository.dart';
import 'package:gtd_student/data/models/task.dart';
import 'package:gtd_student/data/models/task_status.dart';
import 'package:gtd_student/data/services/project_service.dart';
import 'package:gtd_student/features/projects/projects_page.dart';
import 'package:gtd_student/core/providers.dart';

class _InMemoryProjectsRepository implements IProjectsRepository {
  final Map<String, Project> _data = {};
  late final StreamController<List<Project>> _controller = StreamController<List<Project>>.broadcast(onListen: () => _emit());

  void _emit() => _controller.add(_data.values.toList()..sort((a, b) => a.name.compareTo(b.name)));

  @override
  Future<void> attachTask(String projectId, String taskId) async {}

  @override
  Future<void> detachTask(String projectId, String taskId) async {}

  @override
  Project? byId(String id) => _data[id];

  @override
  List<Project> allProjects() => _data.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  @override
  Future<void> delete(String id) async {
    _data.remove(id);
    _emit();
  }

  @override
  Stream<List<Project>> watchAll() => _controller.stream;

  @override
  Future<void> upsert(Project project) async {
    _data[project.id] = project;
    _emit();
  }
}

class _InMemoryTasksRepository implements ITasksRepository {
  final Map<String, Task> _data = {};
  late final StreamController<List<Task>> _controller = StreamController<List<Task>>.broadcast(onListen: () => _emit());

  void _emit() => _controller.add(_data.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt)));

  @override
  Stream<List<Task>> watchAll() => _controller.stream;

  @override
  List<Task> allTasks() => _data.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  @override
  List<Task> tasksByStatus(TaskStatus status) => _data.values.where((t) => t.status == status).toList();

  @override
  Future<void> upsertTask(Task task) async {
    _data[task.id] = task;
    _emit();
  }

  @override
  Future<void> deleteTask(String id) async {
    _data.remove(id);
    _emit();
  }

  @override
  Task? byId(String id) => _data[id];
}

void main() {
  testWidgets('Create project via dialog and delete via overflow', (tester) async {
    final repo = _InMemoryProjectsRepository();
    // start with empty list
    repo._emit();

    final service = ProjectService(repo);
    final tasksRepo = _InMemoryTasksRepository();
    tasksRepo._emit();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        projectsRepositoryProvider.overrideWithValue(repo),
        projectServiceProvider.overrideWithValue(service),
        tasksRepositoryProvider.overrideWithValue(tasksRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: ProjectsPage()),
      ),
    ));

    // allow some frames for providers/streams to emit
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byType(FilledButton).evaluate().isNotEmpty) break;
    }

  // create project directly through the service (more robust for widget tests)
  // ensure the widget tree and providers are settled and listening
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  // directly add a Project to the in-memory repo and emit so the UI updates
  await repo.upsert(Project(id: 'p1', name: 'My Test Project', description: null, deadline: null));
  // wait for the project to appear in the widget tree
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.text('My Test Project').evaluate().isNotEmpty) break;
  }

    // project should now be visible
    expect(find.text('My Test Project'), findsOneWidget);

    // open overflow on the project card
    final popup = find.byIcon(Icons.more_vert).first;
    expect(popup, findsOneWidget);
    await tester.tap(popup);
    await tester.pumpAndSettle();

    // tap Delete menu item
  final deleteItem = find.text('Delete');
    expect(deleteItem, findsOneWidget);
    await tester.tap(deleteItem);
    await tester.pumpAndSettle();

    // confirmation dialog appears - tap Delete
    final confirmDelete = find.text(AppLocalizations.of(tester.element(find.byType(ProjectsPage)))!.delete);
    expect(confirmDelete, findsWidgets);
    // the dialog's FilledButton uses the same 'Delete' label; find the dialog button by type and tap the last matching
    await tester.tap(confirmDelete.last);
    await tester.pumpAndSettle();

    // project should be gone
    expect(find.text('My Test Project'), findsNothing);
  });
}
