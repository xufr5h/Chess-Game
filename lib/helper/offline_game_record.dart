import 'package:hive/hive.dart';

part 'offline_game_record.g.dart';

@HiveType(typeId: 0)
class OfflineGameRecord {
  @HiveField(0)
  final String player1;
  @HiveField(1)
  final String player2;
  @HiveField(2)
  final String result; 
  @HiveField(3)
  final DateTime playedAt;

  OfflineGameRecord({
    required this.player1,
    required this.player2,
    required this.result,
    required this.playedAt,
  });
}