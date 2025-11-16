import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import 'package:gtd_student/core/providers.dart';
import '../../data/models/task.dart';
import '../../data/models/task_context.dart';
import '../../data/models/task_status.dart';
import '../../data/models/energy_level.dart';

class EditTaskPage extends ConsumerStatefulWidget {
  const EditTaskPage({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends ConsumerState<EditTaskPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  TaskContext? _context;
  TaskStatus? _status;
  EnergyLevel? _energy;
  DateTime? _dueDate;
  String? _projectId;
  int? _duration;
  // notification toggle currently unused in UI; remove to avoid unused-field error
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description ?? '');
    _context = widget.task.context;
    _status = widget.task.status;
    _energy = widget.task.energyLevel;
    _dueDate = widget.task.dueDate;
    _projectId = widget.task.projectId;
    _duration = widget.task.durationMinutes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final projectsAsync = ref.watch(projectsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(loc.edit)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: loc.titleLabel)),
              const SizedBox(height: 12),
              TextField(controller: _descController, minLines: 2, maxLines: 6, decoration: InputDecoration(labelText: loc.descriptionOptional)),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskContext>(
                initialValue: _context,
                items: TaskContext.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
                onChanged: (v) => setState(() => _context = v),
                decoration: InputDecoration(labelText: loc.contextLabel),
              ),
              const SizedBox(height: 12),
              projectsAsync.when(
                data: (list) => DropdownButtonFormField<String?>(
                  initialValue: _projectId,
                  items: [DropdownMenuItem(value: null, child: Text(loc.noProject)), ...list.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))],
                  onChanged: (v) => setState(() => _projectId = v),
                  decoration: InputDecoration(labelText: loc.projectLabel),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(loc.projectsLoadError),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: loc.dueByLabel),
                    child: TextButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_dueDate?.toLocal().toString().split(' ').first ?? loc.chooseDate),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    initialValue: _duration,
                    items: [null, 10, 30, 45, 60, 90].map((v) => DropdownMenuItem<int?>(value: v, child: Text(v == null ? '-' : loc.minutesLabel(v)))).toList(),
                    onChanged: (v) => setState(() => _duration = v),
                    decoration: InputDecoration(labelText: loc.timeNeededLabel),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text(loc.cancel))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? loc.saving : loc.save))),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 3650)), initialDate: _dueDate ?? DateTime.now());
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await ref.read(taskServiceProvider).upsertTask(widget.task.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          context: _context,
          projectId: _projectId,
          dueDate: _dueDate,
          durationMinutes: _duration,
          status: _status,
          energyLevel: _energy,
        ));
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
