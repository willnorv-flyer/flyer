import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/models/user.dart';
import 'package:flyer_client/screens/entry_screen.dart';
import 'package:flyer_client/util/colors.dart';

class RegisterIndividualMakerScreen extends StatefulWidget {
  const RegisterIndividualMakerScreen({
    super.key,
    required this.user,
  });

  final UserV1 user;

  @override
  State<RegisterIndividualMakerScreen> createState() =>
      _RegisterIndividualMakerScreenState();
}

class _RegisterIndividualMakerScreenState
    extends State<RegisterIndividualMakerScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.user.nickname;
    _phoneNumberController.text = widget.user.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(mildBackgroundColor),
      appBar: AppBar(
        backgroundColor: Color(mildBackgroundColor),
        title: const Text(
          "개인 메이커",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (_nicknameController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: "개발자 이름을 입력해주세요");
                return;
              }

              if (_phoneNumberController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: "전화번호를 입력해주세요");
                return;
              }

              Response updateMyUserTypeResponse = await updateMyUserType(
                "INDIVIDUAL_MAKER",
                _nicknameController.text,
                _phoneNumberController.text,
                widget.user.corporateEmail,
                widget.user.websiteUrl,
              );
              if (!context.mounted) {
                return;
              }
              if (updateMyUserTypeResponse is Success) {
                Fluttertoast.showToast(msg: "개인 메이커로 등록되었습니다");
                setUserMode('MAKER');
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const EntryScreen(
                      requestPushNotiPermission: false,
                    ),
                  ),
                );
              } else if (updateMyUserTypeResponse is Error) {
                Fluttertoast.showToast(msg: updateMyUserTypeResponse.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("완료",
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text("기본 정보",
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.outline)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "이메일",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.user.email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.3),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "개발자 이름",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "개발자 이름을 입력해주세요",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _nicknameController,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.3),
                  // 왼쪽에는 직업, 오른쪽에는 인풋박스
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "전화번호",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "전화번호를 입력해주세요",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _phoneNumberController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
