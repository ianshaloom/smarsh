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
      buyingPrice: fields[2] as double,
      sellingPrice: fields[3] as double,
      stockCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalProduct obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.documentId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.buyingPrice)
      ..writeByte(3)
      ..write(obj.sellingPrice)
      ..writeByte(4)
      ..write(obj.stockCount);
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
