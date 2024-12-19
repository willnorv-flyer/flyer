import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/models/user.dart';
import 'package:flyer_client/screens/entry_screen.dart';
import 'package:flyer_client/util/colors.dart';

class TesterUpdateMyProfileScreen extends StatefulWidget {
  const TesterUpdateMyProfileScreen({
    super.key,
    required this.user,
  });

  final UserV1 user;

  @override
  State<TesterUpdateMyProfileScreen> createState() =>
      _TesterUpdateMyProfileScreenState();
}

class _TesterUpdateMyProfileScreenState
    extends State<TesterUpdateMyProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  String gender = "선택안함";
  int birthday = 19990101;

  @override
  void initState() {
    super.initState();
    setState(() {
      _nicknameController.text = widget.user.nickname;
      _jobController.text = widget.user.job;
      if (widget.user.gender == "MALE") {
        gender = "남성";
      } else if (widget.user.gender == "FEMALE") {
        gender = "여성";
      } else {
        gender = "선택안함";
      }
      birthday = widget.user.birthday;
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
              if (_nicknameController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: "닉네임을 입력해주세요");
                return;
              }

              if (_jobController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: "직업을 입력해주세요");
                return;
              }

              // 회원가입 요청
              String convertedGender = "";
              if (gender == "남성") {
                convertedGender = "MALE";
              } else if (gender == "여성") {
                convertedGender = "FEMALE";
              } else {
                convertedGender = "UNSPECIFIED";
              }
              Response editMyInfoResponse = await editMyInfo(
                  _nicknameController.text,
                  convertedGender,
                  birthday,
                  _jobController.text);
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
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "닉네임",
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
                            hintText: "닉네임을 입력해주세요",
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
                  // 왼쪽에는 성별, 오른쪽에는 셀렉트박스
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text("성별",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                      // Text로 표시하고, 클릭하면 드롭다운 셀렉트박스 표시
                      DropdownButton<String>(
                        value: gender,
                        icon: Image.asset(
                          "assets/images/chevron_sort.png",
                          width: 16,
                          height: 16,
                          fit: BoxFit.cover,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        isDense: true,
                        underline: Container(),
                        items: <String>["선택안함", "남성", "여성"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.3),
                  // 왼쪽에는 출생연도, 오른쪽에는 yyyy.MM.dd. 클릭하면 캘린더 표시
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text("출생연도",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                      // Text로 표시하고, 클릭하면 캘린더 표시
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then(
                            (value) => {
                              if (value != null)
                                {
                                  birthday = value.year * 10000 +
                                      value.month * 100 +
                                      value.day,
                                  setState(() {})
                                },
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "${birthday ~/ 10000}.${birthday % 10000 ~/ 100}.${birthday % 100}",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(width: 4),
                            // chevron_sort
                            Image.asset(
                              "assets/images/chevron_sort.png",
                              width: 16,
                              height: 16,
                              fit: BoxFit.cover,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ],
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
                          "직업",
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
                            hintText: "직업을 입력해주세요",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _jobController,
                        ),
                      ),
                    ],
                  ),
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
