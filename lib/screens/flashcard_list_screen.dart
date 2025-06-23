import 'package:flutter/material.dart';
import 'package:flashwiz/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';
import 'package:flashwiz/screens/add_flashcard_screen.dart';

class FlashcardListScreen extends StatelessWidget {
  const FlashcardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Flashcards'),
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          if (provider.flashcards.isEmpty) {
            return const Center(
              child: Text('No flashcards added yet. Add some to get started!'),
            );
          }
          return ListView.builder(
            itemCount: provider.flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = provider.flashcards[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(
                        flashcard.isMCQ ? Icons.radio_button_checked : Icons.question_answer,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(flashcard.question),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Answer: ${flashcard.answer}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (flashcard.isMCQ && flashcard.options != null) ...[                            
                            const SizedBox(height: 8),
                            const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...flashcard.options!.map((option) => Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                              child: Row(
                                children: [
                                  Icon(
                                    option == flashcard.answer
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    size: 16,
                                    color: option == flashcard.answer ? Colors.green : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(option),
                                ],
                              ),
                            )),
                          ],
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    // Navigate to AddFlashcardScreen in edit mode
                                    final updatedCard = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddFlashcardScreen(
                                          flashcard: flashcard,
                                          index: index,
                                        ),
                                      ),
                                    );
                                    if (updatedCard != null) {
                                      provider.updateFlashcard(index, updatedCard);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Flashcard updated')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Flashcard'),
                                        content: const Text('Are you sure you want to delete this flashcard?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              provider.deleteFlashcard(index);
                                              Navigator.of(ctx).pop();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Flashcard deleted')),
                                              );
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}