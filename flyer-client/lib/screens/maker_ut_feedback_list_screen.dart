import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/screens/%08update_maker_app_screen.dart';
import 'package:flyer_client/screens/maker_ut_feedback_detail_screen.dart';
import 'package:flyer_client/screens/search_maker_app_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerUTFeedbackListScreen extends StatefulWidget {
  const MakerUTFeedbackListScreen({super.key, required this.ut});

  final UT ut;

  @override
  State<MakerUTFeedbackListScreen> createState() =>
      _MakerUTFeedbackListScreenState();
}

class _MakerUTFeedbackListScreenState extends State<MakerUTFeedbackListScreen> {
  Future<Response>? queryMakerUTCasesFuture;

  @override
  void initState() {
    super.initState();
    queryMakerUTCasesFuture = queryMakerUTCases(widget.ut.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "피드백 확인",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 15,
          top: 5,
        ),
        child: FutureBuilder(
          future: queryMakerUTCasesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              if (snapshot.hasError) {
                Fluttertoast.showToast(msg: "Error: ${snapshot.error}");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              QueryMakerUTCaseResponse queryMakerUTCaseResponse =
                  (snapshot.data as Success).data as QueryMakerUTCaseResponse;
              List<MakerUTCase> utCases = queryMakerUTCaseResponse.utCases
                  .where((element) => element.status == "FINISHED")
                  .toList();
              if (utCases.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "받은 피드백 없음",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "UT에 참여한 사용자가 제출한 피드백이",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline,
                            height: 1),
                      ),
                      Text(
                        "여기에 표시됩니다.",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  ...utCases.map(
                    (utCase) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MakerUTFeedbackDetailScreen(
                              utCase: utCase,
                            ),
                          ),
                        );
                      },
                      child: InkWell(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      utCase.testerName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${utCase.submittedAt.toString().substring(0, 10)} ${utCase.submittedAt.toString().substring(11, 16)}",
                                      style: TextStyle(
                                        color: Color(outlinedColor),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Color(outlinedColor)),
                                ),
                              ],
                            ),
                            // last one doesn't have divider
                            if (queryMakerUTCaseResponse.utCases.last != utCase)
                              const Divider(thickness: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
