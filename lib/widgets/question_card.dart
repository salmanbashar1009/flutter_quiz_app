import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class QuestionCard extends StatelessWidget {
  final String questionText;
  final int currentQuestion;
  final int totalQuestions;

  const QuestionCard({
    super.key,
    required this.questionText,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  // Extract LaTeX portions and clean them
  List<(String plainText, String latexText)> _parseQuestion(String input) {
    List<(String, String)> parts = [];
    String remaining = input.trim();
    RegExp latexPattern = RegExp(r'\\\(.*?\\\)'); // Match \(...\)

    while (true) {
      final match = latexPattern.firstMatch(remaining);
      if (match == null) {
        if (remaining.isNotEmpty) parts.add((remaining, ''));
        break;
      }
      if (match.start > 0) {
        parts.add((remaining.substring(0, match.start).trim(), ''));
      }
      final latex = match.group(0)!
          .replaceAll(RegExp(r'\\\(|\\\)$'), '') // Remove \( and \)
          .trim();
      parts.add(('', latex));
      remaining = remaining.substring(match.end).trim();
      if (remaining.isEmpty) break;
    }

    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final parts = _parseQuestion(questionText);

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
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: parts.map((part) {
                      final (plainText, latexText) = part;
                      return [
                        if (plainText.isNotEmpty)
                          Text(
                            plainText,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                          ),
                        if (latexText.isNotEmpty)
                          Math.tex(
                            latexText,
                            mathStyle: MathStyle.text,
                            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                            onErrorFallback: (error) => Text(
                              'Error: ${error.message} (Input: "$questionText")',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ),
                      ];
                    }).expand((widget) => widget).toList(),
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