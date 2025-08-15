class QuizResult {
  final String playerName;
  final int score;
  final int totalQuestions;
  final DateTime date;
  final String category;

  QuizResult({
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.category,
  });

  double get percentage => (score / totalQuestions) * 100;

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      playerName: json['playerName'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }
}