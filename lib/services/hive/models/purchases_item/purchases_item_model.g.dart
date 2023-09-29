// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchasesModelAdapter extends TypeAdapter<PurchasesModel> {
  @override
  final int typeId = 6;

  @override
  PurchasesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchasesModel(
      documentId: fields[0] as String,
      productName: fields[1] as String,
      totalQuantity: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchasesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.documentId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.totalQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchasesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
