import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const AnswerOption({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey;
    Color backgroundColor = Colors.transparent;
    IconData? trailingIcon;

    if (showResult) {
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.2);
        trailingIcon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.2);
        trailingIcon = Icons.cancel;
      }
    } else if (isSelected) {
      borderColor = Theme.of(context).primaryColor;
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.2);
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
                child: Text(
                  text,
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