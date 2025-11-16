import 'package:hive_flutter/hive_flutter.dart';

import '../models/energy_level.dart';
import '../models/inbox_item.dart';
import '../models/project.dart';
import '../models/review_log.dart';
import '../models/task.dart';
import '../models/task_context.dart';
import '../models/task_status.dart';
import 'hive_boxes.dart';

class HiveInitializer {
  const HiveInitializer();

  Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await Future.wait([
      Hive.openBox<Task>(HiveBoxes.tasks),
      Hive.openBox<Project>(HiveBoxes.projects),
      Hive.openBox<InboxItem>(HiveBoxes.inbox),
      Hive.openBox<ReviewLog>(HiveBoxes.review),
      Hive.openBox(HiveBoxes.fallbackNotifications),
      Hive.openBox(HiveBoxes.settings),
    ]);
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProjectAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(InboxItemAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ReviewLogAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(TaskContextAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(TaskStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(EnergyLevelAdapter());
    }
  }
}
