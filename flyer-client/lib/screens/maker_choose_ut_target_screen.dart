import 'package:flutter/material.dart';
import 'package:flyer_client/models/app_asset.dart';
import 'package:flyer_client/models/survey_form.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_ut_preview_screen.dart';
import 'package:flyer_client/screens/upsert_maker_survey_form_content_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerChooseUTTargetScreen extends StatefulWidget {
  const MakerChooseUTTargetScreen({super.key, required this.utClientModel});

  final UtClientModel utClientModel;

  @override
  State<MakerChooseUTTargetScreen> createState() =>
      _MakerChooseUTTargetScreenState();
}

class _MakerChooseUTTargetScreenState extends State<MakerChooseUTTargetScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.utClientModel.targetUserDescription != null) {
      _nameController.text = widget.utClientModel.targetUserDescription!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.utClientModel.targetUserDescription = _nameController.text;
        Navigator.of(context).pop(widget.utClientModel);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // search bar
              const Spacer(),
              const Text(
                "선호 테스터",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x1A767880),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                              decoration: InputDecoration(
                                hintText: "선호 테스터 설명",
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  widget.utClientModel.targetUserDescription =
                                      value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_nameController.text.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _nameController.clear();
                                    widget.utClientModel.targetUserDescription =
                                        "";
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // info mark and description
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
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
                        "UT의 주 대상이 되는 테스터 집단의 특징을 설명하세요.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          // rgba 60 60 67, 0.6
                          color: Color(0x993C3C43),
                          letterSpacing: -0.4,
                          height: 1.3,
                        ),
                      ),
                      Text(
                        "예시: 여행 앱을 1~2가지 이상 사용해본 테스터",
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
              const Spacer(),
              // 저장 버튼. 텍스트 필드가 비어있으면 비활성화. full width except 16 horizontal padding
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _nameController.text.isEmpty
                        ? Color(disabledBackgroundColor)
                        : Color(primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  onPressed: _nameController.text.isEmpty
                      ? null
                      : () async {
                          widget.utClientModel.targetUserDescription =
                              _nameController.text;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MakerUTPreviewScreen(
                                utClientModel: widget.utClientModel,
                              ),
                            ),
                          );
                        },
                  child: Text(
                    "다음",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: _nameController.text.isEmpty
                          ? Color(disabledTextColor)
                          : Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
