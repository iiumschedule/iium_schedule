// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedScheduleAdapter extends TypeAdapter<SavedSchedule> {
  @override
  final int typeId = 0;

  @override
  SavedSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedSchedule(
      title: fields[0] as String?,
      subjects: (fields[1] as List?)?.cast<SavedSubject>(),
      lastModified: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subjects)
      ..writeByte(2)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
