import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/providers.dart';
import 'package:gtd_student/l10n/app_localizations.dart';
import '../../data/models/energy_level.dart';
import '../../data/models/inbox_item.dart';
import '../../data/models/task_context.dart';
import '../../data/models/task_status.dart';

class ProcessInboxItemSheet extends ConsumerStatefulWidget {
  const ProcessInboxItemSheet({super.key, required this.item});

  final InboxItem item;

  @override
  ConsumerState<ProcessInboxItemSheet> createState() => _ProcessInboxItemSheetState();
}

class _ProcessInboxItemSheetState extends ConsumerState<ProcessInboxItemSheet> {
  late final TextEditingController _titleController;
  final TextEditingController _descriptionController = TextEditingController();
  TaskContext _context = TaskContext.uni;
  TaskStatus _status = TaskStatus.nextAction;
  EnergyLevel _energy = EnergyLevel.medium;
  DateTime? _dueDate;
  String? _projectId;
  int? _duration;
  bool _twoMinuteRule = false;
  bool _notify = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.processTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.titleLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.descriptionOptional),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskContext>(
                initialValue: _context,
              items: TaskContext.values
                  .map((ctx) => DropdownMenuItem(
                        value: ctx,
                        child: Text(ctx.label),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _context = value ?? _context),
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.contextLabel),
            ),
            const SizedBox(height: 12),
              projects.when(
                data: (list) => DropdownButtonFormField<String?>(
                    initialValue: _projectId,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(AppLocalizations.of(context)!.noProject),
                    ),
                    ...list.map(
                      (project) => DropdownMenuItem<String?>(
                        value: project.id,
                        child: Text(project.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _projectId = value),
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.projectLabel),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text(AppLocalizations.of(context)!.projectsLoadError),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TaskStatus>(
                      initialValue: _status,
                    items: TaskStatus.values
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.label),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _status = value ?? TaskStatus.nextAction),
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.listLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<EnergyLevel>(
                      initialValue: _energy,
                    items: EnergyLevel.values
                        .map((energy) => DropdownMenuItem(
                              value: energy,
                              child: Text(energy.label),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _energy = value ?? EnergyLevel.medium),
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.energyLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.dueByLabel),
                    child: TextButton.icon(
                      onPressed: _pickDueDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                            _dueDate?.toLocalDate() ?? AppLocalizations.of(context)!.chooseDate,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                      initialValue: _duration,
                        items: [
                          DropdownMenuItem(value: 10, child: Text(AppLocalizations.of(context)!.minutesLabel(10))),
                          DropdownMenuItem(value: 30, child: Text(AppLocalizations.of(context)!.minutesLabel(30))),
                          DropdownMenuItem(value: 45, child: Text(AppLocalizations.of(context)!.minutesLabel(45))),
                          DropdownMenuItem(value: 60, child: Text(AppLocalizations.of(context)!.minutesLabel(60))),
                          DropdownMenuItem(value: 90, child: Text(AppLocalizations.of(context)!.minutesLabel(90))),
                        ],
                    onChanged: (value) => setState(() => _duration = value),
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.timeNeededLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _twoMinuteRule,
              onChanged: (value) => setState(() => _twoMinuteRule = value ?? false),
              title: Text(AppLocalizations.of(context)!.twoMinuteRuleTitle),
              subtitle: Text(AppLocalizations.of(context)!.twoMinuteRuleSubtitle),
            ),
            SwitchListTile.adaptive(
              value: _notify,
              onChanged: (value) => setState(() => _notify = value),
              title: Text(AppLocalizations.of(context)!.notifyOnDueTitle),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.archive_outlined),
                    label: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text(_saving ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.applyLabel),
                    onPressed: _saving ? null : _onSave,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _dueDate ?? DateTime.now(),
    );
    if (picked == null) return;
    setState(() => _dueDate = picked);
  }

  Future<void> _onSave() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await ref.read(inboxServiceProvider).convertToTask(
          item: widget.item,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          context: _context,
          projectId: _projectId,
          dueDate: _dueDate,
          status: _status,
          energyLevel: _energy,
          durationMinutes: _duration,
          markDone: _twoMinuteRule,
          notify: _notify,
          twoMinuteRule: _twoMinuteRule,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
