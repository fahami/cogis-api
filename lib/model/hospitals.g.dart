// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospitals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HospitalsAdapter extends TypeAdapter<Hospitals> {
  @override
  final int typeId = 0;

  @override
  Hospitals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hospitals(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hospitals obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
