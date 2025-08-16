import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_routes.dart';
import '../providers/leaderboard_provider.dart';
import '../providers/theme_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              leaderboardProvider.loadLeaderboard(category: _selectedCategory);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCategory = value == 'All' ? null : value;
              });
              leaderboardProvider.loadLeaderboard(category: _selectedCategory);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All',
                child: Text('All Categories'),
              ),
              const PopupMenuItem(
                value: 'Algebra',
                child: Text('Algebra'),
              ),
              const PopupMenuItem(
                value: 'Geometry',
                child: Text('Geometry'),
              ),
              const PopupMenuItem(
                value: 'Calculus',
                child: Text('Calculus'),
              ),
              const PopupMenuItem(
                value: 'Trigonometry',
                child: Text('Trigonometry'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text('Category: $_selectedCategory'),
                onDeleted: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                  leaderboardProvider.loadLeaderboard();
                },
              ),
            ),
          Expanded(
            child: leaderboardProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : leaderboardProvider.leaderboardEntries.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.leaderboard,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No scores yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to take a quiz!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: leaderboardProvider.leaderboardEntries.length,
              itemBuilder: (context, index) {
                final entry = leaderboardProvider.leaderboardEntries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(entry.playerName),
                    subtitle: Text('${entry.score}/${entry.totalQuestions} (${entry.percentage.toStringAsFixed(1)}%)'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (entry.category != 'All')
                          Text(
                            entry.category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}