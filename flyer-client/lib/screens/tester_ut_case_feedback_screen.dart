import 'package:flutter/material.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/util/colors.dart';

class TesterUTCaseFeedbackScreen extends StatefulWidget {
  const TesterUTCaseFeedbackScreen({
    super.key,
    required this.utCase,
  });

  final TesterUTCase utCase;

  @override
  State<TesterUTCaseFeedbackScreen> createState() =>
      _TesterUTCaseFeedbackScreenState();
}

class _TesterUTCaseFeedbackScreenState
    extends State<TesterUTCaseFeedbackScreen> {
  var questions = <String>[];
  var answers = <String>[];

  @override
  void initState() {
    super.initState();
    if (widget.utCase.question1.isNotEmpty) {
      questions.add(widget.utCase.question1);
      answers.add(widget.utCase.answer1);
    }
    if (widget.utCase.question2.isNotEmpty) {
      questions.add(widget.utCase.question2);
      answers.add(widget.utCase.answer2);
    }
    if (widget.utCase.question3.isNotEmpty) {
      questions.add(widget.utCase.question3);
      answers.add(widget.utCase.answer3);
    }
    if (widget.utCase.question4.isNotEmpty) {
      questions.add(widget.utCase.question4);
      answers.add(widget.utCase.answer4);
    }
    if (widget.utCase.question5.isNotEmpty) {
      questions.add(widget.utCase.question5);
      answers.add(widget.utCase.answer5);
    }
    if (widget.utCase.question6.isNotEmpty) {
      questions.add(widget.utCase.question6);
      answers.add(widget.utCase.answer6);
    }
    if (widget.utCase.question7.isNotEmpty) {
      questions.add(widget.utCase.question7);
      answers.add(widget.utCase.answer7);
    }
    if (widget.utCase.question8.isNotEmpty) {
      questions.add(widget.utCase.question8);
      answers.add(widget.utCase.answer8);
    }
    if (widget.utCase.question9.isNotEmpty) {
      questions.add(widget.utCase.question9);
      answers.add(widget.utCase.answer9);
    }
    if (widget.utCase.question10.isNotEmpty) {
      questions.add(widget.utCase.question10);
      answers.add(widget.utCase.answer10);
    }
    if (widget.utCase.question11.isNotEmpty) {
      questions.add(widget.utCase.question11);
      answers.add(widget.utCase.answer11);
    }
    if (widget.utCase.question12.isNotEmpty) {
      questions.add(widget.utCase.question12);
      answers.add(widget.utCase.answer12);
    }
    if (widget.utCase.question13.isNotEmpty) {
      questions.add(widget.utCase.question13);
      answers.add(widget.utCase.answer13);
    }
    if (widget.utCase.question14.isNotEmpty) {
      questions.add(widget.utCase.question14);
      answers.add(widget.utCase.answer14);
    }
    if (widget.utCase.question15.isNotEmpty) {
      questions.add(widget.utCase.question15);
      answers.add(widget.utCase.answer15);
    }
    if (widget.utCase.question16.isNotEmpty) {
      questions.add(widget.utCase.question16);
      answers.add(widget.utCase.answer16);
    }
    if (widget.utCase.question17.isNotEmpty) {
      questions.add(widget.utCase.question17);
      answers.add(widget.utCase.answer17);
    }
    if (widget.utCase.question18.isNotEmpty) {
      questions.add(widget.utCase.question18);
      answers.add(widget.utCase.answer18);
    }
    if (widget.utCase.question19.isNotEmpty) {
      questions.add(widget.utCase.question19);
      answers.add(widget.utCase.answer19);
    }
    if (widget.utCase.question20.isNotEmpty) {
      questions.add(widget.utCase.question20);
      answers.add(widget.utCase.answer20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.utCase.ut.appAssetName,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GestureDetector(
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 15,
            top: 5,
          ),
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              // submittedAt yyyy.MM.dd HH:mm:ss
              Text(
                "${widget.utCase.submittedAt.toString().substring(0, 10)} ${widget.utCase.submittedAt.toString().substring(11, 16)}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(outlinedColor),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 20),
              for (var (index, _) in questions.indexed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${index + 1}. ${questions[index]}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        // rgba 60 60 67, 0.6
                        color: Color(outlinedColor),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // answer textfield
                    Text(
                      answers[index],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
