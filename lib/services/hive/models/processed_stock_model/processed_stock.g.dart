// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcessedDataAdapter extends TypeAdapter<ProcessedData> {
  @override
  final int typeId = 3;

  @override
  ProcessedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProcessedData(
      documentId: fields[0] as String,
      productName: fields[1] as String,
      stockCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProcessedData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.documentId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.stockCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
