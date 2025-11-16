import 'package:hive_flutter/hive_flutter.dart';

import '../local/hive_boxes.dart';
import '../models/review_log.dart';

class ReviewRepository {
  ReviewRepository() : _box = Hive.box<ReviewLog>(HiveBoxes.review);

  final Box<ReviewLog> _box;

  List<ReviewLog> logs() => _box.values.toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  Stream<List<ReviewLog>> watchAll() async* {
    yield logs();
    await for (final _ in _box.watch()) {
      yield logs();
    }
  }

  Future<void> addLog(ReviewLog log) async {
    await _box.put(log.id, log);
  }
}
