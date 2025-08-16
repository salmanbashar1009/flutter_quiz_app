import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../models/quiz_result.dart';
import '../services/leaderboard_service.dart';

class LeaderboardProvider with ChangeNotifier {
  final LeaderboardService _leaderboardService = LeaderboardService();
  List<LeaderboardEntry> _leaderboardEntries = [];
  bool _isLoading = true;

  List<LeaderboardEntry> get leaderboardEntries => _leaderboardEntries;
  bool get isLoading => _isLoading;

  LeaderboardProvider() {
    _init();
  }

  Future<void> _init() async {
    await _leaderboardService.init();
    await loadLeaderboard();
  }

  Future<void> loadLeaderboard({String? category}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _leaderboardEntries = _leaderboardService.getLeaderboard(category: category);
    } catch (e) {
      // Handle error
      _leaderboardEntries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveScore(QuizResult result) async {
    final entry = LeaderboardEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      playerName: result.playerName,
      score: result.score,
      totalQuestions: result.totalQuestions,
      date: result.date,
      category: result.category,
    );

    await _leaderboardService.saveScore(entry);
    await loadLeaderboard(category: result.category);
  }

  Future<void> clearLeaderboard() async {
    await _leaderboardService.clearLeaderboard();
    await loadLeaderboard();
  }
}