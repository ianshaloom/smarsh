// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilterModelAdapter extends TypeAdapter<FilterModel> {
  @override
  final int typeId = 0;

  @override
  FilterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterModel(
      isAll: fields[3] as bool,
      isExcess: fields[1] as bool,
      isIntact: fields[2] as bool,
      isMissing: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FilterModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isMissing)
      ..writeByte(1)
      ..write(obj.isExcess)
      ..writeByte(2)
      ..write(obj.isIntact)
      ..writeByte(3)
      ..write(obj.isAll);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
