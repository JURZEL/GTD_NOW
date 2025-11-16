import 'package:hive_flutter/hive_flutter.dart';

part 'review_log.g.dart';

@HiveType(typeId: 3)
class ReviewLog extends HiveObject {
  ReviewLog({
    required this.id,
    required this.date,
    required this.notes,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String notes;
}
