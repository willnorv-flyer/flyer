import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/screens/tester_submit_ut_case_screen.dart';
import 'package:flyer_client/screens/tester_ut_case_feedback_screen.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TesterMyUTCasesScreen extends StatefulWidget {
  const TesterMyUTCasesScreen({super.key});

  @override
  State<TesterMyUTCasesScreen> createState() => _TesterMyUTCasesScreenState();
}

class _TesterMyUTCasesScreenState extends State<TesterMyUTCasesScreen> {
  Future<Response> queryTesterUtCasesFuture = queryTesterUTCases();
  String statusFilter = "ACTIVE";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            // tab bar of "참여 중" and "참여완료"
            child: Stack(
              children: [
                // Underline
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: const Color(0xFFE5E5EA),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          statusFilter = "ACTIVE";
                          queryTesterUtCasesFuture = queryTesterUTCases();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: statusFilter == "ACTIVE"
                                  ? Theme.of(context).colorScheme.onBackground
                                  : const Color(0xFFE5E5EA),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          "참여 중",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: statusFilter == "ACTIVE"
                                ? Theme.of(context).colorScheme.onBackground
                                // gba 60 60 67, 0.3
                                : const Color(0xFF3C3C43).withOpacity(0.3),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          statusFilter = "INACTIVE";
                          queryTesterUtCasesFuture = queryTesterUTCases();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: statusFilter == "INACTIVE"
                                  ? Theme.of(context).colorScheme.onBackground
                                  : const Color(0xFFE5E5EA),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          "참여완료",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: statusFilter == "INACTIVE"
                                ? Theme.of(context).colorScheme.onBackground
                                : const Color(0xFF3C3C43).withOpacity(0.3),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) => Column(
              children: [
                // ut cases
                FutureBuilder(
                  future: queryTesterUtCasesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.hasError ||
                        snapshot.data is Error) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QueryTesterUTCaseResponse response =
                          (snapshot.data as Success).data
                              as QueryTesterUTCaseResponse;
                      List<TesterUTCase> utCases = response.utCases
                          .where((utCase) => statusFilter == "ACTIVE"
                              ? utCase.status == statusFilter
                              : utCase.status != "ACTIVE")
                          .toList();

                      if (utCases.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3),
                            Text(
                              statusFilter == "ACTIVE"
                                  ? "참여 중인 UT 없음"
                                  : "참여완료한 UT 없음",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              statusFilter == "ACTIVE"
                                  ? "프리마켓에서 UT를 참여해주세요!"
                                  : "아직 참여완료된 UT가 없습니다.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.outline,
                                height: 1.0,
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            // UT case 리스트
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: utCases.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            itemBuilder: (context, index) {
                              // n일 남음 계산하기
                              DateTime now = DateTime.now();
                              int daysLeft = DateTime(
                                      utCases[index].createdAt.year,
                                      utCases[index].createdAt.month,
                                      utCases[index].createdAt.day,
                                      23,
                                      59,
                                      59)
                                  .add(const Duration(days: 7))
                                  .difference(DateTime(
                                      now.year, now.month, now.day, 23, 59, 59))
                                  .inDays;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // icon url
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            utCases[index].ut.appAssetIconUrl,
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // name
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                utCases[index].ut.appAssetName,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.25),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // platform
                                            Text(
                                              utCases[index]
                                                  .ut
                                                  .appAssetCategory,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(primaryColor),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // n 문항 | 0 윙스
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${utCases[index].ut.costPerUt ~/ 20} 문항",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: -0.4,
                                                      height: 1.0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                    ),
                                                  ),
                                                  const VerticalDivider(
                                                      thickness: 0.4),
                                                  Text(
                                                    "${utCases[index].ut.costPerUt}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                      letterSpacing: -0.4,
                                                      height: 1.0,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "0 윙스",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(primaryColor),
                                                      letterSpacing: -0.4,
                                                      height: 1.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // vertical 3 dots
                                        const Spacer(),
                                        utCases[index].status == "ACTIVE"
                                            ? GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        SizedBox(
                                                      height: 200,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 9,
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.85,
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                String url = utCases[index]
                                                                            .ut
                                                                            .appAssetPlatform ==
                                                                        "ANDROID"
                                                                    ? "https://play.google.com/store/apps/details?id=${utCases[index].ut.appAssetAppId}"
                                                                    : "https://apps.apple.com/kr/app/id${utCases[index].ut.appAssetAppId}";
                                                                launchUrl(
                                                                    Uri.parse(
                                                                        url));
                                                              },
                                                              child: InkWell(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 9,
                                                                    bottom: 9,
                                                                  ),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.85,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "다운로드",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          primaryColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                              thickness: 0.3),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            0,
                                                                            20,
                                                                            0,
                                                                            11),
                                                                    content:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        const Text(
                                                                          "피드백 포기",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                2),
                                                                        const Text(
                                                                          "포기하면 다시 참여할 수 없습니다.\nUT 참여를 포기하시겠습니까?",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                15),
                                                                        const Divider(
                                                                            thickness:
                                                                                0.3),
                                                                        // 네, 포기합니다.
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            Response
                                                                                result =
                                                                                await resignTesterUTCase(utCases[index].id);
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            if (result
                                                                                is Success) {
                                                                              Fluttertoast.showToast(msg: "피드백을 포기하였습니다.");
                                                                            } else {
                                                                              Fluttertoast.showToast(msg: "피드백 포기에 실패하였습니다.");
                                                                            }
                                                                            Navigator.of(context).popUntil((route) =>
                                                                                route.isFirst);
                                                                            setState(() {
                                                                              queryTesterUtCasesFuture = queryTesterUTCases();
                                                                            });
                                                                          },
                                                                          child:
                                                                              InkWell(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 5),
                                                                              child: Text(
                                                                                "네 포기합니다.",
                                                                                style: TextStyle(
                                                                                  fontSize: 17,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(errorColor),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Divider(
                                                                            thickness:
                                                                                0.3),
                                                                        // 닫기
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              InkWell(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 5),
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
                                                            child: InkWell(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 9,
                                                                  bottom: 9,
                                                                ),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.85,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "피드백 포기",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        errorColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                              thickness: 0.3),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: InkWell(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 9,
                                                                  bottom: 17,
                                                                ),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.85,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "취소",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Theme.of(
                                                                            context)
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
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        utCases[index]
                                            .ut
                                            .appAssetShortDescription,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // 피드백 남기기 버튼 primary. full width possible
                                    GestureDetector(
                                      onTap: () {
                                        if (utCases[index].status == "ACTIVE") {
                                          Navigator.of(context)
                                              .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TesterSubmitUTCaseScreen(
                                                    utCase: utCases[index],
                                                  ),
                                                ),
                                              )
                                              .then(
                                                (value) => setState(
                                                  () {
                                                    queryTesterUtCasesFuture =
                                                        queryTesterUTCases();
                                                  },
                                                ),
                                              );
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TesterUTCaseFeedbackScreen(
                                                utCase: utCases[index],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: InkWell(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: (utCases[index].status ==
                                                        "ACTIVE" ||
                                                    utCases[index].status ==
                                                        "FINISHED")
                                                ? Color(primaryColor)
                                                : Color(outlinedColor),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            utCases[index].status == "ACTIVE"
                                                ? "피드백 남기기($daysLeft일 남음)"
                                                : utCases[index].status ==
                                                        "FINISHED"
                                                    ? "피드백 확인하기"
                                                    : "피드백 미제출",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
