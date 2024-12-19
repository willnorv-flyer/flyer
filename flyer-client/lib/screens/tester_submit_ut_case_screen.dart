import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/util/colors.dart';

class TesterSubmitUTCaseScreen extends StatefulWidget {
  const TesterSubmitUTCaseScreen({
    super.key,
    required this.utCase,
  });

  final TesterUTCase utCase;

  @override
  State<TesterSubmitUTCaseScreen> createState() =>
      _TesterSubmitUTCaseScreenState();
}

class _TesterSubmitUTCaseScreenState extends State<TesterSubmitUTCaseScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 11),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "피드백 미완료",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "입력한 내용이 저장되지 않습니다.\n피드백 작성을 중단하시겠습니까?",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 0.3),
                  // 네, 취소합니다.
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 5),
                        child: Text(
                          "중단하기",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 0.3),
                  // 닫기
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 5),
                        child: Text(
                          "취소",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2F2F7),
          scrolledUnderElevation: 0,
          title: Text(
            widget.utCase.ut.appAssetName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (answers.any((element) => element.trim().isEmpty)) {
                  HapticFeedback.lightImpact();
                  Fluttertoast.showToast(msg: "모든 질문에 답변해주세요.");
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 11),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "제출하기",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "제출 이후에는 수정할 수 없습니다.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text("피드백을 제출하시겠습니까?",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              )),
                          const SizedBox(height: 12),
                          const Divider(thickness: 0.3),
                          // 네, 취소합니다.
                          GestureDetector(
                            onTap: () async {
                              Response res = await submitTesterUTCase(
                                  answers, widget.utCase.id);

                              if (!mounted) {
                                return;
                              }

                              if (res is Success) {
                                Fluttertoast.showToast(msg: "피드백이 제출되었습니다.");
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              } else {
                                Fluttertoast.showToast(msg: "피드백 제출에 실패했습니다.");
                              }
                            },
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 5),
                                child: Text(
                                  "제출하기",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(thickness: 0.3),
                          // 닫기
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 5),
                                child: Text(
                                  "취소",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color(primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "제출",
                  style: TextStyle(
                    color: Color(primaryColor),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller:
                              TextEditingController(text: answers[index]),
                          onChanged: (value) {
                            answers[index] = value;
                          },
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(0),
                              hintText: "답변",
                              hintStyle: TextStyle(
                                color: Color(outlinedColor),
                              )),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
