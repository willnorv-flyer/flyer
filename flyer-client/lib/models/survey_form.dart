class SurveyForm {
  final int id;
  final int userId;
  String name;
  String question1;
  String question2;
  String question3;
  String question4;
  String question5;
  String question6;
  String question7;
  String question8;
  String question9;
  String question10;
  String question11;
  String question12;
  String question13;
  String question14;
  String question15;
  String question16;
  String question17;
  String question18;
  String question19;
  String question20;

  SurveyForm({
    required this.id,
    required this.userId,
    required this.name,
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
    required this.question5,
    required this.question6,
    required this.question7,
    required this.question8,
    required this.question9,
    required this.question10,
    required this.question11,
    required this.question12,
    required this.question13,
    required this.question14,
    required this.question15,
    required this.question16,
    required this.question17,
    required this.question18,
    required this.question19,
    required this.question20,
  });

  factory SurveyForm.fromJson(Map<String, dynamic> json) {
    return SurveyForm(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      question1: json["question1"],
      question2: json["question2"],
      question3: json["question3"],
      question4: json["question4"],
      question5: json["question5"],
      question6: json["question6"],
      question7: json["question7"],
      question8: json["question8"],
      question9: json["question9"],
      question10: json["question10"],
      question11: json["question11"],
      question12: json["question12"],
      question13: json["question13"],
      question14: json["question14"],
      question15: json["question15"],
      question16: json["question16"],
      question17: json["question17"],
      question18: json["question18"],
      question19: json["question19"],
      question20: json["question20"],
    );
  }

  int questionCount() {
    int count = 0;
    if (question1.isNotEmpty) count++;
    if (question2.isNotEmpty) count++;
    if (question3.isNotEmpty) count++;
    if (question4.isNotEmpty) count++;
    if (question5.isNotEmpty) count++;
    if (question6.isNotEmpty) count++;
    if (question7.isNotEmpty) count++;
    if (question8.isNotEmpty) count++;
    if (question9.isNotEmpty) count++;
    if (question10.isNotEmpty) count++;
    if (question11.isNotEmpty) count++;
    if (question12.isNotEmpty) count++;
    if (question13.isNotEmpty) count++;
    if (question14.isNotEmpty) count++;
    if (question15.isNotEmpty) count++;
    if (question16.isNotEmpty) count++;
    if (question17.isNotEmpty) count++;
    if (question18.isNotEmpty) count++;
    if (question19.isNotEmpty) count++;
    if (question20.isNotEmpty) count++;
    return count;
  }

  List<String> questions() {
    List<String> questions = [];
    if (question1.isNotEmpty) questions.add(question1);
    if (question2.isNotEmpty) questions.add(question2);
    if (question3.isNotEmpty) questions.add(question3);
    if (question4.isNotEmpty) questions.add(question4);
    if (question5.isNotEmpty) questions.add(question5);
    if (question6.isNotEmpty) questions.add(question6);
    if (question7.isNotEmpty) questions.add(question7);
    if (question8.isNotEmpty) questions.add(question8);
    if (question9.isNotEmpty) questions.add(question9);
    if (question10.isNotEmpty) questions.add(question10);
    if (question11.isNotEmpty) questions.add(question11);
    if (question12.isNotEmpty) questions.add(question12);
    if (question13.isNotEmpty) questions.add(question13);
    if (question14.isNotEmpty) questions.add(question14);
    if (question15.isNotEmpty) questions.add(question15);
    if (question16.isNotEmpty) questions.add(question16);
    if (question17.isNotEmpty) questions.add(question17);
    if (question18.isNotEmpty) questions.add(question18);
    if (question19.isNotEmpty) questions.add(question19);
    if (question20.isNotEmpty) questions.add(question20);
    return questions;
  }

  void setQuestions(List<String> questions) {
    question1 = "";
    question2 = "";
    question3 = "";
    question4 = "";
    question5 = "";
    question6 = "";
    question7 = "";
    question8 = "";
    question9 = "";
    question10 = "";
    question11 = "";
    question12 = "";
    question13 = "";
    question14 = "";
    question15 = "";
    question16 = "";
    question17 = "";
    question18 = "";
    question19 = "";
    question20 = "";

    for (int i = 0; i < questions.length; i++) {
      switch (i) {
        case 0:
          question1 = questions[i];
          break;
        case 1:
          question2 = questions[i];
          break;
        case 2:
          question3 = questions[i];
          break;
        case 3:
          question4 = questions[i];
          break;
        case 4:
          question5 = questions[i];
          break;
        case 5:
          question6 = questions[i];
          break;
        case 6:
          question7 = questions[i];
          break;
        case 7:
          question8 = questions[i];
          break;
        case 8:
          question9 = questions[i];
          break;
        case 9:
          question10 = questions[i];
          break;
        case 10:
          question11 = questions[i];
          break;
        case 11:
          question12 = questions[i];
          break;
        case 12:
          question13 = questions[i];
          break;
        case 13:
          question14 = questions[i];
          break;
        case 14:
          question15 = questions[i];
          break;
        case 15:
          question16 = questions[i];
          break;
        case 16:
          question17 = questions[i];
          break;
        case 17:
          question18 = questions[i];
          break;
        case 18:
          question19 = questions[i];
          break;
        case 19:
          question20 = questions[i];
          break;
      }
    }
  }
}
