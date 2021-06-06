// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scans.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScansResultAdapter extends TypeAdapter<ScansResult> {
  @override
  final int typeId = 2;

  @override
  ScansResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScansResult(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScansResult obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.master)
      ..writeByte(1)
      ..write(obj.slave)
      ..writeByte(2)
      ..write(obj.scanDate)
      ..writeByte(3)
      ..write(obj.rssi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScansResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
