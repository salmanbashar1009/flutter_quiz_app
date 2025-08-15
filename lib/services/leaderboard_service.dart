import 'package:hive/hive.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardService {
  static const String _boxName = 'leaderboard';
  late Box<LeaderboardEntry> _box;

  Future<void> init() async {
    _box = await Hive.openBox<LeaderboardEntry>(_boxName);
  }

  Future<void> saveScore(LeaderboardEntry entry) async {
    await _box.put(entry.id, entry);
  }

  List<LeaderboardEntry> getLeaderboard({String? category}) {
    List<LeaderboardEntry> entries = _box.values.toList();

    // Sort by score (highest first)
    entries.sort((a, b) => b.score.compareTo(a.score));

    // Filter by category if provided
    if (category != null) {
      entries = entries.where((e) => e.category == category).toList();
    }

    return entries;
  }

  Future<void> clearLeaderboard() async {
    await _box.clear();
  }
}