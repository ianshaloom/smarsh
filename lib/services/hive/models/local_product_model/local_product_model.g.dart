// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalProductAdapter extends TypeAdapter<LocalProduct> {
  @override
  final int typeId = 2;

  @override
  LocalProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalProduct(
      documentId: fields[0] as String,
      productName: fields[1] as String,
      retail: fields[2] as double,
      wholesale: fields[3] as double,
      lastCount: fields[4] as int,
      todaysCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalProduct obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.documentId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.retail)
      ..writeByte(3)
      ..write(obj.wholesale)
      ..writeByte(4)
      ..write(obj.lastCount)
      ..writeByte(5)
      ..write(obj.todaysCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
