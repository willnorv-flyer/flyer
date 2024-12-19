import 'package:flutter/material.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_choose_ut_target_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerChooseUTSurveyFormScreen extends StatefulWidget {
  const MakerChooseUTSurveyFormScreen({super.key, required this.utClientModel});

  final UtClientModel utClientModel;

  @override
  State<MakerChooseUTSurveyFormScreen> createState() =>
      _MakerChooseUTSurveyFormScreenState();
}

class _MakerChooseUTSurveyFormScreenState
    extends State<MakerChooseUTSurveyFormScreen> {
  Future<Response> querySurveyFormsFuture = querySurveyForms();
  int chosenSurveyFormIndex = -1;
  List<String> surveyFormQuestions = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(widget.utClientModel);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "닫기",
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "설문양식 선택",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 32),
                FutureBuilder(
                  future: querySurveyFormsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySurveyFormResponse querySurveyFormResponse =
                          (snapshot.data as Success).data
                              as QuerySurveyFormResponse;
                      if (querySurveyFormResponse.surveyForms.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "등록한 설문양식 없음",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "내 프로필 > 설문지 관리에서",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    height: 1),
                              ),
                              Text(
                                "설문지를 등록할 수 있습니다.",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            // indexed survey forms
                            for (int i = 0;
                                i < querySurveyFormResponse.surveyForms.length;
                                i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chosenSurveyFormIndex = i;
                                    surveyFormQuestions =
                                        querySurveyFormResponse.surveyForms[i]
                                            .questions();
                                  });
                                },
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                querySurveyFormResponse
                                                    .surveyForms[i].name,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "${querySurveyFormResponse.surveyForms[i].questionCount()}문항",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          chosenSurveyFormIndex == i
                                              ? Icon(
                                                  Icons.check,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                )
                                              : Container()
                                        ],
                                      ),
                                      querySurveyFormResponse
                                                  .surveyForms.length ==
                                              i + 1
                                          ? Container()
                                          : const Divider(thickness: 0.3)
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 64),
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
              GestureDetector(
                onTap: () async {
                  if (chosenSurveyFormIndex != -1) {
                    widget.utClientModel.surveyQuestions = surveyFormQuestions;
                    Navigator.of(context).pop(widget.utClientModel);
                  }
                },
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: chosenSurveyFormIndex != -1
                          ? Color(primaryColor)
                          : Color(disabledBackgroundColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "불러오기",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: chosenSurveyFormIndex != -1
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
