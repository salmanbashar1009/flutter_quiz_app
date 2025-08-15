class ScoreCalculator {
  static int calculateScore({
    required int totalQuestions,
    required int correctAnswers,
    required int timeSpentInSeconds,
    required int totalTimeLimitInSeconds,
  }) {
    if (totalQuestions == 0) return 0;

    // Base score: 1 point per correct answer
    int baseScore = correctAnswers;

    // Time bonus: up to 0.5 points per question based on how quickly you answered
    double timeBonusPerQuestion = 0.5;
    double timeBonus = 0;

    if (totalTimeLimitInSeconds > 0) {
      double timeRatio = timeSpentInSeconds / totalTimeLimitInSeconds;
      // The faster you answer, the higher the bonus (inverted ratio)
      double bonusRatio = 1 - timeRatio;
      timeBonus = bonusRatio * timeBonusPerQuestion * correctAnswers;
    }

    return (baseScore + timeBonus).round();
  }

  static double calculatePercentage({
    required int score,
    required int maxPossibleScore,
  }) {
    if (maxPossibleScore == 0) return 0;
    return (score / maxPossibleScore) * 100;
  }
}