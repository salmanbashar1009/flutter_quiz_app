class Question {
  final String id;
  final String category;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  Question({
    required this.id,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      category: json['category'],
      questionText: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
    );
  }
}