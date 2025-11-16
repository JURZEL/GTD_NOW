import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import '../../core/extensions/date_extensions.dart';
import 'package:gtd_student/core/providers.dart';
import '../../data/models/task.dart';
import '../../data/models/task_status.dart';
import '../tasks/edit_task_page.dart';

class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final isDone = task.status == TaskStatus.done;
  final colorScheme = Theme.of(context).colorScheme;

    // Build a compact, single-line-ish chips row with overflow indicator
    final chips = <Widget>[];
    void addChip(Widget c) => chips.add(Padding(padding: const EdgeInsets.only(right: 8), child: c));

    addChip(Chip(label: Text(task.context.label), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
    addChip(Chip(label: Text(task.energyLevel.label), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
    if (task.durationMinutes != null) addChip(Chip(label: Text(AppLocalizations.of(context)!.minutesLabel(task.durationMinutes!))));
    if (task.dueDate != null) addChip(Chip(avatar: const Icon(Icons.event, size: 18), label: Text(task.dueDate!.toLocalDate())));
    addChip(Chip(backgroundColor: colorScheme.secondaryContainer, label: Text(task.status.label), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
    if (task.isTwoMinuteCandidate) addChip(Chip(label: Text(AppLocalizations.of(context)!.twoMinuteChip), avatar: const Icon(Icons.bolt, size: 16)));

  // Limit visible chips to keep tile height consistent
  const maxVisibleChips = 4;
  final visibleChips = chips.length <= maxVisibleChips ? chips : chips.sublist(0, maxVisibleChips);
  final overflowCount = chips.length - visibleChips.length;

  // Also build raw chip widgets (without right padding) for the details sheet
  final rawChips = <Widget>[];
  rawChips.add(Chip(label: Text(task.context.label), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
  rawChips.add(Chip(label: Text(task.energyLevel.label), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
  if (task.durationMinutes != null) rawChips.add(Chip(label: Text(AppLocalizations.of(context)!.minutesLabel(task.durationMinutes!))));
  // dueDate will be shown in its own row; still expose it in details
  if (task.dueDate != null) rawChips.add(Chip(avatar: const Icon(Icons.event, size: 18), label: Text(task.dueDate!.toLocalDate())));
  rawChips.add(Chip(backgroundColor: colorScheme.secondaryContainer, label: Text(task.status.label), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
  if (task.isTwoMinuteCandidate) rawChips.add(Chip(label: Text(AppLocalizations.of(context)!.twoMinuteChip), avatar: const Icon(Icons.bolt, size: 16)));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        dense: true,
        // Reduce vertical padding for a denser look
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Tooltip(
          message: AppLocalizations.of(context)!.applyLabel,
          child: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            value: isDone,
            onChanged: (value) => ref
                .read(taskServiceProvider)
                .updateStatus(task.id, value == true ? TaskStatus.done : TaskStatus.nextAction),
          ),
        ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(decoration: isDone ? TextDecoration.lineThrough : null),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            // Show due date in a dedicated row for consistent layout
            if (task.dueDate != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 16),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.dueLabel(task.dueDate!.toLocalDate())),
                  ],
                ),
              ),
            // Horizontal scroller for chips to keep a single line and avoid variable wrapping
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        for (final c in visibleChips) c,
                        if (overflowCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              children: [
                                Tooltip(message: AppLocalizations.of(context)!.reviewLog, child: Chip(label: Text(AppLocalizations.of(context)!.overflowCount(overflowCount)))),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (ctx) {
                                        return DraggableScrollableSheet(
                                          expand: false,
                                          initialChildSize: 0.45,
                                          minChildSize: 0.25,
                                          maxChildSize: 0.9,
                                          builder: (context, controller) {
                                            return Padding(
                                              padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
                                              child: ListView(
                                                controller: controller,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(task.title, style: Theme.of(context).textTheme.titleMedium),
                                                      IconButton(
                                                        icon: const Icon(Icons.close),
                                                        onPressed: () => Navigator.of(ctx).pop(),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  if (task.description != null && task.description!.isNotEmpty) ...[
                                                    Text(task.description!),
                                                    const SizedBox(height: 12),
                                                  ],
                                                  if (task.dueDate != null) ...[
                                                    Row(children: [const Icon(Icons.event), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.dueLabel(task.dueDate!.toLocalDate()))]),
                                                    const SizedBox(height: 12),
                                                  ],
                                                  Wrap(spacing: 8, runSpacing: 8, children: rawChips),
                                                  const SizedBox(height: 12),
                                                  // Quick snooze options and move-to-project control
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(AppLocalizations.of(context)!.snooze),
                                                        const SizedBox(width: 8),
                                                        // Build snooze presets dynamically from provider
                                                        Builder(builder: (sCtx) {
                                                          final presets = ref.watch(snoozePresetsProvider);
                                                          return Row(
                                                            children: [
                                                              for (final minutes in presets) ...[
                                                                OutlinedButton(
                                                                  child: Text(minutes >= 60 ? AppLocalizations.of(context)!.hoursLabel(minutes ~/ 60) : AppLocalizations.of(context)!.minutesLabel(minutes)),
                                                                  onPressed: () async {
                                                                    final newDue = DateTime.now().add(Duration(minutes: minutes));
                                                                    await ref.read(taskServiceProvider).upsertTask(task.copyWith(dueDate: newDue));
                                                                  },
                                                                ),
                                                                const SizedBox(width: 6),
                                                              ],
                                                            ],
                                                          );
                                                        }),
                                                        const SizedBox(width: 12),
                                                        // Move to project dropdown
                                                        Expanded(
                                                            child: Builder(builder: (ctx) {
                                                              final projectsAsync = ref.watch(projectsProvider);
                                                              return projectsAsync.when(
                                                                data: (list) => DropdownButton<String?>(
                                                                  isExpanded: true,
                                                                  value: task.projectId,
                                                                  hint: Text(AppLocalizations.of(context)!.moveToProject),
                                                                  items: [
                                                                    DropdownMenuItem<String?>(value: null, child: Text(AppLocalizations.of(context)!.noProject)),
                                                                    ...list.map((p) => DropdownMenuItem<String?>(value: p.id, child: Text(p.name)))
                                                                  ],
                                                                  onChanged: (val) async {
                                                                    await ref.read(taskServiceProvider).upsertTask(task.copyWith(projectId: val));
                                                                  },
                                                                ),
                                                                loading: () => const SizedBox.shrink(),
                                                                error: (_, __) => const SizedBox.shrink(),
                                                              );
                                                            }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton.icon(
                                                          icon: const Icon(Icons.edit),
                                                          label: Text(AppLocalizations.of(context)!.edit),
                                                          onPressed: () async {
                                                            Navigator.of(ctx).pop();
                                                            // Navigate to dedicated full-screen edit page
                                                            Navigator.of(ctx).push(MaterialPageRoute(builder: (pCtx) => EditTaskPage(task: task)));
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: OutlinedButton.icon(
                                                          icon: const Icon(Icons.calendar_today),
                                                          label: Text(AppLocalizations.of(context)!.reschedule),
                                                          onPressed: () async {
                                                            Navigator.of(ctx).pop();
                                                            final picked = await showDatePicker(
                                                              context: ctx,
                                                              firstDate: DateTime.now().subtract(const Duration(days: 1)),
                                                              lastDate: DateTime.now().add(const Duration(days: 365)),
                                                              initialDate: task.dueDate ?? DateTime.now(),
                                                            );
                                                            if (picked != null) {
                                                              await ref.read(taskServiceProvider).upsertTask(task.copyWith(dueDate: picked));
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: FilledButton.icon(
                                                          icon: Icon(task.status == TaskStatus.done ? Icons.undo : Icons.check),
                                                          label: Text(task.status == TaskStatus.done ? AppLocalizations.of(context)!.markUndone : AppLocalizations.of(context)!.markDone),
                                                          onPressed: () async {
                                                            Navigator.of(ctx).pop();
                                                            await ref.read(taskServiceProvider).updateStatus(task.id, task.status == TaskStatus.done ? TaskStatus.nextAction : TaskStatus.done);
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      OutlinedButton.icon(
                                                        icon: const Icon(Icons.delete_outline),
                                                        label: Text(AppLocalizations.of(context)!.delete),
                                                        onPressed: () async {
                                                          final sheetNav = Navigator.of(ctx);
                                                          final confirm = await showDialog<bool>(context: ctx, builder: (d) => AlertDialog(
                                                            title: Text(AppLocalizations.of(d)!.confirmDeleteTitle),
                                                            content: Text(AppLocalizations.of(d)!.confirmDeleteProject(task.title)),
                                                            actions: [
                                                              TextButton(onPressed: () => Navigator.of(d).pop(false), child: Text(AppLocalizations.of(d)!.cancel)),
                                                              FilledButton(onPressed: () => Navigator.of(d).pop(true), child: Text(AppLocalizations.of(d)!.delete)),
                                                            ],
                                                          ));
                                                          if (confirm == true) {
                                                            sheetNav.pop();
                                                            await ref.read(taskServiceProvider).deleteTask(task);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Tooltip(
                                      message: AppLocalizations.of(context)!.showDetails,
                                    child: Icon(Icons.expand_more, size: 18, semanticLabel: AppLocalizations.of(context)!.showDetails),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<TaskStatus>(
          icon: const Icon(Icons.more_vert),
          tooltip: AppLocalizations.of(context)!.more,
          onSelected: (status) => ref.read(taskServiceProvider).updateStatus(task.id, status),
          itemBuilder: (context) => TaskStatus.values
              .map(
                (status) => PopupMenuItem(
                  value: status,
                  child: Text(status.label),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
