// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_context.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskContextAdapter extends TypeAdapter<TaskContext> {
  @override
  final int typeId = 10;

  @override
  TaskContext read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskContext.uni;
      case 1:
        return TaskContext.bibliothek;
      case 2:
        return TaskContext.laptop;
      case 3:
        return TaskContext.unterwegs;
      case 4:
        return TaskContext.telefon;
      default:
        return TaskContext.uni;
    }
  }

  @override
  void write(BinaryWriter writer, TaskContext obj) {
    switch (obj) {
      case TaskContext.uni:
        writer.writeByte(0);
        break;
      case TaskContext.bibliothek:
        writer.writeByte(1);
        break;
      case TaskContext.laptop:
        writer.writeByte(2);
        break;
      case TaskContext.unterwegs:
        writer.writeByte(3);
        break;
      case TaskContext.telefon:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskContextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
