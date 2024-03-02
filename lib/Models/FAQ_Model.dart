class FAQMODEL {
  final String question;
  final String answer;

  FAQMODEL({required this.question, required this.answer});

  factory FAQMODEL.fromJson(Map<String, dynamic> json) {
    return FAQMODEL(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
