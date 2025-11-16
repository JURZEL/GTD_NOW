import 'package:hive_flutter/hive_flutter.dart';

import 'energy_level.dart';
import 'task_context.dart';
import 'task_status.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    this.description,
    required this.context,
    this.projectId,
    this.dueDate,
    this.status = TaskStatus.nextAction,
    required this.createdAt,
    this.energyLevel = EnergyLevel.medium,
    this.durationMinutes,
    this.isTwoMinuteCandidate = false,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  TaskContext context;

  @HiveField(4)
  String? projectId;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  TaskStatus status;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  EnergyLevel energyLevel;

  @HiveField(9)
  int? durationMinutes;

  @HiveField(10)
  bool isTwoMinuteCandidate;

  Task copyWith({
    String? title,
    String? description,
    TaskContext? context,
    String? projectId,
    DateTime? dueDate,
    TaskStatus? status,
    EnergyLevel? energyLevel,
    int? durationMinutes,
    bool? isTwoMinuteCandidate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      context: context ?? this.context,
      projectId: projectId ?? this.projectId,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt,
      energyLevel: energyLevel ?? this.energyLevel,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isTwoMinuteCandidate: isTwoMinuteCandidate ?? this.isTwoMinuteCandidate,
    );
  }
}
