# flutter_quiz_app

Math Quiz App - Flutter
A mobile quiz application built with Flutter that loads questions from a local file, supports LaTeX for math/science questions, runs a quiz, calculates scores, and stores a local leaderboard.
Features

Home Screen: App title with navigation buttons to start quiz or view leaderboard
Category Selection: Choose quiz categories before starting
Quiz Flow:
Loads questions from local JSON file
LaTeX rendering support for mathematical equations
Timed questions (15 seconds countdown)
Progress indicator showing current question number
Smooth animations between questions


Results Screen:
Displays final score out of total
Option to enter name
Save score to local leaderboard


Leaderboard Screen:
Shows top scores sorted by highest first
Persistent storage using Hive database


Dark Mode: Toggle between light and dark themes
Offline Functionality: Works entirely without internet connection

Screenshots


Prerequisites

Flutter SDK: >=3.7.0
Dart SDK: >=2.19.0 <4.0.0

Setup Instructions
1. Clone the Repository
   git clone <repository-url>
   cd flutter-quiz-app

2. Install Dependencies
   flutter pub get

3. Generate Hive Adapters
   flutter pub run build_runner build --delete-conflicting-outputs

4. Run the App
   flutter run

Project Structure
lib/
├── config/
│   ├── app_routes.dart
│   ├── app_theme.dart
│   └── constants.dart
├── models/
│   ├── question.dart
│   ├── quiz_result.dart
│   └── leaderboard_entry.dart
├── screens/
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   ├── results_screen.dart
│   ├── leaderboard_screen.dart
│   └── category_selection_screen.dart
├── services/
│   ├── quiz_service.dart
│   ├── leaderboard_service.dart
│   └── latex_service.dart
├── widgets/
│   ├── question_card.dart
│   ├── answer_option.dart
│   ├── countdown_timer.dart
│   └── custom_button.dart
├── utils/
│   ├── animations.dart
│   └── score_calculator.dart
├── providers/
│   ├── theme_provider.dart
│   ├── quiz_provider.dart
│   └── leaderboard_provider.dart
└── main.dart

Dependencies

flutter_tex: For rendering LaTeX equations
hive: Local database for persistent storage
provider: State management solution
shared_preferences: For theme persistence

Testing
Run unit tests with:
flutter test

Continuous Integration
The project includes GitHub Actions configuration that runs:

flutter analyze to check for code issues
flutter test to run unit tests

Adding Questions
Questions are stored in assets/questions.json in the following format:
[
{
"id": "1",
"category": "Algebra",
"question": "Solve for x: $2x + 5 = 15$",
"options": ["x = 5", "x = 6", "x = 7", "x = 8"],
"correctAnswerIndex": 0,
"explanation": "Subtract 5 from both sides: 2x = 10. Then divide by 2: x = 5."
}
]

Contributing

Fork the repository
Create your feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add some amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

License
This project is licensed under the MIT License - see the LICENSE file for details.