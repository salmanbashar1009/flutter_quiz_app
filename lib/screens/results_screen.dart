import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_routes.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';
import '../providers/leaderboard_provider.dart';
import '../utils/score_calculator.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final leaderboardProvider =
      Provider.of<LeaderboardProvider>(context, listen: false);

      final result = QuizResult(
        playerName: _nameController.text.trim(),
        score: quizProvider.score,
        totalQuestions: quizProvider.questions.length,
        date: DateTime.now(),
        category: quizProvider.selectedCategory,
      );

      await leaderboardProvider.saveScore(result);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score saved successfully!')),
      );

      // Navigate to leaderboard
      Navigator.pushReplacementNamed(context, AppRoutes.leaderboard);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving score: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final percentage = ScoreCalculator.calculatePercentage(
          score: quizProvider.score,
          maxPossibleScore: quizProvider.questions.length,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Quiz Results'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: Colors.amber,
                ),
                const SizedBox(height: 24),
                Text(
                  'Quiz Completed!',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Your Score',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${quizProvider.score}/${quizProvider.questions.length}',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Category: ${quizProvider.selectedCategory}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your name for the leaderboard:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Your name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveScore,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Save Score'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.leaderboard);
                  },
                  child: const Text('Skip'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}