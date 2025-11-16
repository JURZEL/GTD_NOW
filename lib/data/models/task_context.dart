import 'package:hive_flutter/hive_flutter.dart';

part 'task_context.g.dart';

@HiveType(typeId: 10)
enum TaskContext {
  @HiveField(0)
  uni(label: '@Uni', icon: 'school'),
  @HiveField(1)
  bibliothek(label: '@Bibliothek', icon: 'local_library'),
  @HiveField(2)
  laptop(label: '@Laptop', icon: 'laptop'),
  @HiveField(3)
  unterwegs(label: '@Unterwegs', icon: 'commute'),
  @HiveField(4)
  telefon(label: '@Telefon', icon: 'phone');

  const TaskContext({required this.label, required this.icon});

  final String label;
  final String icon;
}
