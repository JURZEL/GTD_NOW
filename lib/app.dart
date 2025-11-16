import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import 'package:gtd_student/core/providers.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_shell.dart';

class GtdApp extends ConsumerWidget {
  const GtdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seeding = ref.watch(dummyDataSeederProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final appLocaleTag = ref.watch(appLocaleProvider);
    Locale? appLocale;
    if (appLocaleTag != null) {
      final parts = appLocaleTag.split(RegExp('[_-]'));
      final languageCode = parts.isNotEmpty ? parts[0] : '';
      final countryCode = parts.length > 1 ? parts[1] : null;
      appLocale = Locale(languageCode, countryCode);
    }
    return MaterialApp(
      locale: appLocale,
      title: AppLocalizations.of(context)?.appTitle ?? 'GTD Student',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
  themeMode: themeMode,
      home: seeding.when(
        data: (_) => const HomeShell(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.initializationFailed(error.toString())),
                  const SizedBox(height: 8),
                  Text(stack.toString()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
