import 'package:flutter/material.dart';

class MakerSurveyQuestion {
  final UniqueKey key = UniqueKey();
  TextEditingController controller = TextEditingController();
  String question;

  // constructor with question will set the question and controller text to question value
  MakerSurveyQuestion({required this.question}) {
    controller.text = question;
  }
}
