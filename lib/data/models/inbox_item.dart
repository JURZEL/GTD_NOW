import 'package:hive_flutter/hive_flutter.dart';

part 'inbox_item.g.dart';

@HiveType(typeId: 2)
class InboxItem extends HiveObject {
  InboxItem({
    required this.id,
    required this.content,
    required this.createdAt,
    this.processed = false,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  bool processed;
}
