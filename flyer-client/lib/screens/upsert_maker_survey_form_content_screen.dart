import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/models/survey_form.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:flyer_client/widget/maker_survey_question.dart';

class UpsertMakerSurveyFormContentScreen extends StatefulWidget {
  const UpsertMakerSurveyFormContentScreen({
    super.key,
    required this.surveyForm,
  });

  final SurveyForm surveyForm;

  @override
  State<UpsertMakerSurveyFormContentScreen> createState() =>
      _UpsertMakerSurveyFormContentScreenState();
}

class _UpsertMakerSurveyFormContentScreenState
    extends State<UpsertMakerSurveyFormContentScreen> {
  bool showDeleteIcon = false;
  var questions = <MakerSurveyQuestion>[];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.surveyForm.id != 0) {
      widget.surveyForm.questions().forEach((question) {
        questions.add(MakerSurveyQuestion(question: question));
      });
    } else {
      questions.add(MakerSurveyQuestion(question: ""));
      questions.add(MakerSurveyQuestion(question: ""));
      questions.add(MakerSurveyQuestion(question: ""));
      questions.add(MakerSurveyQuestion(question: ""));
      questions.add(MakerSurveyQuestion(question: ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.surveyForm.name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "취소",
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
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: ReorderableListView(
            scrollController: _scrollController,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final MakerSurveyQuestion item = questions.removeAt(oldIndex);
                questions.insert(newIndex, item);
              });
            },
            onReorderStart: (index) {
              FocusScope.of(context).unfocus();
            },
            children: [
              for (var (index, _) in questions.indexed)
                Slidable(
                  key: ValueKey(questions[index].key),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.2,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            questions.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(errorColor),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "assets/images/trash_can.png",
                              width: 24,
                              height: 24,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: InkWell(
                    key: ValueKey(questions[index].key),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.menu,
                              size: 20,
                              color: Color(0x993C3C43),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${index + 1}. 질문",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                // rgba 60 60 67, 0.6
                                color: Color(0x993C3C43),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        // text field should be editable.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            // rgb 242 242 247
                            color: const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.top,
                            minLines: 2,
                            maxLines: 10,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.4,
                            ),
                            decoration: const InputDecoration(
                              hintText: "질문을 입력해주세요.",
                              hintStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.4,
                                // rgba 60 60 67, 0.6
                                color: Color(0x993C3C43),
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(
                                () {
                                  questions[index].question = value;
                                  widget.surveyForm.setQuestions(
                                    questions
                                        .map((question) => question.question)
                                        .toList(),
                                  );
                                },
                              );
                            },
                            keyboardType: TextInputType.text,
                            controller: questions[index].controller,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 45,
        ),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // + 질문 추가 button. with full width available
            questions.length >= 20
                ? Container()
                : GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        questions.add(MakerSurveyQuestion(question: ""));
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 120,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                    },
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Color(primaryColor),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "질문 추가",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (questions.length < 5) {
                  Fluttertoast.showToast(
                    msg: "질문을 5개 이상 입력해주세요.",
                  );
                  return;
                }
                // 하나라도 공백이면 저장하지 않는다.
                if (questions.any((question) => question.question.isEmpty)) {
                  Fluttertoast.showToast(
                    msg: "질문을 모두 입력해주세요.",
                  );
                  return;
                }
                Response res = widget.surveyForm.id == 0
                    ? await createSurveyForm(
                        widget.surveyForm.name,
                        questions.isNotEmpty ? questions[0].question : "",
                        questions.length > 1 ? questions[1].question : "",
                        questions.length > 2 ? questions[2].question : "",
                        questions.length > 3 ? questions[3].question : "",
                        questions.length > 4 ? questions[4].question : "",
                        questions.length > 5 ? questions[5].question : "",
                        questions.length > 6 ? questions[6].question : "",
                        questions.length > 7 ? questions[7].question : "",
                        questions.length > 8 ? questions[8].question : "",
                        questions.length > 9 ? questions[9].question : "",
                        questions.length > 10 ? questions[10].question : "",
                        questions.length > 11 ? questions[11].question : "",
                        questions.length > 12 ? questions[12].question : "",
                        questions.length > 13 ? questions[13].question : "",
                        questions.length > 14 ? questions[14].question : "",
                        questions.length > 15 ? questions[15].question : "",
                        questions.length > 16 ? questions[16].question : "",
                        questions.length > 17 ? questions[17].question : "",
                        questions.length > 18 ? questions[18].question : "",
                        questions.length > 19 ? questions[19].question : "",
                      )
                    : await updateSurveyForm(
                        widget.surveyForm.id,
                        widget.surveyForm.name,
                        questions.isNotEmpty ? questions[0].question : "",
                        questions.length > 1 ? questions[1].question : "",
                        questions.length > 2 ? questions[2].question : "",
                        questions.length > 3 ? questions[3].question : "",
                        questions.length > 4 ? questions[4].question : "",
                        questions.length > 5 ? questions[5].question : "",
                        questions.length > 6 ? questions[6].question : "",
                        questions.length > 7 ? questions[7].question : "",
                        questions.length > 8 ? questions[8].question : "",
                        questions.length > 9 ? questions[9].question : "",
                        questions.length > 10 ? questions[10].question : "",
                        questions.length > 11 ? questions[11].question : "",
                        questions.length > 12 ? questions[12].question : "",
                        questions.length > 13 ? questions[13].question : "",
                        questions.length > 14 ? questions[14].question : "",
                        questions.length > 15 ? questions[15].question : "",
                        questions.length > 16 ? questions[16].question : "",
                        questions.length > 17 ? questions[17].question : "",
                        questions.length > 18 ? questions[18].question : "",
                        questions.length > 19 ? questions[19].question : "",
                      );
                if (!mounted) {
                  return;
                }
                if (res is Success) {
                  Fluttertoast.showToast(
                    msg: "설문지를 생성했습니다.",
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                    msg: "설문지를 생성하지 못했습니다.",
                  );
                }
              },
              child: InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: questions.length >= 5 && questions.length <= 20
                        ? Color(primaryColor)
                        : Color(disabledBackgroundColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "완료",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: questions.length >= 5 && questions.length <= 20
                          ? Theme.of(context).colorScheme.background
                          : Color(disabledTextColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
