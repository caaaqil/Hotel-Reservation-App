// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomModelAdapter extends TypeAdapter<RoomModel> {
  @override
  final int typeId = 1;

  @override
  RoomModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      price: fields[3] as double,
      totalRooms: fields[4] as int,
      features: (fields[5] as List).cast<String>(),
      images: (fields[6] as List).cast<String>(),
      description: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoomModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.totalRooms)
      ..writeByte(5)
      ..write(obj.features)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
