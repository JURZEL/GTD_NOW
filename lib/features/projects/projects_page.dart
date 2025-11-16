import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import 'package:gtd_student/core/extensions/date_extensions.dart';
import 'package:gtd_student/core/providers.dart';
import '../../data/models/project.dart';
import '../../data/models/task.dart';
import '../widgets/task_tile.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final tasks = ref.watch(tasksProvider);
    return projects.when(
      data: (projectList) => tasks.when(
        data: (taskList) {
          final loc = AppLocalizations.of(context)!;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              FilledButton.icon(
                onPressed: () => _openProjectDialog(context, ref),
                icon: const Icon(Icons.add),
                label: Text(loc.createProject),
              ),
                const SizedBox(height: 12),
              if (projectList.isEmpty) Text(loc.noProjectsYet),
              for (final project in projectList)
                _ProjectCard(
                  project: project,
                  tasks: taskList.where((task) => task.projectId == project.id).toList(),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(AppLocalizations.of(context)!.errorWith(error.toString()))),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(AppLocalizations.of(context)!.errorWith(error.toString()))),
    );
  }

  Future<void> _openProjectDialog(BuildContext context, WidgetRef ref) {
    return showDialog<void>(
      context: context,
      builder: (_) => _ProjectDialog(ref: ref),
    );
  }
}

// _ProjectCard (stateless) removed in favor of the ConsumerWidget version below.

class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.project, required this.tasks});

  final Project project;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: colored container to visually separate project title from tasks
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      if (project.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            project.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) async {
                    if (val == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!.confirmDeleteTitle),
                          content: Text(AppLocalizations.of(context)!.confirmDeleteProject(project.name)),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(AppLocalizations.of(context)!.cancel)),
                            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(AppLocalizations.of(context)!.delete)),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ref.read(projectsRepositoryProvider).delete(project.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.projectDeleted(project.name))));
                        }
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context)!.delete)),
                  ],
                ),
              ],
            ),
          ),
          // Body padding and content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (project.deadline != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.event, size: 16),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.deadlineLabel(project.deadline!.toLocalDate())),
                      ],
                    ),
                  ),
                Text(AppLocalizations.of(context)!.openTasksCount(tasks.length), style: Theme.of(context).textTheme.titleMedium),
                if (tasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(AppLocalizations.of(context)!.noOpenTasks),
                  ),
                for (var i = 0; i < tasks.length; i++) ...[
                  TaskTile(task: tasks[i]),
                  if (i < tasks.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectDialog extends StatefulWidget {
  const _ProjectDialog({required this.ref});

  final WidgetRef ref;

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _deadline;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(loc.dialogCreateProjectTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: loc.projectLabel)),
          const SizedBox(height: 8),
          TextField(controller: _descriptionController, decoration: InputDecoration(labelText: loc.descriptionLabel)),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _pickDeadline,
                icon: const Icon(Icons.event),
                label: Text(_deadline?.toLocalDate() ?? loc.chooseDate),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(loc.cancel)),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? loc.saving : loc.save),
        ),
      ],
    );
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await widget.ref.read(projectServiceProvider).createProject(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          deadline: _deadline,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
