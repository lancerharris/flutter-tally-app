// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tally_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TallyCollectionAdapter extends TypeAdapter<TallyCollection> {
  @override
  final int typeId = 1;

  @override
  TallyCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TallyCollection(
      name: fields[0] as String,
      dateCreated: fields[1] as DateTime,
      positionInList: fields[2] as int,
      streak: fields[3] as int,
      count: fields[4] as int,
      isExpanded: fields[5] as bool,
      isFrozen: fields[6] as bool,
    )..tallyTaskNames = (fields[7] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, TallyCollection obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.tallyTaskNames)
      ..writeByte(8)
      ..write(obj.isCollection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TallyCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
