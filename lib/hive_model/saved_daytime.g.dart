// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_daytime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedDaytimeAdapter extends TypeAdapter<SavedDaytime> {
  @override
  final int typeId = 2;

  @override
  SavedDaytime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedDaytime(
      day: fields[0] as int,
      startTime: fields[1] as String,
      endTime: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedDaytime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedDaytimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
