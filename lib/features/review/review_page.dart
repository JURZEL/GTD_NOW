import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/providers.dart';
import '../../data/models/task_status.dart';
import '../../data/models/task.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final inbox = ref.watch(inboxItemsProvider);
    final reviews = ref.watch(reviewLogsProvider);
    final loc = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Card.filled(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.weeklyReviewTitle,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(loc.weeklyReviewDescription),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => _startReview(context, ref),
                  child: Text(loc.startReview),
                ),
              ],
            ),
          ),
        ),
  const SizedBox(height: 12),
        tasks.when(
          data: (items) => _StatsGrid(tasks: items),
          loading: () => const LinearProgressIndicator(),
            error: (error, stack) => Text(AppLocalizations.of(context)!.errorWith(error.toString())),
        ),
  const SizedBox(height: 12),
        inbox.when(
          data: (items) => Card(
            child: ListTile(
              title: Text(loc.inboxHeader(items.length)),
              subtitle: Text(loc.inboxSubtitle),
              trailing: TextButton(
                onPressed: items.isEmpty
                    ? null
                    : () => ref.read(reviewServiceProvider).clearInbox(),
                child: Text(loc.emptyInbox),
              ),
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text(AppLocalizations.of(context)!.errorWith(error.toString())),
        ),
        const SizedBox(height: 16),
        tasks.when(
          data: (items) {
            final someday = items.where((task) => task.status == TaskStatus.somedayMaybe).toList();
            return Card(
              child: ExpansionTile(
                title: Text(loc.maybeLaterHeader(someday.length)),
                children: someday
                    .map((task) => ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.context.label),
                          trailing: Text(task.status.label),
                        ))
                    .toList(),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text(AppLocalizations.of(context)!.errorWith(error.toString())),
        ),
  const SizedBox(height: 12),
        _BackupSection(),
  const SizedBox(height: 12),
        reviews.when(
          data: (logs) => Card(
            child: ExpansionTile(
              title: Text(loc.reviewLog),
              children: logs
                  .map((log) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(log.date.toLocalDate()),
                        subtitle: Text(log.notes),
                      ))
                  .toList(),
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text(AppLocalizations.of(context)!.errorWith(error.toString())),
        ),
      ],
    );
  }

  Future<void> _startReview(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final loc = AppLocalizations.of(context)!;
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.reviewNotesTitle),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(hintText: loc.reviewNotesHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(loc.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(controller.text), child: Text(loc.save)),
        ],
      ),
    );
    if (result == null || result.trim().isEmpty) return;
    await ref.read(reviewServiceProvider).logReview(result.trim());
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final counts = <String, int>{
      loc.statNextActions: tasks.where((t) => t.status == TaskStatus.nextAction).length,
      loc.statWaitingFor: tasks.where((t) => t.status == TaskStatus.waitingFor).length,
      loc.statMaybe: tasks.where((t) => t.status == TaskStatus.somedayMaybe).length,
      loc.statDone: tasks.where((t) => t.status == TaskStatus.done).length,
    };

      final width = MediaQuery.of(context).size.width;
      final crossAxis = width > 600 ? 2 : 1;

    final childAspect = width > 600 ? 3.0 : 2.2;

    return GridView.count(
      crossAxisCount: crossAxis,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: childAspect,
      children: counts.entries
          .map(
            (entry) => Card(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.value.toString(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(entry.key),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BackupSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends ConsumerState<_BackupSection> {
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.backupLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isExporting ? null : _export,
                    icon: const Icon(Icons.upload_file),
                    label: Text(_isExporting ? loc.exportRunning : loc.exportLabel),
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'import' && !_isImporting) _import();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'import', child: Text(_isImporting ? loc.importRunning : loc.importLabel)),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export() async {
    setState(() => _isExporting = true);
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final file = await ref.read(backupServiceProvider).exportData();
    setState(() => _isExporting = false);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(loc.exportSavedMessage(file.path))));
  }

  Future<void> _import() async {
    setState(() => _isImporting = true);
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final service = ref.read(backupServiceProvider);
    await service.importLatestBackup();
    setState(() => _isImporting = false);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(loc.importCompleteMessage)));
  }

  
}
