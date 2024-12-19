import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/api/push_notification.dart';
import 'package:flyer_client/linear_loading_bar.dart';
import 'package:flyer_client/screens/maker_my_app_screen.dart';
import 'package:flyer_client/screens/maker_my_survey_form_screen.dart';
import 'package:flyer_client/screens/maker_update_my_profile_screen.dart';
import 'package:flyer_client/screens/entry_screen.dart';
import 'package:flyer_client/screens/tester_tab_screen.dart';
import 'package:flyer_client/util/app_version.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MakerMyPageScreen extends StatefulWidget {
  const MakerMyPageScreen({super.key});

  @override
  State<MakerMyPageScreen> createState() => _MakerMyPageScreenState();
}

class _MakerMyPageScreenState extends State<MakerMyPageScreen> {
  Future<Response> myInfoFuture = queryMyInfo();
  bool toggleUserMode = false;
  bool isPushAgreed = false;

  @override
  void initState() {
    super.initState();
    myInfoFuture.then(
      (value) => {
        if (value is Success)
          {
            setState(() {
              isPushAgreed =
                  (value.data as MyInfoResponse).user.pushAgreedAt != 0;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(mildBackgroundColor),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(mildBackgroundColor),
            title: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: const Text(
                "내 프로필",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) => Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: myInfoFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.hasError ||
                                      (snapshot.hasData &&
                                          snapshot.data is Error)) {
                                    return GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg: "잠시 후 다시 시도해주세요");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                linearLoadingBar(100, 22),
                                                const SizedBox(height: 5),
                                                linearLoadingBar(150, 18),
                                              ],
                                            ),
                                            // > button
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 17,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    final myInfo = (snapshot.data as Success)
                                        .data as MyInfoResponse;
                                    return GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MakerUpdateMyProfileScreen(
                                                  user: myInfo.user,
                                                ),
                                              ),
                                            )
                                            .then(
                                              (value) => {
                                                setState(
                                                  () {
                                                    myInfoFuture =
                                                        queryMyInfo();
                                                  },
                                                )
                                              },
                                            ),
                                      },
                                      child: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      myInfo.user.nickname,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: -0.4,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      myInfo.user.email,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .outline,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: -0.4,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // > button
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 17,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const Divider(
                                height: 0,
                                indent: 0,
                                thickness: 0.3,
                              ),
                              FutureBuilder(
                                future: myInfoFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.hasError ||
                                      (snapshot.hasData &&
                                          snapshot.data is Error)) {
                                    return GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg: "잠시 후 다시 시도해주세요");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                linearLoadingBar(100, 22),
                                                const SizedBox(height: 5),
                                                linearLoadingBar(150, 18),
                                              ],
                                            ),
                                            // > button
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 17,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "테스터로 전환",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.4,
                                              height: 1.5,
                                            ),
                                          ),
                                          // toggle without any padding
                                          CupertinoSwitch(
                                            value: toggleUserMode,
                                            onChanged: (value) {
                                              setUserMode("TESTER");
                                              setState(() {
                                                toggleUserMode = value;
                                              });
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 300),
                                                () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TesterTabScreen()),
                                                  );
                                                },
                                              );
                                            },
                                            activeColor: Color(primaryColor),
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
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MakerMyAppScreen(),
                                    ),
                                  );
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "앱 등록",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 0.3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MakerMySurveyFormScreen(),
                                    ),
                                  );
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "설문지 관리",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("알림",
                              style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.outline)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "피드백 알림",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.4,
                                      height: 1.5,
                                    ),
                                  ),
                                  // toggle without any padding
                                  FutureBuilder(
                                    future: myInfoFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          snapshot.hasError ||
                                          (snapshot.hasData &&
                                              snapshot.data is Error)) {
                                        return linearLoadingBar(51, 31);
                                      } else {
                                        final myInfo =
                                            (snapshot.data as Success).data
                                                as MyInfoResponse;
                                        return CupertinoSwitch(
                                          value: isPushAgreed,
                                          onChanged: (value) async {
                                            String token =
                                                await PushNotifications
                                                    .getToken();
                                            if (token == "") {
                                              await PushNotifications.init();
                                              if (!mounted) {
                                                return;
                                              }
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .fromLTRB(
                                                            0, 20, 0, 11),
                                                    content: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          "알림 권한 설정",
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 2),
                                                        const Text(
                                                          "알림 권한 설정이 필요합니다.\n설정에서 알림을 허용해주세요.",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        const Divider(
                                                            thickness: 0.3),
                                                        // 닫기
                                                        GestureDetector(
                                                          onTap: () {
                                                            AppSettings
                                                                .openAppSettings(
                                                              type: AppSettingsType
                                                                  .notification,
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          60.0,
                                                                      vertical:
                                                                          5),
                                                              child: Text(
                                                                "확인",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
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
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            } else if (value == true) {
                                              updateMyPushToken(token);
                                              setState(() {
                                                isPushAgreed = true;
                                              });
                                            } else {
                                              updateMyPushToken("");
                                              setState(() {
                                                isPushAgreed = false;
                                              });
                                            }
                                          },
                                          activeColor: Color(primaryColor),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        // 인포 아이콘 + 피드백 기간이 얼마남지 않았을 때 알림을 줍니다.
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "테스터가 피드백을 제출할때마다 알림을 받습니다.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.outline,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("고객센터",
                              style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.outline)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  String url =
                                      "https://flyer.framer.website/notice";
                                  launchUrl(Uri.parse(url));
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "공지사항",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 0.3),
                              GestureDetector(
                                onTap: () {
                                  String url =
                                      "https://yuraseo.notion.site/6742fe59de044f61b888af45ffa8ba89";
                                  launchUrl(Uri.parse(url));
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "메이커 가이드",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 0.3),
                              GestureDetector(
                                onTap: () {
                                  String url =
                                      "https://flyer.framer.website/faq";
                                  launchUrl(Uri.parse(url));
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "자주 묻는 질문",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 0.3),
                              GestureDetector(
                                onTap: () {
                                  String url = "https://flyer.framer.website";
                                  launchUrl(Uri.parse(url));
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "플라이어 소개",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 0.3),
                              GestureDetector(
                                onTap: () {
                                  String url =
                                      "https://flyer.framer.website/policy/terms";
                                  launchUrl(Uri.parse(url));
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "약관 및 정책",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          height: 1.5,
                                        ),
                                      ),
                                      // > button
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 0.3),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "앱 버전",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.4,
                                      height: 1.5,
                                    ),
                                  ),
                                  // > button
                                  Text(
                                    appVersion,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      letterSpacing: -0.4,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // 로그아웃 버튼
                        GestureDetector(
                          onTap: () {
                            setLoginInfo("");
                            setUserMode("TESTER");
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const EntryScreen(
                                  requestPushNotiPermission: false,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 11),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "로그아웃",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                          color: Color(errorColor),
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
