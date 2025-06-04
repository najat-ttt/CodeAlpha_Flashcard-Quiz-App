import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashwiz/providers/flashcard_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context);
    final total = provider.correctAnswers + provider.incorrectAnswers;
    final percent = total > 0 ? (provider.correctAnswers / total * 100).toStringAsFixed(1) : '0';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Stats'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Quiz Progress', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Text('Correct Answers: ${provider.correctAnswers}', style: const TextStyle(fontSize: 18)),
                Text('Incorrect Answers: ${provider.incorrectAnswers}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Text('Total Attempts: $total', style: const TextStyle(fontSize: 16)),
                Text('Accuracy: $percent%', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    provider.resetQuizScore();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Stats reset!')),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Stats'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

