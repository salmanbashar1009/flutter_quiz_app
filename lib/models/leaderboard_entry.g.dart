// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaderboardEntryAdapter extends TypeAdapter<LeaderboardEntry> {
  @override
  final int typeId = 0;

  @override
  LeaderboardEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeaderboardEntry(
      id: fields[0] as String,
      playerName: fields[1] as String,
      score: fields[2] as int,
      totalQuestions: fields[3] as int,
      date: fields[4] as DateTime,
      category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LeaderboardEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playerName)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.totalQuestions)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
