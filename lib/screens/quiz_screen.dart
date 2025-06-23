import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcards = Provider.of<FlashcardProvider>(context).flashcards;
    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No flashcards available. Please add some flashcards first.')),
      );
    }
    final card = flashcards[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _showAnswer = false;
              });
            },
            tooltip: 'Restart Quiz',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  card.question,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!_showAnswer)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAnswer = true;
                  });
                },
                child: const Text('Show Answer'),
              ),
            if (_showAnswer)
              Card(
                color: Colors.green[50],
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    card.answer,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex--;
                        _showAnswer = false;
                      });
                    },
                    child: const Text('Previous'),
                  ),
                if (_currentIndex < flashcards.length - 1)
                  OutlinedButton(
                    onPressed: _showAnswer
                        ? () {
                            setState(() {
                              _currentIndex++;
                              _showAnswer = false;
                            });
                          }
                        : null,
                    child: const Text('Next'),
                  ),
                if (_currentIndex == flashcards.length - 1 && _showAnswer)
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Quiz Completed!'),
                          content: const Text('You have reached the end of the quiz.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                setState(() {
                                  _currentIndex = 0;
                                  _showAnswer = false;
                                });
                              },
                              child: const Text('Restart'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Finish'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
