import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/screens/entry_screen.dart';
import 'package:flyer_client/screens/sign_up_screen.dart';
import 'package:flyer_client/util/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // google sign in
  Future<void> googleSignIn(context) async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      e;
    }
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount == null) {
      return;
    }
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    if (googleSignInAuthentication.accessToken == null) {
      Fluttertoast.showToast(msg: "로그인에 실패했습니다. 구글 계정을 확인해주세요");
      return;
    }
    Response signInResponse =
        await signin(googleSignInAuthentication.accessToken!, "GOOGLE");
    if (!context.mounted) {
      return;
    }
    if (signInResponse is Success) {
      var res = (signInResponse).data as SignInResponse;
      if (res.isNewUser) {
        Fluttertoast.showToast(msg: "${res.email}님의 회원가입을 진행합니다.");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              email: res.email,
              authProvider: "GOOGLE",
              nickname: googleSignInAccount.displayName ?? "",
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "${res.nickname}님, 반가워요!");
        // 캐시에 토큰 저장 & 메인 화면으로 이동
        await setLoginInfo(res.loginToken);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const EntryScreen(requestPushNotiPermission: true),
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
    } else if (signInResponse is Error) {
      Fluttertoast.showToast(msg: signInResponse.message);
    }
  }

  // apple sign in
  Future<void> appleSignIn(context) async {
    // if platform is google, show snackbar android에서는 이용할 수 없습니다. and then return
    if (Theme.of(context).platform == TargetPlatform.android) {
      Fluttertoast.showToast(msg: "안드로이드에서는 이용할 수 없습니다.");
      return;
    }
    final auth = FirebaseAuth.instance;

    try {
      auth.signOut();
    } catch (e) {
      e;
    }

    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await auth.signInWithCredential(oauthCredential);

      // if email is null -> error
      if (userCredential.additionalUserInfo?.profile?["email"] == null ||
          appleCredential.identityToken == null) {
        Fluttertoast.showToast(msg: "로그인에 실패했습니다. 고객센터에 문의해주세요");
        return;
      }

      Response signInResponse =
          await signin(appleCredential.identityToken!, "APPLE");

      if (!context.mounted) {
        return;
      }
      if (signInResponse is Success) {
        var res = (signInResponse).data as SignInResponse;
        if (res.isNewUser) {
          Fluttertoast.showToast(
              msg: "${userCredential.user!.email}님의 회원가입을 진행합니다.");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return SignUpScreen(
                  email: res.email,
                  authProvider: "APPLE",
                  nickname: "",
                );
              },
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "${res.nickname}님, 반가워요!");
          // 캐시에 토큰 저장 & 메인 화면으로 이동
          setLoginInfo(res.loginToken);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const EntryScreen(requestPushNotiPermission: true);
              },
            ),
          );
        }
      } else if (signInResponse is Error) {
        Fluttertoast.showToast(msg: signInResponse.message);
      }
    } catch (e) {
      e;
    }
  }

  // sha256
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    "assets/images/intro_logo.png",
                    width: 118,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "쉽게 시작하는",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const Text(
                  "UT 리크루팅",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    "assets/images/intro_image.png",
                    width: 375,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // 구글로 시작하기 && 애플로 시작하기
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    backgroundColor: const Color(0xFF767680).withOpacity(0.12),
                  ),
                  onPressed: () {
                    googleSignIn(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            "assets/images/google_logo.png",
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        'Google로 계속하기',
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.onBackground,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Platform.isAndroid
                    ? const SizedBox()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          appleSignIn(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  "assets/images/apple_logo.png",
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              'Apple로 계속하기',
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.background,
                                letterSpacing: -0.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
