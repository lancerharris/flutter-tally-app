// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tally_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TallyTaskAdapter extends TypeAdapter<TallyTask> {
  @override
  final int typeId = 0;

  @override
  TallyTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TallyTask(
      name: fields[0] as String,
      dateCreated: fields[1] as DateTime,
      positionInList: fields[2] as int,
      streak: fields[3] as int,
      count: fields[4] as int,
      isExpanded: fields[5] as bool,
      isFrozen: fields[6] as bool,
      goalCount: fields[8] as int?,
      goalIncrement: fields[9] as String?,
    )
      ..collectionMemberships = (fields[10] as List).cast<String>()
      ..inCollection = fields[11] as bool;
  }

  @override
  void write(BinaryWriter writer, TallyTask obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dateCreated)
      ..writeByte(2)
      ..write(obj.positionInList)
      ..writeByte(3)
      ..write(obj.streak)
      ..writeByte(4)
      ..write(obj.count)
      ..writeByte(5)
      ..write(obj.isExpanded)
      ..writeByte(6)
      ..write(obj.isFrozen)
      ..writeByte(7)
      ..write(obj.isCollection)
      ..writeByte(8)
      ..write(obj.goalCount)
      ..writeByte(9)
      ..write(obj.goalIncrement)
      ..writeByte(10)
      ..write(obj.collectionMemberships)
      ..writeByte(11)
      ..write(obj.inCollection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TallyTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
