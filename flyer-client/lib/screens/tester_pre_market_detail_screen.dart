import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/linear_loading_bar.dart';
import 'package:flyer_client/screens/tester_my_ut_cases_screen.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TesterPreMarketDetailScreen extends StatefulWidget {
  const TesterPreMarketDetailScreen({super.key, required this.ut});

  final UT ut;

  @override
  State<TesterPreMarketDetailScreen> createState() =>
      _TesterPreMarketDetailScreenState();
}

class _TesterPreMarketDetailScreenState
    extends State<TesterPreMarketDetailScreen> {
  Future<Response>? googlePlayAppDetailFuture;
  Future<Response>? appStoreAppDetailFuture;

  @override
  void initState() {
    super.initState();
    if (widget.ut.appAssetPlatform == "ANDROID") {
      googlePlayAppDetailFuture =
          scrapeGooglePlayAppDetail(widget.ut.appAssetAppId);
    } else {
      appStoreAppDetailFuture =
          scrapeAppStoreAppDetail(widget.ut.appAssetAppId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.ut.appAssetIconUrl,
                      width: 112,
                      height: 112,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ut.appAssetCategory,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(primaryColor),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          widget.ut.appAssetName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text(
                              "${widget.ut.questionCount()}문항",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0x993C3C43),
                                height: 1.0,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const VerticalDivider(thickness: 0.4),
                            Text(
                              "${widget.ut.costPerUt}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0x993C3C43),
                                height: 1.0,
                                letterSpacing: -0.4,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "0 윙스",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(primaryColor),
                                letterSpacing: -0.4,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          if ((widget.ut.appAssetPlatform != "ANDROID" &&
                                  Platform.isAndroid) ||
                              (widget.ut.appAssetPlatform != "IOS" &&
                                  Platform.isIOS)) {
                            HapticFeedback.mediumImpact();
                            Fluttertoast.showToast(
                              msg:
                                  "현재 기기에서는 ${Platform.isAndroid ? "안드로이드" : "IOS"}를 대상으로 하는 UT만 참여할 수 있습니다.",
                            );
                            return;
                          }

                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SizedBox(
                              height: 260,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 17,
                                      bottom: 9,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          "서비스 이용약관 · 개인정보 처리 방침",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                        ),
                                        Text(
                                          "UT를 시작하기 위해 약관동의가 필요합니다.",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(thickness: 0.3),
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          "https://flyer.framer.website/policy/terms"));
                                    },
                                    child: InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 9,
                                          bottom: 9,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "약관 보기",
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
                                      Response response =
                                          await createTesterUtCase(
                                              widget.ut.id);
                                      if (!mounted) {
                                        return;
                                      }
                                      if (response is Success) {
                                        HapticFeedback.mediumImpact();
                                        Fluttertoast.showToast(
                                          msg: "UT에 참여했습니다.",
                                        );
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        String url = widget
                                                    .ut.appAssetPlatform ==
                                                "ANDROID"
                                            ? "https://play.google.com/store/apps/details?id=${widget.ut.appAssetAppId}"
                                            : "https://apps.apple.com/kr/app/id${widget.ut.appAssetAppId}";
                                        launchUrl(Uri.parse(url));
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "UT에 참여하지 못했습니다.",
                                        );
                                      }
                                    },
                                    child: InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 9,
                                          bottom: 9,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "동의하고 UT 참여하기",
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
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 9,
                                          bottom: 17,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: (widget.ut.appAssetPlatform != "ANDROID" &&
                                        Platform.isAndroid) ||
                                    (widget.ut.appAssetPlatform != "IOS" &&
                                        Platform.isIOS)
                                ? Color(outlinedColor)
                                : Color(primaryColor),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text(
                            "UT 참여하기",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 0.3),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "선호 테스터",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.ut.targetUserDescription,
                    style: const TextStyle(
                      fontSize: 15,
                      // rgba 60 60 67, 0.6
                      color: Color(0x993C3C43),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 0.3),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "설명",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  googlePlayAppDetailFuture == null
                      ? Container()
                      : FutureBuilder(
                          future: googlePlayAppDetailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  linearLoadingBar(
                                      MediaQuery.of(context).size.width * 0.8,
                                      20)
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "앱 설명을 불러오지 못했습니다.",
                                style: TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              PlaystoreAppDetail playstoreAppDetail =
                                  (snapshot.data as Success).data
                                      as PlaystoreAppDetail;
                              return Text(
                                playstoreAppDetail.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                  appStoreAppDetailFuture == null
                      ? Container()
                      : FutureBuilder(
                          future: appStoreAppDetailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  linearLoadingBar(
                                      MediaQuery.of(context).size.width * 0.8,
                                      20)
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "앱 설명을 불러오지 못했습니다.",
                                style: TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              AppstoreAppDetail appstoreAppDetail =
                                  (snapshot.data as Success).data
                                      as AppstoreAppDetail;
                              return Text(
                                appstoreAppDetail.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 0.3),
              const SizedBox(height: 24),
              // 미리보기(사진)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "미리보기",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  googlePlayAppDetailFuture == null
                      ? Container()
                      : FutureBuilder(
                          future: googlePlayAppDetailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  linearLoadingBar(
                                      MediaQuery.of(context).size.width * 0.8,
                                      20)
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "앱 설명을 불러오지 못했습니다.",
                                style: TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              PlaystoreAppDetail playstoreAppDetail =
                                  (snapshot.data as Success).data
                                      as PlaystoreAppDetail;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: playstoreAppDetail.screenshots
                                      .map(
                                        (screenshot) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              screenshot,
                                              height: 215,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                  appStoreAppDetailFuture == null
                      ? Container()
                      : FutureBuilder(
                          future: appStoreAppDetailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  linearLoadingBar(
                                      MediaQuery.of(context).size.width * 0.8,
                                      20)
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "앱 설명을 불러오지 못했습니다.",
                                style: TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              AppstoreAppDetail appstoreAppDetail =
                                  (snapshot.data as Success).data
                                      as AppstoreAppDetail;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: appstoreAppDetail.screenshotUrls
                                      .map(
                                        (screenshot) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              screenshot,
                                              height: 215,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 0.3),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "정보",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  googlePlayAppDetailFuture == null
                      ? Container()
                      : FutureBuilder(
                          future: googlePlayAppDetailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  linearLoadingBar(
                                      MediaQuery.of(context).size.width * 0.8,
                                      20)
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "앱 설명을 불러오지 못했습니다.",
                                style: TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              PlaystoreAppDetail playstoreAppDetail =
                                  (snapshot.data as Success).data
                                      as PlaystoreAppDetail;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "개발자명: ${playstoreAppDetail.developerId}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      // rgba 60 60 67, 0.6
                                      color: Color(0x993C3C43),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "개발자 이메일: ${playstoreAppDetail.developerEmail}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      // rgba 60 60 67, 0.6
                                      color: Color(0x993C3C43),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                  appStoreAppDetailFuture == null
                      ? Container()
                      : FutureBuilder(
                          future: appStoreAppDetailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  linearLoadingBar(
                                      MediaQuery.of(context).size.width * 0.8,
                                      20)
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "앱 설명을 불러오지 못했습니다.",
                                style: TextStyle(
                                  fontSize: 15,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              AppstoreAppDetail appstoreAppDetail =
                                  (snapshot.data as Success).data
                                      as AppstoreAppDetail;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "개발자명: ${appstoreAppDetail.sellerName}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      // rgba 60 60 67, 0.6
                                      color: Color(0x993C3C43),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                ],
              ),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
