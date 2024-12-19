import 'package:flutter/material.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/util/colors.dart';

class MakerUTTesterStatusScreen extends StatefulWidget {
  const MakerUTTesterStatusScreen({
    super.key,
    required this.ut,
  });

  final UT ut;

  @override
  State<MakerUTTesterStatusScreen> createState() =>
      _MakerUTTesterStatusScreenState();
}

class _MakerUTTesterStatusScreenState extends State<MakerUTTesterStatusScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        scrolledUnderElevation: 0,
        title: Text(
          "${widget.ut.appAssetName} 테스터 현황",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // row with activeTester count , finishedTester count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                // rgb 0 122 255
                                color: const Color(0xFF007AFF),
                              ),
                              // rgb 0 122 255
                              child: Image.asset(
                                "assets/images/face_satisfied.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${widget.ut.activeTesterCount}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "참여 중",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(outlinedColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                // rgb 52 199 89
                                color: const Color(0xFF34C759),
                              ),
                              // rgb 0 122 255
                              child: Image.asset(
                                "assets/images/face_cool.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${widget.ut.finishedTesterCount}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "참여 완료",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(outlinedColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // row with resignedTester count , timeEndedTester count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                // rgb 255 149 0
                                color: const Color(0xFFFF9500),
                              ),
                              // rgb 0 122 255
                              child: Image.asset(
                                "assets/images/face_pending.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${widget.ut.resignedTesterCount}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "참여 포기",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(outlinedColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                // rgb 255 45 85
                                color: const Color(0xFFFF2D55),
                              ),
                              // rgb 0 122 255
                              child: Image.asset(
                                "assets/images/face_dizzy.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${widget.ut.timeEndedTesterCount}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "기간 초과",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(outlinedColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
