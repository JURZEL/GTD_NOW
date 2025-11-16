import 'package:hive_flutter/hive_flutter.dart';

part 'energy_level.g.dart';

@HiveType(typeId: 12)
enum EnergyLevel {
  @HiveField(0)
  low(label: 'Niedrig'),
  @HiveField(1)
  medium(label: 'Mittel'),
  @HiveField(2)
  high(label: 'Hoch');

  const EnergyLevel({required this.label});

  final String label;
}
