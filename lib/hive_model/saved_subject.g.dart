// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedSubjectAdapter extends TypeAdapter<SavedSubject> {
  @override
  final int typeId = 1;

  @override
  SavedSubject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedSubject(
      uuid: fields[9] == null ? 'abc' : fields[9] as String,
      code: fields[0] as String,
      sect: fields[3] as int,
      title: fields[1] as String,
      chr: fields[4] as double,
      venue: fields[2] as String?,
      lect: (fields[5] as List).cast<String>(),
      dayTime: (fields[6] as List).cast<SavedDaytime?>(),
      subjectName: fields[7] as String?,
      hexColor: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedSubject obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.venue)
      ..writeByte(3)
      ..write(obj.sect)
      ..writeByte(4)
      ..write(obj.chr)
      ..writeByte(5)
      ..write(obj.lect)
      ..writeByte(6)
      ..write(obj.dayTime)
      ..writeByte(7)
      ..write(obj.subjectName)
      ..writeByte(8)
      ..write(obj.hexColor)
      ..writeByte(9)
      ..write(obj.uuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedSubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
