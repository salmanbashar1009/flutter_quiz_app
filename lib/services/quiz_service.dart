import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/questions.dart';

class QuizService {
  Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> data = json.decode(response);

    return data.map((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> getQuestionsByCategory(String category) async {
    final allQuestions = await loadQuestions();
    return allQuestions.where((q) => q.category == category).toList();
  }

  Future<List<String>> getCategories() async {
    final allQuestions = await loadQuestions();
    final categories = allQuestions.map((q) => q.category).toSet().toList();
    categories.sort();
    return categories;
  }
}