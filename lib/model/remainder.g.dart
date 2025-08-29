// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remainder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemainderAdapter extends TypeAdapter<Remainder> {
  @override
  final int typeId = 0;

  @override
  Remainder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Remainder(
      task: fields[0] as String,
      dateTime: fields[1] as DateTime,
      priority: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Remainder obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemainderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
