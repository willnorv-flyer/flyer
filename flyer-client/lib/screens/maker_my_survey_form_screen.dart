import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/models/survey_form.dart';
import 'package:flyer_client/screens/upsert_maker_survey_form_name_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerMySurveyFormScreen extends StatefulWidget {
  const MakerMySurveyFormScreen({super.key});

  @override
  State<MakerMySurveyFormScreen> createState() =>
      _MakerMySurveyFormScreenState();
}

class _MakerMySurveyFormScreenState extends State<MakerMySurveyFormScreen> {
  Future<Response> querySurveyFormsFuture = querySurveyForms();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "등록된 설문지",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => UpsertMakerSurveyFormNameScreen(
                        surveyForm: SurveyForm(
                          id: 0,
                          userId: 0,
                          name: "",
                          question1: "",
                          question2: "",
                          question3: "",
                          question4: "",
                          question5: "",
                          question6: "",
                          question7: "",
                          question8: "",
                          question9: "",
                          question10: "",
                          question11: "",
                          question12: "",
                          question13: "",
                          question14: "",
                          question15: "",
                          question16: "",
                          question17: "",
                          question18: "",
                          question19: "",
                          question20: "",
                        ),
                      ),
                    ),
                  )
                  .then(
                    (value) => setState(
                      () {
                        querySurveyFormsFuture = querySurveyForms();
                      },
                    ),
                  );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.add, color: Color(primaryColor)),
                  Text(
                    "생성",
                    style: TextStyle(
                      color: Color(primaryColor),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        child: Center(
          child: FutureBuilder(
            future: querySurveyFormsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError ||
                  snapshot.data is Error) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                final surveyForms =
                    ((snapshot.data as Success).data as QuerySurveyFormResponse)
                        .surveyForms;
                if (surveyForms.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "설문지 없음",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "UT에 사용할 수 있는",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline,
                            height: 1),
                      ),
                      Text(
                        "설문지를 만들어보세요!",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: surveyForms.length,
                      itemBuilder: (context, index) {
                        final surveyForm = surveyForms[index];
                        return GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).pop(),
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpsertMakerSurveyFormNameScreen(
                                              surveyForm: surveyForm,
                                            ),
                                          ),
                                        ),
                                      },
                                      child: InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 17,
                                            bottom: 9,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "수정",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color(primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(thickness: 0.3),
                                    GestureDetector(
                                      onTap: () async {
                                        Response deleteAppAssetResponse =
                                            await deleteSurveyForm(
                                                surveyForm.id);
                                        if (!context.mounted) {
                                          return;
                                        }
                                        if (deleteAppAssetResponse is Error) {
                                          Fluttertoast.showToast(
                                            msg: "설문지 삭제에 실패했습니다",
                                          );
                                        } else {
                                          setState(() {
                                            querySurveyFormsFuture =
                                                querySurveyForms();
                                          });
                                          Fluttertoast.showToast(
                                            msg: "설문지를 삭제했습니다",
                                          );
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 9,
                                            bottom: 9,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "삭제",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color(errorColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(thickness: 0.3),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 9,
                                            bottom: 17,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "취소",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: InkWell(
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          surveyForm.name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.4,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${surveyForms[index].questionCount()}문항",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            letterSpacing: -0.4,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/overflow_vertical.png",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Divider(thickness: 0.3),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
