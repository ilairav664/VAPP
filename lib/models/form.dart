
import 'package:vapp/models/form.dart';

class Answer {
  final int questionId;
  final double value;

  const Answer({
    required this.questionId,
    required this.value
});
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'value': value.toInt()
  };
}

class Form {
  final int userId;
  final List<Answer> answers;

  const Form({
    required this.userId,
    required this.answers
});
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'answers': answers
  };
}