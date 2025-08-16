import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/questions.dart';
import '../services/quiz_service.dart';
import '../utils/score_calculator.dart';

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _selectedAnswerIndex = -1;
  int _score = 0;
  String _selectedCategory = AppConstants.defaultCategory;
  bool _isLoading = true;
  int _timeSpentInSeconds = 0;
  int _remainingTimeForCurrentQuestion = AppConstants.questionTimeLimit;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get selectedAnswerIndex => _selectedAnswerIndex;
  int get score => _score;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  int get timeSpentInSeconds => _timeSpentInSeconds;
  int get remainingTimeForCurrentQuestion => _remainingTimeForCurrentQuestion;

  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get hasSelectedAnswer => _selectedAnswerIndex != -1;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_selectedCategory == AppConstants.defaultCategory) {
        _questions = await _quizService.loadQuestions();
      } else {
        _questions = await _quizService.getQuestionsByCategory(_selectedCategory);
      }

      // Shuffle questions for randomness
      _questions.shuffle();

      // Limit to default question count
      if (_questions.length > AppConstants.defaultQuestionCount) {
        _questions = _questions.sublist(0, AppConstants.defaultQuestionCount);
      }

      _resetQuiz();
    } catch (e) {
      // Handle error
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = -1;
    _score = 0;
    _timeSpentInSeconds = 0;
    _remainingTimeForCurrentQuestion = AppConstants.questionTimeLimit;
    notifyListeners();
  }


  void selectAnswer(int index) {
    if (_selectedAnswerIndex != -1) return; // Answer already selected

    _selectedAnswerIndex = index;

    // Check if answer is correct and add 1 point if correct
    if (index == currentQuestion.correctAnswerIndex) {
      _score += 1;
    }

    notifyListeners();
  }


  // void selectAnswer(int index) {
  //   if (_selectedAnswerIndex != -1) return; // Answer already selected
  //
  //   _selectedAnswerIndex = index;
  //
  //   // Check if answer is correct
  //   if (index == currentQuestion.correctAnswerIndex) {
  //     _score = ScoreCalculator.calculateScore(
  //       totalQuestions: _questions.length,
  //       correctAnswers: _score + 1,
  //       timeSpentInSeconds: _timeSpentInSeconds,
  //       totalTimeLimitInSeconds: _questions.length * AppConstants.questionTimeLimit,
  //     );
  //   }
  //
  //   notifyListeners();
  // }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = -1;
      _remainingTimeForCurrentQuestion = AppConstants.questionTimeLimit;
      notifyListeners();
    }
  }

  void addTimeSpent(int seconds) {
    _timeSpentInSeconds += seconds;
    _remainingTimeForCurrentQuestion -= seconds;
    notifyListeners();
  }

  void resetTimerForCurrentQuestion() {
    _remainingTimeForCurrentQuestion = AppConstants.questionTimeLimit;
    notifyListeners();
  }

  QuizService get quizService => _quizService;
}