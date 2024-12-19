import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_choose_ut_app_screen.dart';
import 'package:flyer_client/screens/maker_ut_feedback_list_screen.dart';
import 'package:flyer_client/screens/maker_ut_tester_status_screen.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MakerUTScreen extends StatefulWidget {
  const MakerUTScreen({super.key});

  @override
  State<MakerUTScreen> createState() => _MakerUTScreenState();
}

class _MakerUTScreenState extends State<MakerUTScreen> {
  Future<Response> queryUTFuture = queryUTs();
  Future<bool> makerTutorialFuture = getMakerTutorial();
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
            alignment: Alignment.centerLeft,
            child: const Text(
              "UT",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => MakerChooseUTAppScreen(
                          utClientModel: UtClientModel(testerCount: 5),
                        ),
                      ),
                    )
                    .then(
                      (value) => setState(
                        () {
                          queryUTFuture = queryUTs();
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) => Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statusFilter == "ACTIVE"
                              ? Color(primaryColor).withOpacity(0.15)
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            statusFilter = "ACTIVE";
                          });
                        },
                        child: Text(
                          "진행 중",
                          style: TextStyle(
                            color: statusFilter == "ACTIVE"
                                ? Color(primaryColor)
                                : Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statusFilter != "ACTIVE"
                              ? Color(primaryColor).withOpacity(0.15)
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            statusFilter = "FINISHED";
                          });
                        },
                        child: Text(
                          "진행완료",
                          style: TextStyle(
                            color: statusFilter != "ACTIVE"
                                ? Color(primaryColor)
                                : Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: makerTutorialFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError ||
                          snapshot.data is Error) {
                        return const CircularProgressIndicator();
                      } else {
                        bool isTutorial = snapshot.data as bool;
                        return isTutorial
                            ? Column(
                                children: [
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    // rgb 242 242 247
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        String url =
                                            "https://yuraseo.notion.site/6742fe59de044f61b888af45ffa8ba89";
                                        launchUrl(Uri.parse(url));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/images/user_guide.svg'),
                                              const SizedBox(width: 14),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "사용 가이드",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: -0.4,
                                                    ),
                                                  ),
                                                  Text(
                                                    "플라이어 사용법을 확인하세요",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                      letterSpacing: -0.4,
                                                    ),
                                                  ),
                                                  Text(
                                                    "내 프로필>고객센터에서도 가이드를 볼 수 있어요!",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                      letterSpacing: -0.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          // x icon
                                          GestureDetector(
                                            onTap: () {
                                              setMakerTutorial(false);
                                              setState(() {
                                                makerTutorialFuture =
                                                    getMakerTutorial();
                                              });
                                            },
                                            child: Icon(Icons.close,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: queryUTFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError) {
                        return const CircularProgressIndicator();
                      } else {
                        List<UT> uts =
                            ((snapshot.data as Success).data as QueryUTResponse)
                                .uts;
                        return uts
                                .where(
                                    (element) => element.status == statusFilter)
                                .isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25),
                                  Text(
                                    statusFilter == "ACTIVE"
                                        ? "등록된 UT 없음"
                                        : "완료된 UT 없음",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    statusFilter == "ACTIVE"
                                        ? "내 프로필에서 앱을 등록한 후"
                                        : "아직 진행 완료된 UT가 없습니다.",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    statusFilter == "ACTIVE"
                                        ? "UT를 생성해보세요!"
                                        : "",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  ...uts.map((ut) => Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                    ut.appAssetIconUrl,
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      child: Text(
                                                        ut.appAssetName,
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    // platform
                                                    Text(
                                                      ut.appAssetPlatform ==
                                                              "ANDROID"
                                                          ? "Android"
                                                          : "iOS",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(primaryColor),
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                            "${ut.costPerUt ~/ 20} 문항",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  -0.4,
                                                              height: 1.0,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .outline,
                                                            ),
                                                          ),
                                                          const VerticalDivider(
                                                              thickness: 0.4),
                                                          Text(
                                                            "${ut.costPerUt}",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .outline,
                                                              letterSpacing:
                                                                  -0.4,
                                                              height: 1.0,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "0 윙스",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  primaryColor),
                                                              letterSpacing:
                                                                  -0.4,
                                                              height: 1.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // targetUserDescription
                                                    const SizedBox(height: 4),
                                                    SizedBox(
                                                      width: 190,
                                                      child: Text(
                                                        ut.targetUserDescription,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(thickness: 0.4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "테스터",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${ut.activeTesterCount + ut.finishedTesterCount}/${ut.desiredTesterCount}",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "받은 피드백",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${ut.finishedTesterCount}",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            // 테스터 현황 버튼 & 피드백 확인 버튼이 한줄로
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // rgba 118 118 128, 0.12
                                                    backgroundColor:
                                                        const Color(0x1E767880),
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 35,
                                                      vertical: 7,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MakerUTTesterStatusScreen(
                                                          ut: ut,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "테스터 현황",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Color(primaryColor),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(primaryColor),
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 35,
                                                      vertical: 7,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MakerUTFeedbackListScreen(
                                                          ut: ut,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "피드백 확인",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
