import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class QuestionCard extends StatelessWidget {
  final String questionText;
  final int currentQuestion;
  final int totalQuestions;

  const QuestionCard({
    Key? key,
    required this.questionText,
    required this.currentQuestion,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question $currentQuestion of $totalQuestions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$currentQuestion/$totalQuestions',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: TeXView(
                  child: TeXViewDocument(
                    questionText,
                    style: TeXViewStyle(
                      fontStyle: TeXViewFontStyle(
                        fontSize: 18
                      ),
                      padding: TeXViewPadding.all(8),
                      textAlign: TeXViewTextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}