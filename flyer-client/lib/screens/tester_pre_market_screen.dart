import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/screens/tester_pre_market_detail_screen.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TesterPreMarketScreen extends StatefulWidget {
  const TesterPreMarketScreen({super.key});

  @override
  State<TesterPreMarketScreen> createState() => _TesterPreMarketScreenState();
}

class _TesterPreMarketScreenState extends State<TesterPreMarketScreen> {
  Future<Response> queryAvailableUTsFuture = queryAvailableUTs();
  Future<bool> testerTutorialFuture = getTesterTutorial();
  String platform = Platform.isAndroid ? "ANDROID" : "IOS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          alignment: Alignment.centerLeft,
          child: const Text(
            "프리마켓",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: testerTutorialFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    snapshot.data is Error) {
                  return const CircularProgressIndicator();
                } else {
                  bool isTutorial = snapshot.data as bool;
                  return isTutorial
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
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
                                    "https://yuraseo.notion.site/14a4cf2095a2499caa7cce432cad38fc";
                                launchUrl(Uri.parse(url));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontWeight: FontWeight.w600,
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
                                      setTesterTutorial(false);
                                      setState(() {
                                        testerTutorialFuture =
                                            getTesterTutorial();
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
                        )
                      : Container();
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: queryAvailableUTsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    snapshot.data is Error) {
                  return const CircularProgressIndicator();
                } else {
                  List<UT> uts =
                      ((snapshot.data as Success).data as QueryUTResponse)
                          .uts
                          .where((ut) => ut.appAssetPlatform == platform)
                          .toList();
                  return uts.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25),
                            const Text(
                              "UT할 수 있는 앱 없음",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "조건에 해당하는 앱이 없습니다.",
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.outline,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              "주변에 플라이어를 추천해주세요!",
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ...uts.map(
                                (ut) => GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TesterPreMarketDetailScreen(ut: ut),
                                      ),
                                    );
                                  },
                                  child: InkWell(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
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
                                                            0.53,
                                                    child: Text(
                                                      ut.appAssetName,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.25,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  // platform
                                                  Text(
                                                    ut.appAssetCategory,
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
                                                                FontWeight.w500,
                                                            letterSpacing: -0.4,
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
                                                                FontWeight.w500,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
                                                            letterSpacing: -0.4,
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
                                                                FontWeight.w500,
                                                            color: Color(
                                                                primaryColor),
                                                            letterSpacing: -0.4,
                                                            height: 1.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(
                                              ut.appAssetShortDescription,
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
                                          const Divider(thickness: 0.4),
                                          SizedBox(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "선호 테스터",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Text(
                                                    ut.targetUserDescription,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.2,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
