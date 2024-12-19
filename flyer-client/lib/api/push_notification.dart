import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/global_navigation_key.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final fToast = FToast();

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<String> getToken() async {
    try {
      return await _firebaseMessaging.getToken() ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<void> showNotification(RemoteMessage message) {
    fToast.init(GlobalNavigationKey.naviagatorState.currentContext!);
    HapticFeedback.mediumImpact();
    // show notification using global key. must use safe area
    Widget toast = SafeArea(
      child: GestureDetector(
        onTap: () {
          // TODO: navigate to the screen
        },
        child: InkWell(
          child: Card(
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                        GlobalNavigationKey.naviagatorState.currentContext!)
                    .colorScheme
                    .background
                    .withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("🔔 "),
                      Text(
                        message.notification?.title ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: child,
        );
      },
    );

    return Future.value();
  }
}
