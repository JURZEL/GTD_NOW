import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/time_window.dart';
import '../../core/providers.dart';
import '../../core/extensions/date_extensions.dart';
import 'package:gtd_student/l10n/app_localizations.dart';
import '../../data/models/task.dart';
import '../../data/models/task_context.dart';
import '../../data/models/task_status.dart';
import '../../data/models/energy_level.dart';
import '../widgets/task_tile.dart';

class ActionsPage extends ConsumerWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final loc = AppLocalizations.of(context)!;
    return tasksAsync.when(
      data: (tasks) {
        final filtered = _filterTasks(tasks, ref);
        final upcoming = _groupByDate(tasks);
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const _FiltersSection(),
            const SizedBox(height: 16),
            const _StatusTabs(),
            const SizedBox(height: 16),
            Text(loc.nextActionsTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              Text(loc.noActionsMessage)
            else ...[
              for (final task in filtered) TaskTile(task: task),
            ],
            const SizedBox(height: 24),
            if (upcoming.isNotEmpty) ...[
              Text(loc.calendarTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final entry in upcoming.entries.take(5))
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(entry.key.toLocalDate()),
                    subtitle: Text(entry.value.map((t) => t.title).join(', ')),
                  ),
                ),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(AppLocalizations.of(context)!.errorWith(error.toString()))),
    );
  }

  List<Task> _filterTasks(List<Task> tasks, WidgetRef ref) {
    final status = ref.watch(selectedStatusProvider);
    final contextFilter = ref.watch(selectedContextFilterProvider);
    final energyFilter = ref.watch(selectedEnergyFilterProvider);
    final timeFilter = ref.watch(selectedTimeFilterProvider);

    return tasks.where((task) {
      if (task.status != status) return false;
      if (contextFilter != null && task.context != contextFilter) return false;
      if (energyFilter != null && task.energyLevel != energyFilter) return false;
      if (timeFilter != null && !timeFilter.matches(task.durationMinutes)) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<DateTime, List<Task>> _groupByDate(List<Task> tasks) {
    final Map<DateTime, List<Task>> map = {};
    for (final task in tasks) {
      if (task.dueDate == null) continue;
      final date = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      map.putIfAbsent(date, () => []).add(task);
    }
    final entries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return {for (final e in entries) e.key: e.value};
  }
}

class _FiltersSection extends ConsumerWidget {
  const _FiltersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextFilter = ref.watch(selectedContextFilterProvider);
    final energyFilter = ref.watch(selectedEnergyFilterProvider);
    final timeFilter = ref.watch(selectedTimeFilterProvider);
    final loc = AppLocalizations.of(context)!;

    String summary() {
      final parts = <String>[];
      if (contextFilter != null) parts.add(contextFilter.label);
      if (energyFilter != null) parts.add(energyFilter.label);
      if (timeFilter != null) parts.add(timeFilter.label);
      if (parts.isEmpty) return loc.filterByContext; // fallback short title
      return parts.join(' • ');
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            summary(),
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // Filter button with optional active-count badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.filter_list),
              label: Text(loc.filterByContext),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.55,
                      minChildSize: 0.25,
                      maxChildSize: 0.95,
                      builder: (sheetCtx, controller) {
                        return Consumer(builder: (innerCtx, sheetRef, _) {
                          final cFilter = sheetRef.watch(selectedContextFilterProvider);
                          final eFilter = sheetRef.watch(selectedEnergyFilterProvider);
                          final tFilter = sheetRef.watch(selectedTimeFilterProvider);
                          return SafeArea(
                            child: Padding(
                              padding: MediaQuery.of(ctx).viewInsets.add(const EdgeInsets.all(16)),
                              child: ListView(
                                controller: controller,
                                shrinkWrap: true,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(loc.filterByContext, style: Theme.of(context).textTheme.titleMedium),
                                      TextButton(
                                        onPressed: () {
                                          sheetRef.read(selectedContextFilterProvider.notifier).state = null;
                                          sheetRef.read(selectedEnergyFilterProvider.notifier).state = null;
                                          sheetRef.read(selectedTimeFilterProvider.notifier).state = null;
                                        },
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(loc.energyLevel, style: Theme.of(context).textTheme.titleSmall),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: EnergyLevel.values.map((lvl) {
                                      final sel = eFilter == lvl;
                                      return FilterChip(
                                        label: Text(lvl.label),
                                        selected: sel,
                                        onSelected: (_) => sheetRef.read(selectedEnergyFilterProvider.notifier).state = sel ? null : lvl,
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(loc.timeWindow, style: Theme.of(context).textTheme.titleSmall),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: TimeWindow.values.map((w) {
                                      final sel = tFilter == w;
                                      return FilterChip(
                                        label: Text(w.label),
                                        selected: sel,
                                        onSelected: (_) => sheetRef.read(selectedTimeFilterProvider.notifier).state = sel ? null : w,
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(loc.filterByContext, style: Theme.of(context).textTheme.titleSmall),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: TaskContext.values.map((ctxVal) {
                                      final sel = cFilter == ctxVal;
                                      return FilterChip(
                                        label: Text(ctxVal.label),
                                        selected: sel,
                                        onSelected: (_) => sheetRef.read(selectedContextFilterProvider.notifier).state = sel ? null : ctxVal,
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FilledButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: Text(AppLocalizations.of(context)!.save),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      OutlinedButton(
                                        onPressed: () {
                                          sheetRef.read(selectedContextFilterProvider.notifier).state = null;
                                          sheetRef.read(selectedEnergyFilterProvider.notifier).state = null;
                                          sheetRef.read(selectedTimeFilterProvider.notifier).state = null;
                                        },
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                );
              },
            ),
            // badge
            if ((contextFilter != null ? 1 : 0) + (energyFilter != null ? 1 : 0) + (timeFilter != null ? 1 : 0) > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Center(
                    child: Text(
                      '${(contextFilter != null ? 1 : 0) + (energyFilter != null ? 1 : 0) + (timeFilter != null ? 1 : 0)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _StatusTabs extends ConsumerWidget {
  const _StatusTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(selectedStatusProvider);
    // Replace the always-visible chip row with a compact button that opens
    // a bottom sheet containing a radio list. This is more compact and
    // looks native on Android while keeping the same options.
    return Row(
      children: [
        Expanded(
          child: Text(
            status.label,
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: Text(status.label, key: ValueKey(status)),
          ),
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onPressed: () async {
            final chosen = await showModalBottomSheet<TaskStatus?>(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                final current = ref.read(selectedStatusProvider);
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.4,
                  minChildSize: 0.2,
                  maxChildSize: 0.9,
                  builder: (sheetCtx, controller) {
                    return SafeArea(
                      child: ListView(
                        controller: controller,
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Text(
                              'Status',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ...TaskStatus.values.map((s) {
                            final isSelected = current == s;
                            return ListTile(
                              title: Text(s.label),
                              trailing: isSelected ? const Icon(Icons.check) : null,
                              selected: isSelected,
                              onTap: () => Navigator.of(ctx).pop(s),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            );

            if (chosen != null) {
              ref.read(selectedStatusProvider.notifier).state = chosen;
            }
          },
        ),
      ],
    );
  }
}

