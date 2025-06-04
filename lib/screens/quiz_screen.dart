import 'package:flashwiz/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashwiz/models/flashcard.dart';
import 'package:flashwiz/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Flashcard> _quizFlashcards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  late FlashcardProvider _flashcardProvider;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _flashcardProvider = Provider.of<FlashcardProvider>(context, listen: false);
    _initializeQuiz();
  }

  void _initializeQuiz() {
    _quizFlashcards = List.from(_flashcardProvider.flashcards);
    _quizFlashcards.shuffle(Random());
    _currentIndex = 0;
    _showAnswer = false;
    _selectedAnswer = null;
  }

  void _checkAnswer() {
    final currentCard = _quizFlashcards[_currentIndex];
    bool isCorrect = _selectedAnswer == currentCard.answer;

    _flashcardProvider.recordAnswer(isCorrect);
    
    if (_currentIndex < _quizFlashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _selectedAnswer = null;
      });
    } else {
      _showQuizSummary();
    }
  }

  void _showQuizSummary() {
    final correct = _flashcardProvider.correctAnswers;
    final total = _flashcardProvider.correctAnswers + _flashcardProvider.incorrectAnswers;
    final percentage = (total > 0 ? (correct / total * 100) : 0).toStringAsFixed(1);

    // Navigate directly to the StatsScreen after quiz completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StatsScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Quiz'),
          ),
          body: constraints.maxWidth > 600
              ? Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildQuestionCard(_quizFlashcards[_currentIndex], constraints),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildAnswerSection(_quizFlashcards[_currentIndex], constraints),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: _buildQuestionCard(_quizFlashcards[_currentIndex], constraints),
                    ),
                    if (_showAnswer || (_quizFlashcards[_currentIndex].isMCQ && _selectedAnswer != null))
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: _checkAnswer,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: Text(_currentIndex == _quizFlashcards.length - 1 ? 'Finish Quiz' : 'Next Question'),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildQuestionCard(Flashcard card, BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        horizontal: isWideScreen ? constraints.maxWidth * 0.1 : 16.0,
        vertical: 16.0
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              card.question,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ..._buildMCQOptions(card),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMCQOptions(Flashcard card) {
    return card.options!.map((option) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedAnswer == option
                ? Colors.blue
                : null,
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: _showAnswer ? null : () {
            setState(() {
              _selectedAnswer = option;
              _showAnswer = true;
            });
          },
          child: Text(option),
        ),
      );
    }).toList();
  }

  Widget _buildAnswerSection(Flashcard card, BoxConstraints constraints) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_showAnswer || (card.isMCQ && _selectedAnswer != null))
            Column(
              children: [
                Text(
                  'Correct Answer: ${card.answer}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                  child: Text(_currentIndex == _quizFlashcards.length - 1 ? 'Finish Quiz' : 'Next Question'),
                ),
              ],
            )
          else
            const Text('Select an answer or show the answer to continue.'),
        ],
      ),
    );
  }
}
