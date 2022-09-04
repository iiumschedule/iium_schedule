// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_title_setting_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectTitleSettingAdapter extends TypeAdapter<SubjectTitleSetting> {
  @override
  final int typeId = 4;

  @override
  SubjectTitleSetting read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubjectTitleSetting.title;
      case 1:
        return SubjectTitleSetting.courseCode;
      default:
        return SubjectTitleSetting.title;
    }
  }

  @override
  void write(BinaryWriter writer, SubjectTitleSetting obj) {
    switch (obj) {
      case SubjectTitleSetting.title:
        writer.writeByte(0);
        break;
      case SubjectTitleSetting.courseCode:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectTitleSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
