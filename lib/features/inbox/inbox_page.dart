import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/providers.dart';
import 'package:gtd_student/l10n/app_localizations.dart';
import '../../data/models/inbox_item.dart';
import '../../data/models/task_context.dart';
import '../../data/models/task_status.dart';
import 'process_inbox_item_sheet.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inbox = ref.watch(inboxItemsProvider);
    return inbox.when(
      data: (items) => items.isEmpty
          ? const _EmptyInbox()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                const _InboxHeaderCard(),
                const SizedBox(height: 12),
                for (final item in items) _InboxItemCard(item: item),
              ],
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(AppLocalizations.of(context)!.errorWith(error.toString()))),
    );
  }
}

class _InboxHeaderCard extends StatelessWidget {
  const _InboxHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.inboxHeroTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.inboxHeroDescription),
          ],
        ),
      ),
    );
  }
}

class _InboxItemCard extends ConsumerWidget {
  const _InboxItemCard({required this.item});

  final InboxItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.content, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.capturedAtLabel(item.createdAt.toFriendlyDateTime())),
                Switch.adaptive(
                  value: item.processed,
                  onChanged: (value) => ref
                      .read(inboxServiceProvider)
                      .toggleProcessed(item.id, value),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.playlist_add),
                    label: Text(AppLocalizations.of(context)!.taskLabel),
                    onPressed: () => _openProcessSheet(context),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (val) async {
                    if (val == 'someday') {
                      await _convertSomeday(ref);
                    } else if (val == 'delete') {
                      ref.read(inboxServiceProvider).delete(item.id);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(value: 'someday', child: Text(AppLocalizations.of(context)!.somedayLabel)),
                    PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context)!.clearAll)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openProcessSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.25,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return ProcessInboxItemSheet(item: item);
          },
        );
      },
    );
  }

  Future<void> _convertSomeday(WidgetRef ref) async {
    await ref.read(inboxServiceProvider).convertToTask(
          item: item,
          title: item.content,
          context: TaskContext.uni,
          status: TaskStatus.somedayMaybe,
        );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.emptyInbox),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.useFabToCapture),
          ],
        ),
      ),
    );
  }
}
