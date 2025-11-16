import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../local/hive_boxes.dart';

class NotificationService {
  NotificationService() : _fln = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _fln;
  bool _initialized = false;
  bool _hasPermissions = false;
  bool _useFallback = false;
  // Localizable strings used by this service. They can be provided from the app
  // once a BuildContext / AppLocalizations is available. If not provided,
  // defaults based on Intl.getCurrentLocale() are used.
  late String _channelName;
  late String _channelDescription;
  late String _notificationTitleTemplate; // expects a template with {title}
  late String _notificationBody;
  late String _linuxDefaultActionName;

  /// Set localized strings from a widget context (AppLocalizations). If the
  /// service is already initialized this will attempt to recreate Android
  /// channels with the new values.
  Future<void> setLocalizedStrings({
    required String channelName,
    required String channelDescription,
    required String notificationTitleTemplate,
    required String notificationBody,
    required String linuxDefaultActionName,
  }) async {
    _channelName = channelName;
    _channelDescription = channelDescription;
    _notificationTitleTemplate = notificationTitleTemplate;
    _notificationBody = notificationBody;
    _linuxDefaultActionName = linuxDefaultActionName;

    if (_initialized) {
      await _ensureAndroidChannels();
    }
  }

  void _ensureDefaults() {
    final locale = Intl.getCurrentLocale();
    final isGerman = locale.toLowerCase().startsWith('de');
    _channelName = isGerman ? 'Fälligkeiten' : 'Due dates';
    _channelDescription = isGerman
        ? 'Benachrichtigungen für anstehende Aufgaben'
        : 'Notifications for upcoming tasks';
    _notificationTitleTemplate = isGerman ? 'Fällig: {title}' : 'Due: {title}';
    _notificationBody = isGerman ? 'Bleib dran – du hast es gleich geschafft!' : "Keep going — you're almost done!";
    _linuxDefaultActionName = isGerman ? 'Öffnen' : 'Open';
  }

  Future<void> init() async {
    // Decide if we should use fallback storage (Windows/Fuchsia) or native notifications
    _useFallback = _isFallbackPlatform;

    _ensureDefaults();

    if (_useFallback) {
      // ensure fallback box exists
      if (!Hive.isBoxOpen(HiveBoxes.fallbackNotifications)) {
        await Hive.openBox(HiveBoxes.fallbackNotifications);
      }
      _initialized = true;
      _hasPermissions = true;
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final linux = LinuxInitializationSettings(defaultActionName: _linuxDefaultActionName);
    const darwin = DarwinInitializationSettings();
    final settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
      linux: linux,
    );

    try {
      await _fln.initialize(settings);
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
      await _requestPermissions();
      await _ensureAndroidChannels();
      _initialized = true;
    } catch (error) {
      debugPrint('Notification init failed: $error');
      _initialized = false;
    }
  }

  Future<void> scheduleDueDateNotification({
    required String id,
    required String title,
    required DateTime dueDate,
  }) async {
    if (!_initialized || !_hasPermissions) return;

    // If fallback platform (Windows/Fuchsia) persist an entry instead of scheduling OS notifications
    if (_useFallback) {
      final box = Hive.box(HiveBoxes.fallbackNotifications);
      await box.put(id, {
        'id': id,
        'title': title,
        'dueDate': dueDate.toIso8601String(),
      });
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'due_date_channel',
  _channelName,
  channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
      linux: const LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.critical,
      ),
    );
    final scheduled = tz.TZDateTime.from(dueDate, tz.local);
    await _fln.zonedSchedule(
      id.hashCode,
  _notificationTitleTemplate.replaceAll('{title}', title),
  _notificationBody,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(String id) async {
    if (!_initialized) return;
    if (_useFallback) {
      final box = Hive.box(HiveBoxes.fallbackNotifications);
      await box.delete(id);
      return;
    }
    await _fln.cancel(id.hashCode);
  }

  Future<void> _requestPermissions() async {
    bool granted = true;

    final iosPlugin =
        _fln.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final macPlugin =
        _fln.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      final result = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = granted && (result ?? false);
    }

    if (macPlugin != null) {
      final result = await macPlugin.requestPermissions(
        alert: true,
        sound: true,
      );
      granted = granted && (result ?? false);
    }

    _hasPermissions = granted;
  }

  /// Public API: whether notifications are enabled/allowed
  bool get hasPermissions => _hasPermissions;

  /// Try to (re-)request permissions from the user. Returns true when granted.
  Future<bool> requestPermissions() async {
    await _requestPermissions();
    return _hasPermissions;
  }

  /// Open system settings (best-effort). On iOS this opens the app settings; on other
  /// platforms behavior may vary.
  Future<void> openAppSettings() async {
    final uri = Uri.parse('app-settings:');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Return scheduled fallback notifications (used on Windows/Fuchsia)
  List<Map<String, dynamic>> getFallbackScheduled() {
    if (!Hive.isBoxOpen(HiveBoxes.fallbackNotifications)) return [];
    final box = Hive.box(HiveBoxes.fallbackNotifications);
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> clearFallbackScheduled() async {
    if (!Hive.isBoxOpen(HiveBoxes.fallbackNotifications)) return;
    final box = Hive.box(HiveBoxes.fallbackNotifications);
    await box.clear();
  }

  Future<void> _ensureAndroidChannels() async {
    final androidImpl =
        _fln.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return;
    final channel = AndroidNotificationChannel(
      'due_date_channel',
  _channelName,
  description: _channelDescription,
      importance: Importance.max,
    );

    try {
      await androidImpl.createNotificationChannel(channel);
    } catch (e) {
      debugPrint('Failed creating Android channel: $e');
    }
  }

  bool get _isFallbackPlatform {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return true;
      default:
        return false;
    }
  }
}
 
