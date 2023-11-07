// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_home.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShowOnboardAdapter extends TypeAdapter<ShowOnboard> {
  @override
  final int typeId = 4;

  @override
  ShowOnboard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShowOnboard(
      showOnboard: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ShowOnboard obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.showOnboard);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowOnboardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
