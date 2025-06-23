import 'package:flutter/material.dart';
import 'package:flashwiz/models/flashcard.dart';
import 'package:flashwiz/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';

class AddFlashcardScreen extends StatefulWidget {
  final Flashcard? flashcard;
  final int? index;
  const AddFlashcardScreen({super.key, this.flashcard, this.index});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      _questionController.text = widget.flashcard!.question;
      _answerController.text = widget.flashcard!.answer;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _addFlashcard() {
    if (_formKey.currentState!.validate()) {
      final card = Flashcard(
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        isMCQ: false,
        options: null,
      );
      if (widget.flashcard != null) {
        // Editing: return updated card
        Navigator.of(context).pop(card);
      } else {
        // Adding: add to provider
        Provider.of<FlashcardProvider>(context, listen: false).addFlashcard(card);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Flashcard'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      labelText: 'Question',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a question';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      labelText: 'Correct Option',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an answer';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: constraints.maxWidth > 600 ? 300 : double.infinity,
                      child: FilledButton.icon(
                        onPressed: _addFlashcard,
                        icon: Icon(widget.flashcard != null ? Icons.save_as : Icons.save),
                        label: Text(widget.flashcard != null ? 'Update Flashcard' : 'Add Flashcard'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
