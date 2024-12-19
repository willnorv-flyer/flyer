import 'package:flutter/material.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/api/push_notification.dart';
import 'package:flyer_client/screens/maker_tab_screen.dart';
import 'package:flyer_client/screens/sign_in_screen.dart';
import 'package:flyer_client/screens/tester_tab_screen.dart';
import 'package:flyer_client/util/colors.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.requestPushNotiPermission});

  final bool requestPushNotiPermission;

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  // init
  @override
  void initState() {
    super.initState();
    if (widget.requestPushNotiPermission) {
      // request push notification permission
      PushNotifications.init().then(
        (value) {
          Future.delayed(const Duration(seconds: 3), () async {
            String token = await PushNotifications.getToken();
            updateMyPushToken(token);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getLoginInfo().then(
      (value) async {
        if (value.isEmpty) {
          // fade transition to sign in screen
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SignInScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        } else {
          getUserMode().then(
            (value) async {
              if (value == "TESTER") {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const TesterTabScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const MakerTabScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              }
            },
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Color(primaryBackgroundColor),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '사용자 설정을 가져오고 있습니다',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
