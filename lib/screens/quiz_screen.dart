import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_routes.dart';
import '../config/constants.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_option.dart';
import '../widgets/countdown_timer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Load questions when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.loadQuestions();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (quizProvider.remainingTimeForCurrentQuestion > 0) {
        quizProvider.addTimeSpent(1);
      } else {
        _timer?.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    if (!quizProvider.hasSelectedAnswer) {
      // Time's up, move to next question
      _nextQuestion();
    }
  }

  void _nextQuestion() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    if (quizProvider.isLastQuestion) {
      // Navigate to results screen
      Navigator.pushReplacementNamed(context, AppRoutes.results);
    } else {
      // Reset animation for next question
      _animationController.reset();
      _animationController.forward();

      // Move to next question
      quizProvider.nextQuestion();

      // Start timer for the new question
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        // Start timer when the question changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (quizProvider.remainingTimeForCurrentQuestion == AppConstants.questionTimeLimit) {
            _startTimer();
          }
        });

        if (quizProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (quizProvider.questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Quiz')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No questions available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        final currentQuestion = quizProvider.currentQuestion;
        final currentQuestionIndex = quizProvider.currentQuestionIndex;
        final totalQuestions = quizProvider.questions.length;

        return Scaffold(
          appBar: AppBar(
            title: Text('Quiz - ${quizProvider.selectedCategory}'),
            automaticallyImplyLeading: false,
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score: ${quizProvider.score}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      CountdownTimer(
                        key: ValueKey('timer_$currentQuestionIndex'),
                        seconds: quizProvider.remainingTimeForCurrentQuestion,
                        onTimeUp: _handleTimeUp,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: QuestionCard(
                      questionText: currentQuestion.questionText,
                      currentQuestion: currentQuestionIndex + 1,
                      totalQuestions: totalQuestions,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final option = currentQuestion.options[index];
                        final isSelected = quizProvider.selectedAnswerIndex == index;
                        final isCorrect = index == currentQuestion.correctAnswerIndex;
                        final showResult = quizProvider.hasSelectedAnswer;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AnswerOption(
                            text: option,
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            showResult: showResult,
                            onTap: () {
                              if (!quizProvider.hasSelectedAnswer) {
                                quizProvider.selectAnswer(index);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: quizProvider.hasSelectedAnswer ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      quizProvider.isLastQuestion ? 'Finish Quiz' : 'Next Question',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}