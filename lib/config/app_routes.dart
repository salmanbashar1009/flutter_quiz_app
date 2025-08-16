import 'package:flutter/material.dart';

import '../screens/category_selection_screen.dart';
import '../screens/home_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/results_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String categorySelection = '/category-selection';
  static const String quiz = '/quiz';
  static const String results = '/results';
  static const String leaderboard = '/leaderboard';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      categorySelection: (context) => const CategorySelectionScreen(),
      quiz: (context) => const QuizScreen(),
      results: (context) => const ResultsScreen(),
      leaderboard: (context) => const LeaderboardScreen(),
    };
  }
}