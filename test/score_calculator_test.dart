import 'package:flutter_quiz_app/utils/score_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScoreCalculator', () {
    test('calculateScore returns correct base score', () {
      const totalQuestions = 10;
      const correctAnswers = 7;
      const timeSpentInSeconds = 120;
      const totalTimeLimitInSeconds = 150;

      final score = ScoreCalculator.calculateScore(
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        timeSpentInSeconds: timeSpentInSeconds,
        totalTimeLimitInSeconds: totalTimeLimitInSeconds,
      );

      // Base score should be 7 (1 point per correct answer)
      // Plus some time bonus
      expect(score, greaterThanOrEqualTo(7));
      expect(score, lessThanOrEqualTo(10)); // Max possible with bonus
    });

    test('calculateScore returns 0 when no correct answers', () {
      const totalQuestions = 10;
      const correctAnswers = 0;
      const timeSpentInSeconds = 120;
      const totalTimeLimitInSeconds = 150;

      final score = ScoreCalculator.calculateScore(
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        timeSpentInSeconds: timeSpentInSeconds,
        totalTimeLimitInSeconds: totalTimeLimitInSeconds,
      );

      expect(score, 0);
    });

    test('calculatePercentage returns correct percentage', () {
      const score = 7;
      const maxPossibleScore = 10;

      final percentage = ScoreCalculator.calculatePercentage(
        score: score,
        maxPossibleScore: maxPossibleScore,
      );

      expect(percentage, 70.0);
    });
  });
}