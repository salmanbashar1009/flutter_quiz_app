import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  // Enhanced LaTeX cleaning and formatting
  String _cleanLatex(String input) {
    // Remove \(...\) delimiters
    String cleaned = input
        .replaceAll(RegExp(r'\\\(|\\\)$'), '') // Remove \( and \)
        .trim();

    // Ensure proper bracketing and spacing
    if (cleaned.contains(')(')) {
      final terms = cleaned.split(')(');
      for (int i = 0; i < terms.length; i++) {
        terms[i] = terms[i].trim();
        if (!terms[i].startsWith('(')) terms[i] = '(' + terms[i];
        if (!terms[i].endsWith(')')) terms[i] = terms[i] + ')';
        terms[i] = terms[i].replaceAllMapped(RegExp(r'([+\-])'), (match) => ' ${match.group(0)} ');
      }
      cleaned = terms.join(')(');
    } else {
      cleaned = cleaned.replaceAllMapped(RegExp(r'([+\-])'), (match) => ' ${match.group(0)} ');
      if (cleaned.contains('^') && !cleaned.startsWith('(')) {
        cleaned = '(' + cleaned + ')';
      }
    }

    return cleaned.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cleanedText = _cleanLatex(text);
    Color borderColor = Colors.grey;
    Color backgroundColor = Colors.transparent;
    IconData? trailingIcon;

    if (showResult) {
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withAlpha(100);
        trailingIcon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withAlpha(100);
        trailingIcon = Icons.cancel;
      }
    } else if (isSelected) {
      borderColor = Theme.of(context).primaryColor;
      backgroundColor = Theme.of(context).primaryColor.withAlpha(100);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: showResult ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: cleanedText.isNotEmpty
                    ? Math.tex(
                  cleanedText,
                  mathStyle: MathStyle.text,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  onErrorFallback: (error) => Text(
                    'Error: ${error.message} (Input: "$text")',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                )
                    : Text(
                  'Answer text is empty',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (trailingIcon != null)
                Icon(
                  trailingIcon,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}