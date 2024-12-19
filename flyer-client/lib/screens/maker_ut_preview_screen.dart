import 'package:flutter/material.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/linear_loading_bar.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_update_ut_form_content_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerUTPreviewScreen extends StatefulWidget {
  MakerUTPreviewScreen({super.key, required this.utClientModel});

  UtClientModel utClientModel;

  @override
  State<MakerUTPreviewScreen> createState() => _MakerUTPreviewScreenState();
}

class _MakerUTPreviewScreenState extends State<MakerUTPreviewScreen> {
  Future<Response>? googlePlayAppDetailFuture;
  Future<Response>? appStoreAppDetailFuture;

  @override
  void initState() {
    super.initState();
    if (widget.utClientModel.appAsset != null &&
        widget.utClientModel.appAsset?.platform == "ANDROID") {
      googlePlayAppDetailFuture =
          scrapeGooglePlayAppDetail(widget.utClientModel.appAsset!.appId);
    } else if (widget.utClientModel.appAsset != null &&
        widget.utClientModel.appAsset?.platform == "IOS") {
      appStoreAppDetailFuture =
          scrapeAppStoreAppDetail(widget.utClientModel.appAsset!.appId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(widget.utClientModel);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "미리보기",
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
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    widget.utClientModel.appAsset?.iconUrl == null
                        ? Container(
                            width: 112,
                            height: 112,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.utClientModel.appAsset!.iconUrl,
                              width: 112,
                              height: 112,
                            ),
                          ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.utClientModel.appAsset?.category ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(primaryColor),
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          widget.utClientModel.appAsset?.name ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Text(
                                "${widget.utClientModel.surveyQuestions?.length ?? 0}문항",
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
                                "${(widget.utClientModel.surveyQuestions?.length ?? 0) * 20}윙스",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0x993C3C43),
                                  height: 1.0,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(primaryColor),
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
                      widget.utClientModel.targetUserDescription ?? "",
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
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
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
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 45.0),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MakerUpdateUTFormContentScreen(
                        utClientModel: widget.utClientModel,
                      );
                    },
                  ),
                ).then((value) => {
                      if (value != null && value is UtClientModel)
                        {
                          setState(() {
                            widget.utClientModel = value;
                          })
                        }
                    });
              },
              child: Text(
                "다음",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
