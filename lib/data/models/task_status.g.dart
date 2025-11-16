// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 11;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.nextAction;
      case 1:
        return TaskStatus.waitingFor;
      case 2:
        return TaskStatus.somedayMaybe;
      case 3:
        return TaskStatus.done;
      default:
        return TaskStatus.nextAction;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.nextAction:
        writer.writeByte(0);
        break;
      case TaskStatus.waitingFor:
        writer.writeByte(1);
        break;
      case TaskStatus.somedayMaybe:
        writer.writeByte(2);
        break;
      case TaskStatus.done:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
