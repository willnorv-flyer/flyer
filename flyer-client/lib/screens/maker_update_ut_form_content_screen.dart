import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_choose_ut_survey_form_screen.dart';
import 'package:flyer_client/screens/maker_purchase_ut_screen.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:flyer_client/widget/maker_survey_question.dart';

class MakerUpdateUTFormContentScreen extends StatefulWidget {
  const MakerUpdateUTFormContentScreen({
    super.key,
    required this.utClientModel,
  });

  final UtClientModel utClientModel;

  @override
  State<MakerUpdateUTFormContentScreen> createState() =>
      _MakerUpdateUTFormContentScreenState();
}

class _MakerUpdateUTFormContentScreenState
    extends State<MakerUpdateUTFormContentScreen> {
  bool showDeleteIcon = false;
  var questions = <MakerSurveyQuestion>[];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.utClientModel.surveyQuestions?.isNotEmpty == true) {
      for (var question in widget.utClientModel.surveyQuestions!) {
        questions.add(MakerSurveyQuestion(question: question));
      }
    } else {
      for (var i = 0; i < 5; i++) {
        questions.add(MakerSurveyQuestion(question: ""));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.utClientModel.surveyQuestions =
            questions.map((e) => e.question).toList();
        Navigator.of(context).pop(widget.utClientModel);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text(
            "설문 만들기",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
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
                            "UT 생성 취소",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "입력한 정보가 모두 사라집니다.\nUT 생성을 취소하시겠습니까?",
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
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 5),
                                child: Text(
                                  "네 취소합니다.",
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
                                  "닫기",
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
                                setState(() {
                                  questions[index].question = value;
                                });
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
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MakerChooseUTSurveyFormScreen(
                      utClientModel: widget.utClientModel,
                    ),
                    isScrollControlled: true,
                    useSafeArea: true,
                  ).then(
                    (value) => {
                      if (value != null && value is UtClientModel)
                        {
                          setState(
                            () {
                              widget.utClientModel.surveyQuestions =
                                  value.surveyQuestions;
                              questions.clear();
                              for (var question in value.surveyQuestions!) {
                                questions.add(
                                    MakerSurveyQuestion(question: question));
                              }
                            },
                          )
                        },
                    },
                  );
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
                        Image.asset(
                          "assets/images/document_import.png",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "설문양식 불러오기",
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
                  widget.utClientModel.surveyQuestions =
                      questions.map((e) => e.question).toList();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MakerPurchaseUTScreen(
                      utClientModel: widget.utClientModel,
                    );
                  })).then((value) {
                    if (value != null && value is UtClientModel) {
                      setState(() {
                        widget.utClientModel.testerCount = value.testerCount;
                      });
                    }
                  });
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
                      "다음",
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
      ),
    );
  }
}
