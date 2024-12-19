import 'package:flyer_client/models/app_asset.dart';

class UtClientModel {
  AppAsset? appAsset;
  String? targetUserDescription;
  List<String>? surveyQuestions;
  int testerCount;

  UtClientModel({
    this.appAsset,
    this.targetUserDescription,
    this.surveyQuestions,
    required this.testerCount,
  });
}
