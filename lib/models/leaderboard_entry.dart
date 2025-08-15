import 'package:hive/hive.dart';

part 'leaderboard_entry.g.dart';

@HiveType(typeId: 0)
class LeaderboardEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String playerName;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final int totalQuestions;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String category;

  LeaderboardEntry({
    required this.id,
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.category,
  });

  double get percentage => (score / totalQuestions) * 100;
}