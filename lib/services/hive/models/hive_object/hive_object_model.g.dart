// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_object_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveObjectModelAdapter extends TypeAdapter<HiveObjectModel> {
  @override
  final int typeId = 3;

  @override
  HiveObjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveObjectModel(
      description: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveObjectModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveObjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
