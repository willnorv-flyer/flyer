import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/screens/entry_screen.dart';
import 'package:flyer_client/util/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.email,
    required this.authProvider,
    required this.nickname,
  });

  final String email;
  final String authProvider;
  final String nickname;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  String gener = "선택안함";
  int birth = 19990101;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(mildBackgroundColor),
      appBar: AppBar(
        backgroundColor: Color(mildBackgroundColor),
        title: const Text(
          "회원가입",
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
              if (gener == "남성") {
                convertedGender = "MALE";
              } else if (gener == "여성") {
                convertedGender = "FEMALE";
              } else {
                convertedGender = "UNSPECIFIED";
              }
              Response signupResponse = await signup(
                  widget.email,
                  _nicknameController.text,
                  convertedGender,
                  birth,
                  _jobController.text);
              if (!context.mounted) {
                return;
              }
              if (signupResponse is Success) {
                var res = (signupResponse).data as SignUpResponse;
                Fluttertoast.showToast(msg: "${res.nickname}님, 환영해요!");
                // 캐시에 토큰 저장 & 메인 화면으로 이동
                await setLoginInfo(res.loginToken);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) {
                      return const EntryScreen(
                        requestPushNotiPermission: true,
                      );
                    },
                  ),
                  (route) => false,
                );
              } else if (signupResponse is Error) {
                // 에러 메시지 표시
                Fluttertoast.showToast(msg: signupResponse.message);
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
                          widget.email,
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
                        value: gener,
                        icon: Image.asset(
                          "assets/images/chevron_sort.png",
                          width: 16,
                          height: 16,
                          fit: BoxFit.cover,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            gener = newValue!;
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
                                  birth = value.year * 10000 +
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
                              "${birth ~/ 10000}.${birth % 10000 ~/ 100}.${birth % 100}",
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
            const SizedBox(height: 24),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8),
            //   child: Text("추가정보",
            //       style: TextStyle(
            //           fontSize: 13,
            //           color: Theme.of(context).colorScheme.outline)),
            // ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Text("자주 쓰는 앱",
            //               style: TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w500,
            //                   color:
            //                       Theme.of(context).colorScheme.onBackground)),
            //         ],
            //       ),
            //       const Divider(),
            //       Row(
            //         children: [
            //           Text("자주 쓰는 앱 추가...",
            //               style: TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w500,
            //                   color: Theme.of(context).colorScheme.outline)),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Text("관심분야",
            //               style: TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w500,
            //                   color:
            //                       Theme.of(context).colorScheme.onBackground)),
            //         ],
            //       ),
            //       const Divider(),
            //       Row(
            //         children: [
            //           Text("관심분야 추가...",
            //               style: TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w500,
            //                   color: Theme.of(context).colorScheme.outline)),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
