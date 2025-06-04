import 'package:flutter/material.dart';
import 'package:flashwiz/models/flashcard.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FlashcardProvider with ChangeNotifier {
  List<Flashcard> _flashcards = [];
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;

  List<Flashcard> get flashcards => _flashcards;
  int get correctAnswers => _correctAnswers;
  int get incorrectAnswers => _incorrectAnswers;

  FlashcardProvider() {
    _loadFlashcards(); // Load flashcards when the provider is initialized
  }

  void addFlashcard(Flashcard card) {
    _flashcards.add(card);
    _saveFlashcards(); // Save changes
    notifyListeners();
  }

  void updateFlashcard(int index, Flashcard newCard) {
    if (index >= 0 && index < _flashcards.length) {
      _flashcards[index] = newCard;
      _saveFlashcards();
      notifyListeners();
    }
  }

  void deleteFlashcard(int index) {
    if (index >= 0 && index < _flashcards.length) {
      _flashcards.removeAt(index);
      _saveFlashcards();
      notifyListeners();
    }
  }

  void recordAnswer(bool isCorrect) {
    if (isCorrect) {
      _correctAnswers++;
    } else {
      _incorrectAnswers++;
    }
    notifyListeners();
  }

  void resetQuizScore() {
    _correctAnswers = 0;
    _incorrectAnswers = 0;
    notifyListeners();
  }

  // --- Persistence using shared_preferences ---
  Future<void> _saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert list of Flashcard objects to a list of JSON strings
    final String encodedData = jsonEncode(_flashcards.map((card) => card.toJson()).toList());
    await prefs.setString('flashcards', encodedData);
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('flashcards');
    if (encodedData != null) {
      // Decode JSON string back to a list of maps, then to Flashcard objects
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _flashcards = decodedData.map((json) => Flashcard.fromJson(json)).toList();
    }
    notifyListeners(); // Notify listeners once loaded
  }
}