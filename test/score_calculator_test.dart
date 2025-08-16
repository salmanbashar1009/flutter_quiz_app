import 'package:flutter_quiz_app/utils/score_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScoreCalculator', () {
    test('calculateScore returns correct score based on correct answers only', () {
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

      // Should be exactly the number of correct answers
      expect(score, 7);
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

    test('calculateScore returns 0 when totalQuestions is 0', () {
      const totalQuestions = 0;
      const correctAnswers = 5;
      const timeSpentInSeconds = 50;
      const totalTimeLimitInSeconds = 100;

      final score = ScoreCalculator.calculateScore(
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        timeSpentInSeconds: timeSpentInSeconds,
        totalTimeLimitInSeconds: totalTimeLimitInSeconds,
      );

      // Even if there are correct answers, no score should be given when totalQuestions is 0
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

    test('calculatePercentage returns 0 when maxPossibleScore is 0', () {
      const score = 5;
      const maxPossibleScore = 0;

      final percentage = ScoreCalculator.calculatePercentage(
        score: score,
        maxPossibleScore: maxPossibleScore,
      );

      expect(percentage, 0);
    });
  });
}
