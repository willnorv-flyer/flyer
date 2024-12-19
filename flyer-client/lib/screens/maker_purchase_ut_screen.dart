import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/models/app_asset.dart';
import 'package:flyer_client/models/survey_form.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_ut_preview_screen.dart';
import 'package:flyer_client/screens/upsert_maker_survey_form_content_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerPurchaseUTScreen extends StatefulWidget {
  MakerPurchaseUTScreen({super.key, required this.utClientModel});

  UtClientModel utClientModel;

  @override
  State<MakerPurchaseUTScreen> createState() => _MakerPurchaseUTScreenState();
}

class _MakerPurchaseUTScreenState extends State<MakerPurchaseUTScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(widget.utClientModel);
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(mildBackgroundColor),
        appBar: AppBar(
          backgroundColor: Color(mildBackgroundColor),
          title: const Text(
            "결제하기",
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("앱",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.outline)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.utClientModel.appAsset!.iconUrl,
                              width: 60,
                              height: 60,
                            ),
                          ),
                          // title max 2 lines overflow ellipsis
                          title: Text(
                            widget.utClientModel.appAsset!.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.utClientModel.appAsset!.platform == "IOS"
                                    ? "App Store"
                                    : "Google Play",
                                style: TextStyle(
                                  color: Color(primaryColor),
                                  fontSize: 12,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              Text(
                                widget.utClientModel.appAsset!.shortDescription,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 13,
                                  letterSpacing: -0.4,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          onTap: () async {},
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("질문 수",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.outline)),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.utClientModel.surveyQuestions!.length} 문항",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.4,
                                    height: 1.5,
                                  ),
                                ),
                                Text(
                                  "${widget.utClientModel.surveyQuestions!.length * 20} 윙스",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("테스터 수",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.outline)),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // - button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (widget.utClientModel.testerCount >
                                          3) {
                                        HapticFeedback.lightImpact();
                                        widget.utClientModel.testerCount--;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, top: 2.0, bottom: 2.0),
                                    child: Icon(
                                      Icons.remove,
                                      size: 20,
                                      color:
                                          widget.utClientModel.testerCount > 3
                                              ? Color(primaryColor)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withAlpha(100),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${widget.utClientModel.testerCount}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.4,
                                    height: 1.5,
                                  ),
                                ),
                                // + button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (widget.utClientModel.testerCount <
                                          10) {
                                        HapticFeedback.lightImpact();
                                        widget.utClientModel.testerCount++;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 2.0, bottom: 2.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color:
                                          widget.utClientModel.testerCount < 10
                                              ? Color(primaryColor)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withAlpha(100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // info mark and description
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0x993C3C43),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "최소 테스터 수는 3명입니다.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                  letterSpacing: -0.4,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("경제내역",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.outline)),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "질문 수",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.4,
                                    height: 1.5,
                                  ),
                                ),
                                Text(
                                  "${widget.utClientModel.surveyQuestions!.length} 문항",
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
                            const Divider(thickness: 0.3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "테스터 수",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.4,
                                    height: 1.5,
                                  ),
                                ),
                                Text(
                                  "${widget.utClientModel.testerCount} 명",
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
                            const Divider(thickness: 0.3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "총 윙스",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.4,
                                    height: 1.5,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${widget.utClientModel.surveyQuestions!.length * 20 * widget.utClientModel.testerCount} 윙스",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        decorationThickness: 1.5,
                                        letterSpacing: -0.4,
                                        height: 1.5,
                                      ),
                                    ),
                                    Text(
                                      "0 윙스",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Color(primaryColor),
                                        letterSpacing: -0.4,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0x993C3C43),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "베타테스트 기간에는 0윙스로 서비스를 이용할 수 있습니다.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  // rgba 60 60 67, 0.6
                                  color: Color(0x993C3C43),
                                  letterSpacing: -0.4,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
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
              GestureDetector(
                onTap: () async {
                  Response response = await createUT(widget.utClientModel);
                  if (!mounted) {
                    return;
                  }
                  if (response is Success) {
                    HapticFeedback.mediumImpact();
                    Fluttertoast.showToast(
                      msg: "UT를 생성했습니다.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    Fluttertoast.showToast(
                      msg: "UT 생성에 실패했습니다.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Color(primaryColor),
                      textColor: Colors.white,
                    );
                  }
                },
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "UT 생성하기",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.background,
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
