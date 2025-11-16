// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyLevelAdapter extends TypeAdapter<EnergyLevel> {
  @override
  final int typeId = 12;

  @override
  EnergyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EnergyLevel.low;
      case 1:
        return EnergyLevel.medium;
      case 2:
        return EnergyLevel.high;
      default:
        return EnergyLevel.low;
    }
  }

  @override
  void write(BinaryWriter writer, EnergyLevel obj) {
    switch (obj) {
      case EnergyLevel.low:
        writer.writeByte(0);
        break;
      case EnergyLevel.medium:
        writer.writeByte(1);
        break;
      case EnergyLevel.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
