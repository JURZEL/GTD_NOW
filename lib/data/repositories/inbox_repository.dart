import 'package:hive_flutter/hive_flutter.dart';

import '../local/hive_boxes.dart';
import '../models/inbox_item.dart';

class InboxRepository {
  InboxRepository() : _box = Hive.box<InboxItem>(HiveBoxes.inbox);

  final Box<InboxItem> _box;

  List<InboxItem> items() => _box.values.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Stream<List<InboxItem>> watchAll() async* {
    yield items();
    await for (final _ in _box.watch()) {
      yield items();
    }
  }

  Future<void> addItem(InboxItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  Future<void> markProcessed(String id, {bool processed = true}) async {
    final item = _box.get(id);
    if (item != null) {
      item.processed = processed;
      await item.save();
    }
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
