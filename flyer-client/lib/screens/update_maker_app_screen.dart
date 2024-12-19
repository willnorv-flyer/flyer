import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/models/app_asset.dart';
import 'package:flyer_client/util/colors.dart';

class UpdateMakerAppScreen extends StatefulWidget {
  UpdateMakerAppScreen({super.key, required this.appAsset});

  AppAsset appAsset;

  @override
  State<UpdateMakerAppScreen> createState() => _UpdateMakerAppScreenState();
}

class _UpdateMakerAppScreenState extends State<UpdateMakerAppScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _name = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.appAsset.shortDescription;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "취소",
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text(
                    "문구 수정",
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                        )),
                  ),
                ],
              ),
            ),
            // search bar
            const Spacer(),
            const Text(
              "앱을 소개하는 짧은 문구",
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
                              hintText: "공백포함 40자",
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
                                _name = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_nameController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _nameController.clear();
                                  _name = "";
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
                        Response updateAppAssetResponse = await updateAppAsset(
                            widget.appAsset.id, _nameController.text);
                        if (!context.mounted) {
                          return;
                        }
                        if (updateAppAssetResponse is Success) {
                          Fluttertoast.showToast(msg: "앱 소개 문구를 수정했습니다.");
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(msg: "앱 소개 문구 수정에 실패했습니다.");
                        }
                      },
                child: Text(
                  "저장",
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
    );
  }
}
