import 'package:flutter/material.dart';
import 'package:flashwiz/screens/add_flashcard_screen.dart';
import 'package:flashwiz/screens/flashcard_list_screen.dart';
import 'package:flashwiz/screens/quiz_screen.dart';
import 'package:flashwiz/screens/stats_screen.dart';
import 'package:provider/provider.dart';
import 'package:flashwiz/providers/flashcard_provider.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlashWiz'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: GridView.count(
                crossAxisCount: constraints.maxWidth < 600 ? 2 : 4,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1.1,
                children: [
                  _buildMinimalFeatureCard(
                    context,
                    title: 'Create',
                    icon: Icons.add_circle_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddFlashcardScreen(),
                      ),
                    ),
                  ),
                  _buildMinimalFeatureCard(
                    context,
                    title: 'Review',
                    icon: Icons.library_books_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlashcardListScreen(),
                      ),
                    ),
                  ),
                  _buildMinimalFeatureCard(
                    context,
                    title: 'Quiz',
                    icon: Icons.quiz_outlined,
                    onTap: () {
                      final flashcards = Provider.of<FlashcardProvider>(
                        context,
                        listen: false,
                      ).flashcards;
                      if (flashcards.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please add some flashcards first!')),
                        );
                      } else {
                        Provider.of<FlashcardProvider>(
                          context,
                          listen: false,
                        ).resetQuizScore();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  _buildMinimalFeatureCard(
                    context,
                    title: 'Stats',
                    icon: Icons.bar_chart_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMinimalFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
