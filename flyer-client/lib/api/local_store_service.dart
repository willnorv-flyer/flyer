import 'package:shared_preferences/shared_preferences.dart';

const String _loginTokenKey = "LOGIN_TOKEN";
const String _userModeKey = "USER_MODE";
const String _testerTutorialKey = "TESTER_TUTORIAL";
const String _makerTutorialKey = "MAKER_TUTORIAL";

Future<void> setLoginInfo(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(_loginTokenKey, token);
}

Future<String> getLoginInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(_loginTokenKey) ?? "";
  return token;
}

Future<void> setUserMode(String userMode) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(_userModeKey, userMode);
}

Future<String> getUserMode() async {
  final prefs = await SharedPreferences.getInstance();
  final userMode = prefs.getString(_userModeKey) ?? "TESTER";
  return userMode;
}

Future<void> setMakerTutorial(bool isTutorial) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(_makerTutorialKey, isTutorial);
}

Future<bool> getMakerTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final isTutorial = prefs.getBool(_makerTutorialKey) ?? true;
  return isTutorial;
}

Future<void> setTesterTutorial(bool isTutorial) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(_testerTutorialKey, isTutorial);
}

Future<bool> getTesterTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final isTutorial = prefs.getBool(_testerTutorialKey) ?? true;
  return isTutorial;
}
