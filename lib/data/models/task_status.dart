import 'package:hive_flutter/hive_flutter.dart';

part 'task_status.g.dart';

@HiveType(typeId: 11)
enum TaskStatus {
  @HiveField(0)
  nextAction(label: 'Nächste Aktion'),
  @HiveField(1)
  waitingFor(label: 'Warten auf'),
  @HiveField(2)
  somedayMaybe(label: 'Vielleicht/Später'),
  @HiveField(3)
  done(label: 'Erledigt');

  const TaskStatus({required this.label});

  final String label;

  bool get isCompleted => this == TaskStatus.done;
}
