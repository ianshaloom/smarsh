// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_count_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemCountModelAdapter extends TypeAdapter<ItemCountModel> {
  @override
  final int typeId = 1;

  @override
  ItemCountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemCountModel(
      count: (fields[2] as List?)?.cast<int>(),
      productName: fields[1] as String,
      productId: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemCountModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemCountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
