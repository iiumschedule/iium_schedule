// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gh_responses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GhResponsesAdapter extends TypeAdapter<GhResponses> {
  @override
  final int typeId = 3;

  @override
  GhResponses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GhResponses(
      etag: fields[0] as String,
      body: (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, GhResponses obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.etag)
      ..writeByte(1)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GhResponsesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
