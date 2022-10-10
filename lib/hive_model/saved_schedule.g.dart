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
      session: fields[7] == null ? '2022/2023' : fields[7] as String,
      semester: fields[8] == null ? 1 : fields[8] as int,
      title: fields[0] as String?,
      subjects: (fields[1] as List?)?.cast<SavedSubject>(),
      lastModified: fields[2] as String,
      dateCreated: fields[3] as String,
      fontSize: fields[4] as double,
      heightFactor: fields[5] as double,
      subjectTitleSetting: fields[6] == null
          ? SubjectTitleSetting.title
          : fields[6] as SubjectTitleSetting,
    );
  }

  @override
  void write(BinaryWriter writer, SavedSchedule obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subjects)
      ..writeByte(2)
      ..write(obj.lastModified)
      ..writeByte(3)
      ..write(obj.dateCreated)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.heightFactor)
      ..writeByte(6)
      ..write(obj.subjectTitleSetting)
      ..writeByte(7)
      ..write(obj.session)
      ..writeByte(8)
      ..write(obj.semester);
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
