import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:hive_flutter/hive_flutter.dart';

import 'data/local/hive_boxes.dart';

import 'app.dart';
import 'core/providers.dart';
import 'data/local/hive_initializer.dart';
import 'data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and open boxes first so we can read a user override for app locale.
  final hive = HiveInitializer();
  await hive.init();

  // Read stored user override for app locale (if any).
  String? storedLocale;
  try {
    if (Hive.isBoxOpen(HiveBoxes.settings)) {
      final box = Hive.box(HiveBoxes.settings);
      storedLocale = box.get('app_locale') as String?;
    }
  } catch (_) {
    storedLocale = null;
  }

  // Build a prioritized candidate list: user override -> exact system locale -> fallbacks
  final systemLocale = ui.PlatformDispatcher.instance.locale;
  final systemTag = systemLocale.toLanguageTag().replaceAll('-', '_');

  final fallbacks = <String>['en_GB', 'en_US', 'de_DE'];

  final candidates = <String>[];
  if (storedLocale != null) candidates.add(storedLocale);
  if (systemTag.isNotEmpty) candidates.add(systemTag);
  for (final f in fallbacks) {
    if (!candidates.contains(f)) candidates.add(f);
  }

  var initialized = false;
  for (final cand in candidates) {
    try {
      await initializeDateFormatting(cand);
      Intl.defaultLocale = cand;
      initialized = true;
      break;
    } catch (_) {
      // try next candidate
    }
  }
  if (!initialized) {
    await initializeDateFormatting();
  }

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const GtdApp(),
    ),
  );
}
