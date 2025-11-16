import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/providers.dart';
import '../../data/models/task.dart';
import '../../data/models/project.dart';

class GtdSearchDelegate extends SearchDelegate {
  GtdSearchDelegate(this.ref);

  final WidgetRef ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildContent(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildContent(context);

  Widget _buildContent(BuildContext context) {
    final tasks = ref.read(tasksRepositoryProvider).allTasks();
    final projects = ref.read(projectsRepositoryProvider).allProjects();
    final q = query.toLowerCase();
    final taskMatches = tasks.where((task) {
      if (q.isEmpty) return true;
      return task.title.toLowerCase().contains(q) ||
          (task.description ?? '').toLowerCase().contains(q);
    }).toList();
    final projectMatches = projects.where((project) {
      if (q.isEmpty) return false;
      return project.name.toLowerCase().contains(q);
    }).toList();

    final loc = AppLocalizations.of(context)!;

    return ListView(
      children: [
        if (projectMatches.isNotEmpty) ListTile(title: Text(loc.navProjects)),
        ...projectMatches.map((project) => _projectTile(context, project)),
        if (taskMatches.isNotEmpty) ListTile(title: Text(loc.searchTasks)),
        ...taskMatches.map((task) => _taskTile(context, task)),
        if (projectMatches.isEmpty && taskMatches.isEmpty)
          ListTile(title: Text(loc.searchNoResults)),
      ],
    );
  }

  Widget _projectTile(BuildContext context, Project project) {
    final loc = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(project.name),
      subtitle: project.deadline != null
          ? Text(loc.deadlineLabel(project.deadline!.toLocalDate()))
          : null,
      onTap: () => close(context, project.name),
    );
  }

  Widget _taskTile(BuildContext context, Task task) {
    final loc = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description != null) Text(task.description!),
          if (task.dueDate != null) Text(loc.dueLabel(task.dueDate!.toLocalDate())),
        ],
      ),
    );
  }
}
