import 'package:flutter/material.dart';
import 'package:flashwiz/models/flashcard.dart';
import 'package:flashwiz/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addFlashcard() {
    if (_formKey.currentState!.validate()) {
      final options = _optionControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      if (options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least 2 options for MCQ')),
        );
        return;
      }
      if (!options.contains(_answerController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The answer must be one of the options')),
        );
        return;
      }
      final newFlashcard = Flashcard(
        question: _questionController.text,
        answer: _answerController.text,
        isMCQ: true,
        options: options,
      );
      Provider.of<FlashcardProvider>(context, listen: false).addFlashcard(newFlashcard);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flashcard added!')),
      );
      _questionController.clear();
      _answerController.clear();
      for (var controller in _optionControllers) {
        controller.clear();
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
                  const SizedBox(height: 16),
                  const Text('Options (including the correct answer):'),
                  const SizedBox(height: 8),
                  ..._optionControllers.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        width: constraints.maxWidth > 600 ? constraints.maxWidth * 0.8 : double.infinity,
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: 'Option ${entry.key + 1}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: constraints.maxWidth > 600 ? 300 : double.infinity,
                      child: FilledButton.icon(
                        onPressed: _addFlashcard,
                        icon: const Icon(Icons.save),
                        label: const Text('Add Flashcard'),
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

