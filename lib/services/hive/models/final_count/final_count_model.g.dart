// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_count_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinalCountModelAdapter extends TypeAdapter<FinalCountModel> {
  @override
  final int typeId = 2;

  @override
  FinalCountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinalCountModel(
      productName: fields[1] as String,
      count: fields[2] as int,
      productId: fields[0] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FinalCountModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinalCountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
