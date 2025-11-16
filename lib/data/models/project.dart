import 'package:hive_flutter/hive_flutter.dart';

part 'project.g.dart';

@HiveType(typeId: 1)
class Project extends HiveObject {
  Project({
    required this.id,
    required this.name,
    this.description,
    this.deadline,
    List<String>? taskIds,
  }) : taskIds = taskIds ?? <String>[];

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? deadline;

  @HiveField(4)
  List<String> taskIds;
}
