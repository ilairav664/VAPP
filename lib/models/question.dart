class Question {
  final int questionId;
  final String text;
  final bool type;

  const Question({
    required this.questionId,
    required this.text,
    required this.type,
  });

  factory Question.fromJson(Map<dynamic, dynamic> json) {
    return Question(
        questionId: json['questionId'],
        text: json['text'],
        type: json['type'],
        );
  }
}