import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import 'package:gtd_student/core/providers.dart';
// hive_boxes not needed directly here
// widgets import not necessary; material.dart already included by consumers

class NotificationsSettingsPage extends ConsumerWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final notificationService = ref.watch(notificationServiceProvider);
    final hasPermissions = notificationService.hasPermissions;
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);

    final fallback = notificationService.getFallbackScheduled();
    final appLocale = ref.watch(appLocaleProvider);
  final loc = AppLocalizations.of(context)!;

    final localeOptions = <String?, String>{
      null: loc.localeSystemLabel,
      'de_DE': loc.localeDeLabel,
      'en_GB': loc.localeEnGbLabel,
      'en_US': loc.localeEnUsLabel,
      'fr_FR': loc.localeFrLabel,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(AppLocalizations.of(context)!.notificationsEnable)),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (v) => ref.read(notificationsEnabledProvider.notifier).setEnabled(v),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.permissionsStatus(hasPermissions
                ? AppLocalizations.of(context)!.permissionGranted
                : AppLocalizations.of(context)!.permissionDenied)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final grantedMsg = AppLocalizations.of(context)!.permissionGranted;
                      final deniedMsg = AppLocalizations.of(context)!.permissionDenied;
                      final granted = await notificationService.requestPermissions();
                      messenger.showSnackBar(SnackBar(
                        content: Text(granted ? grantedMsg : deniedMsg),
                      ));
                    },
                    child: Text(AppLocalizations.of(context)!.requestPermissions),
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'open') notificationService.openAppSettings();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'open', child: Text(AppLocalizations.of(context)!.openSettings)),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(AppLocalizations.of(context)!.appLanguage, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<String?>(
              value: appLocale,
              items: localeOptions.entries
                  .map((e) => DropdownMenuItem<String?>(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (val) async {
                final messenger = ScaffoldMessenger.of(context);
                final message = AppLocalizations.of(context)!.appLanguageSet(localeOptions[val] ?? '');
                await ref.read(appLocaleProvider.notifier).setLocale(val);
                messenger.showSnackBar(SnackBar(content: Text(message)));
              },
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.appearanceLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Builder(builder: (context) {
              final mode = ref.watch(appThemeModeProvider);
              final String current = mode == ThemeMode.light ? 'light' : mode == ThemeMode.dark ? 'dark' : 'system';
                return DropdownButton<String>(
                value: current,
                items: [
                  DropdownMenuItem(value: 'system', child: Text(loc.themeSystem)),
                  DropdownMenuItem(value: 'light', child: Text(loc.themeLight)),
                  DropdownMenuItem(value: 'dark', child: Text(loc.themeDark)),
                ],
                onChanged: (val) async {
                  if (val == null) return;
                  final ThemeMode newMode = val == 'light' ? ThemeMode.light : val == 'dark' ? ThemeMode.dark : ThemeMode.system;
                  await ref.read(appThemeModeProvider.notifier).setMode(newMode);
                },
              );
            }),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.appearanceLabel, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => ref.read(appThemeModeProvider.notifier).setMode(ThemeMode.light),
                            child: Container(
                              height: 84,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(31)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.light_mode, size: 20),
                                  const SizedBox(height: 8),
                                  Text(loc.themeLight, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => ref.read(appThemeModeProvider.notifier).setMode(ThemeMode.dark),
                            child: Container(
                              height: 84,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(31)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.dark_mode, size: 20),
                                  const SizedBox(height: 8),
                                  Text(loc.themeDark, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.snooze, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Consumer(builder: (ctx, r, _) {
                      final presets = r.watch(snoozePresetsProvider);
                      return Wrap(
                        spacing: 8,
                        children: [
                          for (final p in presets)
                            Chip(
                              label: Text(p >= 60 ? AppLocalizations.of(context)!.hoursLabel(p ~/ 60) : AppLocalizations.of(context)!.minutesLabel(p)),
                              onDeleted: () async {
                                final newList = List<int>.from(presets)..remove(p);
                                await r.read(snoozePresetsProvider.notifier).setPresets(newList);
                              },
                            ),
                          ActionChip(
                            label: Text(AppLocalizations.of(context)!.addToInbox),
                            onPressed: () async {
                              final controller = TextEditingController();
                              final result = await showDialog<int?>(
                                context: context,
                                builder: (dCtx) => AlertDialog(
                                  title: Text(AppLocalizations.of(dCtx)!.snooze),
                                  content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: loc.minutesHint)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(dCtx).pop(null), child: Text(AppLocalizations.of(dCtx)!.cancel)),
                                    FilledButton(onPressed: () => Navigator.of(dCtx).pop(int.tryParse(controller.text)), child: Text(AppLocalizations.of(dCtx)!.save)),
                                  ],
                                ),
                              );
                              if (result != null && result > 0) {
                                final newList = List<int>.from(presets)..add(result);
                                await r.read(snoozePresetsProvider.notifier).setPresets(newList);
                              }
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.fallbackReminders, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (fallback.isEmpty)
              Text(AppLocalizations.of(context)!.noFallbacks)
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxH = constraints.maxHeight == double.infinity ? 200.0 : constraints.maxHeight * 0.35;
                  final double height = maxH.clamp(120.0, 300.0);
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: fallback.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = fallback[index];
                        final due = DateTime.tryParse(item['dueDate'] ?? '')?.toLocal();
                        return ListTile(
                          title: Text(item['title'] ?? ''),
                          subtitle: Text(due != null ? due.toString() : '—'),
                        );
                      },
                    ),
                  );
                },
              ),
            if (fallback.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final clearMsg = AppLocalizations.of(context)!.clearAll;
                    await notificationService.clearFallbackScheduled();
                    messenger.showSnackBar(SnackBar(content: Text(clearMsg)));
                    // trigger rebuild by reading notifier (no-op)
                    ref.invalidate(notificationsEnabledProvider);
                  },
                  child: Text(AppLocalizations.of(context)!.clearAll),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
