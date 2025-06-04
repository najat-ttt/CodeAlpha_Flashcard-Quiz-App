class Flashcard {
  String question;
  String answer;
  bool isMCQ;
  List<String>? options; // Only for MCQ type

  Flashcard({
    required this.question,
    required this.answer,
    required this.isMCQ,
    this.options,
  }) {
    if (isMCQ && (options == null || options!.isEmpty)) {
      throw ArgumentError('MCQ type requires options');
    }
  }

  // Convert a Flashcard object to a JSON map
  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'isMCQ': isMCQ,
    'options': options,
  };

  // Create a Flashcard object from a JSON map
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
      isMCQ: json['isMCQ'] ?? false,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
    );
  }
}