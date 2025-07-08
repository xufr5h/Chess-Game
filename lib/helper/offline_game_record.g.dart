// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_game_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineGameRecordAdapter extends TypeAdapter<OfflineGameRecord> {
  @override
  final int typeId = 0;

  @override
  OfflineGameRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineGameRecord(
      player1: fields[0] as String,
      player2: fields[1] as String,
      result: fields[2] as String,
      playedAt: fields[3] as DateTime,
      gameId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineGameRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.player1)
      ..writeByte(1)
      ..write(obj.player2)
      ..writeByte(2)
      ..write(obj.result)
      ..writeByte(3)
      ..write(obj.playedAt)
      ..writeByte(4)
      ..write(obj.gameId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineGameRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
