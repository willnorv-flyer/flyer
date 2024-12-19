import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/models/user.dart';
import 'package:flyer_client/screens/entry_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerUpdateMyProfileScreen extends StatefulWidget {
  const MakerUpdateMyProfileScreen({
    super.key,
    required this.user,
  });

  final UserV1 user;

  @override
  State<MakerUpdateMyProfileScreen> createState() =>
      _MakerUpdateMyProfileScreenState();
}

class _MakerUpdateMyProfileScreenState
    extends State<MakerUpdateMyProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _corporateEmailController =
      TextEditingController();
  final TextEditingController _websiteUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nicknameController.text = widget.user.nickname;
      _phoneNumberController.text = widget.user.phoneNumber;
      _corporateEmailController.text = widget.user.corporateEmail;
      _websiteUrlController.text = widget.user.websiteUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(mildBackgroundColor),
      appBar: AppBar(
        backgroundColor: Color(mildBackgroundColor),
        title: const Text(
          "정보 수정",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (widget.user.userType == "INDIVIDUAL_MAKER") {
                if (_nicknameController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "개발자 이름을 입력해주세요");
                  return;
                }
              }

              if (widget.user.userType == "CORPORATE_MAKER") {
                if (_nicknameController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "기업명을 입력해주세요");
                  return;
                }

                if (_corporateEmailController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "기업 이메일을 입력해주세요");
                  return;
                }

                if (_websiteUrlController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "웹사이트 주소를 입력해주세요");
                  return;
                }
              }

              if (_phoneNumberController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: "전화번호를 입력해주세요");
                return;
              }

              Response editMyInfoResponse = await updateMyUserType(
                  widget.user.userType,
                  _nicknameController.text,
                  _phoneNumberController.text,
                  _corporateEmailController.text,
                  _websiteUrlController.text);
              if (!context.mounted) {
                return;
              }
              if (editMyInfoResponse is Success) {
                Navigator.of(context).pop();
              } else if (editMyInfoResponse is Error) {
                // 에러 메시지 표시
                Fluttertoast.showToast(msg: editMyInfoResponse.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("저장",
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text("기본정보",
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.outline)),
            ),
            // 이메일, 성별, 출생연도, 직업
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // 왼쪽에는 이메일, 오른쪽에는 인풋박스
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text("이메일",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
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
                      SizedBox(
                        width: 100,
                        child: Text(
                          widget.user.userType == "INDIVIDUAL_MAKER"
                              ? "개발자 이름"
                              : "기업명",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                                "${widget.user.userType == "INDIVIDUAL_MAKER" ? "개발자 이름" : "기업명"}을 입력해주세요",
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
                  widget.user.userType == "CORPORATE_MAKER"
                      ? Column(
                          children: [
                            const Divider(thickness: 0.3),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    "기업 이메일",
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
                                      hintText: "기업 이메일을 입력해주세요",
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    controller: _corporateEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  const Divider(thickness: 0.3),
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
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  widget.user.userType == "CORPORATE_MAKER"
                      ? Column(
                          children: [
                            const Divider(thickness: 0.3),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    "웹 사이트",
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
                                      hintText: "웹 사이트를 입력해주세요",
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    controller: _websiteUrlController,
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 회원탈퇴 버튼
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
                            "회원탈퇴",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "진행중인 UT가 있으면 탈퇴할 수 없습니다.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "회원탈퇴하시겠습니까?",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Divider(thickness: 0.3),
                          // 네, 포기합니다.
                          GestureDetector(
                            onTap: () async {
                              Response result = await deleteUser();
                              if (!mounted) {
                                return;
                              }
                              if (result is Success) {
                                Fluttertoast.showToast(msg: "회원탈퇴했습니다.");
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "회원탈퇴하지 못했습니다. 진행중인 UT가 없을 경우 문의해주세요.");
                                return;
                              }
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              setLoginInfo("");
                              setUserMode("TESTER");
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 5),
                                child: Text(
                                  "네 탈퇴합니다.",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(errorColor),
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
              child: InkWell(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "회원탈퇴",
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
    );
  }
}
