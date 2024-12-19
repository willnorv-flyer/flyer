import 'dart:convert';

import 'package:flyer_client/api/local_store_service.dart';
import 'package:flyer_client/models/app_asset.dart';
import 'package:flyer_client/models/survey_form.dart';
import 'package:flyer_client/models/user.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:http/http.dart' as http;

class Response {}

class Success extends Response {
  final Object? data;

  Success({this.data});
}

class Error extends Response {
  final String message;

  Error({required this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json["error"] ?? "잠시 후 다시 시도해주세요");
  }
}

const String _baseUrl = "비이밀";

class SignInResponse extends Response {
  final String email;
  final String nickname;
  final bool isNewUser;
  final String loginToken;

  SignInResponse({
    required this.email,
    required this.nickname,
    required this.isNewUser,
    required this.loginToken,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      email: json["email"],
      nickname: json["nickname"],
      isNewUser: json["isNewUser"],
      loginToken: json["loginToken"],
    );
  }
}

Future<Response> signin(String accessToken, String authProvider) async {
  const String signinV1 = "/api/v1/signin";
  try {
    final response = await http.post(
      Uri.parse(_baseUrl + signinV1),
      body: jsonEncode({
        "accessToken": accessToken,
        "authProvider": authProvider,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success(
        data: SignInResponse.fromJson(jsonDecode(response.body)["data"]));
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class SignUpResponse extends Response {
  final String nickname;
  final String loginToken;

  SignUpResponse({
    required this.nickname,
    required this.loginToken,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      nickname: json["nickname"],
      loginToken: json["loginToken"],
    );
  }
}

Future<Response> signup(String email, String nickname, String gender,
    int birthday, String job) async {
  const String signinV1 = "/api/v1/signup";
  try {
    final response = await http.post(
      Uri.parse(_baseUrl + signinV1),
      body: jsonEncode({
        "email": email,
        "nickname": nickname,
        "gender": gender,
        "birthday": birthday,
        "job": job,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success(
        data: SignUpResponse.fromJson(jsonDecode(response.body)["data"]));
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class MyInfoResponse extends Response {
  final UserV1 user;

  MyInfoResponse({required this.user});

  factory MyInfoResponse.fromJson(Map<String, dynamic> json) {
    return MyInfoResponse(user: UserV1.fromJson(json["user"]));
  }
}

Future<Response> queryMyInfo() async {
  String token = await getLoginInfo();
  const String myInfoV1 = "/api/v1/me";
  try {
    final response = await http.get(
      Uri.parse(_baseUrl + myInfoV1),
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success(
        data: MyInfoResponse.fromJson(jsonDecode(response.body)["data"]));
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

Future<Response> editMyInfo(
    String nickname, String gender, int birthday, String job) async {
  String token = await getLoginInfo();
  const String myInfoV1 = "/api/v1/me/profile";
  try {
    final response = await http.patch(
      Uri.parse(_baseUrl + myInfoV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "nickname": nickname,
        "gender": gender,
        "birthday": birthday,
        "job": job,
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success(
        data: MyInfoResponse.fromJson(jsonDecode(response.body)["data"]));
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

Future<Response> updateMyUserType(String userType, String nickname,
    String phoneNumber, String corporateEmail, String websiteUrl) async {
  String token = await getLoginInfo();
  const String myInfoV1 = "/api/v1/me/type";
  try {
    final response = await http.patch(
      Uri.parse(_baseUrl + myInfoV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "userType": userType,
        "nickname": nickname,
        "phoneNumber": phoneNumber,
        "corporateEmail": corporateEmail,
        "websiteUrl": websiteUrl,
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success(
        data: MyInfoResponse.fromJson(jsonDecode(response.body)["data"]));
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class SearchAppstoreAppsResponse {
  final int resultCount;
  final List<AppstoreApp> results;

  SearchAppstoreAppsResponse(
      {required this.resultCount, required this.results});

  factory SearchAppstoreAppsResponse.fromJson(Map<String, dynamic> json) {
    List<AppstoreApp> results = [];
    for (var result in json["results"]) {
      results.add(AppstoreApp.fromJson(result));
    }
    return SearchAppstoreAppsResponse(
      resultCount: json["resultCount"],
      results: results,
    );
  }
}

class AppstoreApp {
  final String artworkUrl512;
  final int trackId;
  final String trackName;
  final List<String> genres;

  AppstoreApp({
    required this.artworkUrl512,
    required this.trackId,
    required this.trackName,
    required this.genres,
  });

  factory AppstoreApp.fromJson(Map<String, dynamic> json) {
    return AppstoreApp(
      artworkUrl512: json["artworkUrl512"],
      trackId: json["trackId"],
      trackName: json["trackName"],
      genres: List.from(json["genres"]),
    );
  }
}

Future<SearchAppstoreAppsResponse> searchAppstoreApps(
    String queryString) async {
  String url =
      "https://itunes.apple.com/search?term=$queryString&country=kr&media=software&entity=software&lang=ko_KR&version=2";
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return SearchAppstoreAppsResponse(resultCount: 0, results: []);
    }
    return SearchAppstoreAppsResponse.fromJson(jsonDecode(response.body));
  } catch (e) {
    return SearchAppstoreAppsResponse(resultCount: 0, results: []);
  }
}

// Future<String> queryAppstoreAppDetail(String appId) async {
//   String url = "https://itunes.apple.com/lookup?id=$appId&country=kr";
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode != 200) {
//       return "";
//     }
//     return jsonDecode(response.body)["results"][0]["description"];
//   } catch (e) {
//     return "";
//   }
// }

class SearchGooglePlayAppsResponse {
  final List<PlaystoreApp> results;

  SearchGooglePlayAppsResponse({required this.results});

  factory SearchGooglePlayAppsResponse.fromJson(Map<String, dynamic> json) {
    List<PlaystoreApp> results = [];
    for (var result in json["results"]) {
      results.add(PlaystoreApp.fromJson(result));
    }
    return SearchGooglePlayAppsResponse(
      results: results,
    );
  }
}

class PlaystoreApp {
  final String title;
  final String appId;
  final String icon;

  PlaystoreApp({
    required this.title,
    required this.appId,
    required this.icon,
  });

  factory PlaystoreApp.fromJson(Map<String, dynamic> json) {
    return PlaystoreApp(
      title: json["title"],
      appId: json["appId"],
      icon: json["icon"],
    );
  }
}

Future<SearchGooglePlayAppsResponse> searchGooglePlayApps(
    String queryString) async {
  String url =
      "https://97wjh1425d.execute-api.ap-northeast-2.amazonaws.com/api/apps/?q=$queryString&lang=ko&country=kr";
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return SearchGooglePlayAppsResponse(results: []);
    }
    return SearchGooglePlayAppsResponse.fromJson(jsonDecode(response.body));
  } catch (e) {
    return SearchGooglePlayAppsResponse(results: []);
  }
}

class PlaystoreAppDetail extends Response {
  final String summary;
  final String genre;
  final String description;
  final List<String> screenshots;
  final String developerId;
  final String developerEmail;

  PlaystoreAppDetail({
    required this.genre,
    required this.summary,
    required this.description,
    required this.screenshots,
    required this.developerId,
    required this.developerEmail,
  });

  factory PlaystoreAppDetail.fromJson(Map<String, dynamic> json) {
    return PlaystoreAppDetail(
      genre: json["genre"],
      summary: json["summary"],
      description: json["description"],
      screenshots: List.from(json["screenshots"]),
      developerId: json["developerId"],
      developerEmail: json["developerEmail"],
    );
  }
}

Future<Response> scrapeGooglePlayAppDetail(String appId) async {
  String url =
      "https://97wjh1425d.execute-api.ap-northeast-2.amazonaws.com/api/apps/$appId?lang=ko&country=kr";
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return Error(message: "잠시 후 다시 시도해주세요");
    }
    return Success(
        data: PlaystoreAppDetail.fromJson(jsonDecode(response.body)));
  } catch (e) {
    return Error(message: "알수 없는 오류가 발생했습니다. 지속될 경우 문의해주세요.");
  }
}

class AppstoreAppDetail extends Response {
  final List<String> screenshotUrls;
  final String description;
  final String sellerName;

  AppstoreAppDetail({
    required this.screenshotUrls,
    required this.description,
    required this.sellerName,
  });

  factory AppstoreAppDetail.fromJson(Map<String, dynamic> json) {
    return AppstoreAppDetail(
      screenshotUrls: List.from(json["screenshotUrls"]),
      description: json["description"],
      sellerName: json["sellerName"],
    );
  }
}

Future<Response> scrapeAppStoreAppDetail(String appId) async {
  String url = "https://itunes.apple.com/lookup?id=$appId&country=kr";
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return Error(message: "잠시 후 다시 시도해주세요");
    }
    return Success(
        data: AppstoreAppDetail.fromJson(
            jsonDecode(response.body)["results"][0]));
  } catch (e) {
    return Error(message: "알수 없는 오류가 발생했습니다. 지속될 경우 문의해주세요.");
  }
}

Future<Response> createAppAsset(
  String appId,
  String name,
  String shortDescription,
  String iconUrl,
  String platform,
  String category,
) async {
  String token = await getLoginInfo();
  String createAppAssetV1 = "/api/v1/appassets";

  try {
    final response = await http.post(
      Uri.parse(_baseUrl + createAppAssetV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "appId": appId,
        "name": name,
        "shortDescription": shortDescription,
        "iconUrl": iconUrl,
        "platform": platform,
        "category": category,
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class QueryAppAssetResponse {
  final List<AppAsset> appAssets;

  QueryAppAssetResponse({required this.appAssets});

  factory QueryAppAssetResponse.fromJson(Map<String, dynamic> json) {
    return QueryAppAssetResponse(
        appAssets: (json["appAssets"] as List<dynamic>)
            .map((e) => AppAsset.fromJson(e))
            .toList());
  }
}

Future<Response> queryAppAssets() async {
  String token = await getLoginInfo();
  String queryAppAssetV1 = "/api/v1/appassets";
  final response = await http.get(
    Uri.parse(_baseUrl + queryAppAssetV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success(
      data: QueryAppAssetResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))["data"],
      ),
    );
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> updateAppAsset(int appAssetId, String name) async {
  String token = await getLoginInfo();
  String deleteAppAssetV1 = "/api/v1/appassets/$appAssetId";
  final response = await http.patch(
    Uri.parse(_baseUrl + deleteAppAssetV1),
    body: jsonEncode({
      "shortDescription": name,
    }),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success();
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> deleteAppAsset(int appAssetId) async {
  String token = await getLoginInfo();
  String deleteAppAssetV1 = "/api/v1/appassets/$appAssetId";
  final response = await http.delete(
    Uri.parse(_baseUrl + deleteAppAssetV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success();
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> createSurveyForm(
    String name,
    String question1,
    String question2,
    String question3,
    String question4,
    String question5,
    String question6,
    String question7,
    String question8,
    String question9,
    String question10,
    String question11,
    String question12,
    String question13,
    String question14,
    String question15,
    String question16,
    String question17,
    String question18,
    String question19,
    String question20) async {
  String token = await getLoginInfo();
  String createSurveyFormV1 = "/api/v1/surveyforms";

  try {
    final response = await http.post(
      Uri.parse(_baseUrl + createSurveyFormV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "name": name,
        "question1": question1,
        "question2": question2,
        "question3": question3,
        "question4": question4,
        "question5": question5,
        "question6": question6,
        "question7": question7,
        "question8": question8,
        "question9": question9,
        "question10": question10,
        "question11": question11,
        "question12": question12,
        "question13": question13,
        "question14": question14,
        "question15": question15,
        "question16": question16,
        "question17": question17,
        "question18": question18,
        "question19": question19,
        "question20": question20,
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class QuerySurveyFormResponse {
  final List<SurveyForm> surveyForms;

  QuerySurveyFormResponse({required this.surveyForms});

  factory QuerySurveyFormResponse.fromJson(Map<String, dynamic> json) {
    return QuerySurveyFormResponse(
        surveyForms: (json["surveyForms"] as List<dynamic>)
            .map((e) => SurveyForm.fromJson(e))
            .toList());
  }
}

Future<Response> querySurveyForms() async {
  String token = await getLoginInfo();
  String querySurveyFormV1 = "/api/v1/surveyforms";
  final response = await http.get(
    Uri.parse(_baseUrl + querySurveyFormV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success(
      data: QuerySurveyFormResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))["data"],
      ),
    );
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> updateSurveyForm(
  int surveyFormId,
  String name,
  String question1,
  String question2,
  String question3,
  String question4,
  String question5,
  String question6,
  String question7,
  String question8,
  String question9,
  String question10,
  String question11,
  String question12,
  String question13,
  String question14,
  String question15,
  String question16,
  String question17,
  String question18,
  String question19,
  String question20,
) async {
  String token = await getLoginInfo();
  String deleteSurveyFormV1 = "/api/v1/surveyforms/$surveyFormId";
  final response = await http.patch(
    Uri.parse(_baseUrl + deleteSurveyFormV1),
    body: jsonEncode({
      "name": name,
      "question1": question1,
      "question2": question2,
      "question3": question3,
      "question4": question4,
      "question5": question5,
      "question6": question6,
      "question7": question7,
      "question8": question8,
      "question9": question9,
      "question10": question10,
      "question11": question11,
      "question12": question12,
      "question13": question13,
      "question14": question14,
      "question15": question15,
      "question16": question16,
      "question17": question17,
      "question18": question18,
      "question19": question19,
      "question20": question20,
    }),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success();
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> deleteSurveyForm(int surveyFormId) async {
  String token = await getLoginInfo();
  String deleteSurveyFormV1 = "/api/v1/surveyforms/$surveyFormId";
  final response = await http.delete(
    Uri.parse(_baseUrl + deleteSurveyFormV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success();
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

class QueryUTResponse extends Response {
  final List<UT> uts;

  QueryUTResponse({required this.uts});

  factory QueryUTResponse.fromJson(Map<String, dynamic> json) {
    return QueryUTResponse(
        uts:
            (json["uts"] as List<dynamic>).map((e) => UT.fromJson(e)).toList());
  }
}

class UT extends Response {
  final int id;
  final int userId;
  final String targetUserDescription;
  final int appAssetId;
  final String appAssetAppId;
  final String appAssetName;
  final String appAssetShortDescription;
  final String appAssetIconUrl;
  final String appAssetPlatform;
  final String appAssetCategory;
  final int desiredTesterCount;
  final int activeTesterCount;
  final int finishedTesterCount;
  final int resignedTesterCount;
  final int timeEndedTesterCount;
  final String status;
  final int costPerUt;
  final String question1;
  final String question2;
  final String question3;
  final String question4;
  final String question5;
  final String question6;
  final String question7;
  final String question8;
  final String question9;
  final String question10;
  final String question11;
  final String question12;
  final String question13;
  final String question14;
  final String question15;
  final String question16;
  final String question17;
  final String question18;
  final String question19;
  final String question20;

  UT({
    required this.id,
    required this.userId,
    required this.targetUserDescription,
    required this.appAssetId,
    required this.appAssetAppId,
    required this.appAssetName,
    required this.appAssetShortDescription,
    required this.appAssetIconUrl,
    required this.appAssetPlatform,
    required this.appAssetCategory,
    required this.desiredTesterCount,
    required this.activeTesterCount,
    required this.finishedTesterCount,
    required this.resignedTesterCount,
    required this.timeEndedTesterCount,
    required this.status,
    required this.costPerUt,
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
    required this.question5,
    required this.question6,
    required this.question7,
    required this.question8,
    required this.question9,
    required this.question10,
    required this.question11,
    required this.question12,
    required this.question13,
    required this.question14,
    required this.question15,
    required this.question16,
    required this.question17,
    required this.question18,
    required this.question19,
    required this.question20,
  });

  factory UT.fromJson(Map<String, dynamic> json) {
    return UT(
      id: json["id"],
      userId: json["userId"],
      targetUserDescription: json["targetUserDescription"],
      appAssetId: json["appAssetId"],
      appAssetAppId: json["appAssetAppId"],
      appAssetName: json["appAssetName"],
      appAssetShortDescription: json["appAssetShortDescription"],
      appAssetIconUrl: json["appAssetIconUrl"],
      appAssetPlatform: json["appAssetPlatform"],
      appAssetCategory: json["appAssetCategory"],
      desiredTesterCount: json["desiredTesterCount"],
      activeTesterCount: json["activeTesterCount"],
      finishedTesterCount: json["finishedTesterCount"],
      resignedTesterCount: json["resignedTesterCount"],
      timeEndedTesterCount: json["timeEndedTesterCount"],
      status: json["status"],
      costPerUt: json["costPerUt"],
      question1: json["question1"],
      question2: json["question2"],
      question3: json["question3"],
      question4: json["question4"],
      question5: json["question5"],
      question6: json["question6"],
      question7: json["question7"],
      question8: json["question8"],
      question9: json["question9"],
      question10: json["question10"],
      question11: json["question11"],
      question12: json["question12"],
      question13: json["question13"],
      question14: json["question14"],
      question15: json["question15"],
      question16: json["question16"],
      question17: json["question17"],
      question18: json["question18"],
      question19: json["question19"],
      question20: json["question20"],
    );
  }

  int questionCount() {
    int count = 0;
    if (question1.isNotEmpty) count++;
    if (question2.isNotEmpty) count++;
    if (question3.isNotEmpty) count++;
    if (question4.isNotEmpty) count++;
    if (question5.isNotEmpty) count++;
    if (question6.isNotEmpty) count++;
    if (question7.isNotEmpty) count++;
    if (question8.isNotEmpty) count++;
    if (question9.isNotEmpty) count++;
    if (question10.isNotEmpty) count++;
    if (question11.isNotEmpty) count++;
    if (question12.isNotEmpty) count++;
    if (question13.isNotEmpty) count++;
    if (question14.isNotEmpty) count++;
    if (question15.isNotEmpty) count++;
    if (question16.isNotEmpty) count++;
    if (question17.isNotEmpty) count++;
    if (question18.isNotEmpty) count++;
    if (question19.isNotEmpty) count++;
    if (question20.isNotEmpty) count++;
    return count;
  }
}

Future<Response> queryUTs() async {
  String token = await getLoginInfo();
  String queryUTV1 = "/api/v1/maker/uts";
  final response = await http.get(
    Uri.parse(_baseUrl + queryUTV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success(
      data: QueryUTResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))["data"],
      ),
    );
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> queryAvailableUTs() async {
  String token = await getLoginInfo();
  String queryUTV1 = "/api/v1/tester/uts/available";
  final response = await http.get(
    Uri.parse(_baseUrl + queryUTV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success(
      data: QueryUTResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))["data"],
      ),
    );
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> createUT(UtClientModel utClientModel) async {
  String token = await getLoginInfo();
  String createUtV1 = "/api/v1/maker/uts";

  try {
    final response = await http.post(
      Uri.parse(_baseUrl + createUtV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "appAssetId": utClientModel.appAsset!.id,
        "targetUserDescription": utClientModel.targetUserDescription,
        "desiredTesterCount": utClientModel.testerCount,
        "question1": utClientModel.surveyQuestions!.isNotEmpty
            ? (utClientModel.surveyQuestions?[0] ?? "")
            : "",
        "question2": utClientModel.surveyQuestions!.length > 1
            ? (utClientModel.surveyQuestions?[1] ?? "")
            : "",
        "question3": utClientModel.surveyQuestions!.length > 2
            ? (utClientModel.surveyQuestions?[2] ?? "")
            : "",
        "question4": utClientModel.surveyQuestions!.length > 3
            ? (utClientModel.surveyQuestions?[3] ?? "")
            : "",
        "question5": utClientModel.surveyQuestions!.length > 4
            ? (utClientModel.surveyQuestions?[4] ?? "")
            : "",
        "question6": utClientModel.surveyQuestions!.length > 5
            ? (utClientModel.surveyQuestions?[5] ?? "")
            : "",
        "question7": utClientModel.surveyQuestions!.length > 6
            ? (utClientModel.surveyQuestions?[6] ?? "")
            : "",
        "question8": utClientModel.surveyQuestions!.length > 7
            ? (utClientModel.surveyQuestions?[7] ?? "")
            : "",
        "question9": utClientModel.surveyQuestions!.length > 8
            ? (utClientModel.surveyQuestions?[8] ?? "")
            : "",
        "question10": utClientModel.surveyQuestions!.length > 9
            ? (utClientModel.surveyQuestions?[9] ?? "")
            : "",
        "question11": utClientModel.surveyQuestions!.length > 10
            ? (utClientModel.surveyQuestions?[10] ?? "")
            : "",
        "question12": utClientModel.surveyQuestions!.length > 11
            ? (utClientModel.surveyQuestions?[11] ?? "")
            : "",
        "question13": utClientModel.surveyQuestions!.length > 12
            ? (utClientModel.surveyQuestions?[12] ?? "")
            : "",
        "question14": utClientModel.surveyQuestions!.length > 13
            ? (utClientModel.surveyQuestions?[13] ?? "")
            : "",
        "question15": utClientModel.surveyQuestions!.length > 14
            ? (utClientModel.surveyQuestions?[14] ?? "")
            : "",
        "question16": utClientModel.surveyQuestions!.length > 15
            ? (utClientModel.surveyQuestions?[15] ?? "")
            : "",
        "question17": utClientModel.surveyQuestions!.length > 16
            ? (utClientModel.surveyQuestions?[16] ?? "")
            : "",
        "question18": utClientModel.surveyQuestions!.length > 17
            ? (utClientModel.surveyQuestions?[17] ?? "")
            : "",
        "question19": utClientModel.surveyQuestions!.length > 18
            ? (utClientModel.surveyQuestions?[18] ?? "")
            : "",
        "question20": utClientModel.surveyQuestions!.length > 19
            ? (utClientModel.surveyQuestions?[19] ?? "")
            : "",
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

Future<Response> updateMyPushToken(String pushToken) async {
  String token = await getLoginInfo();
  String updateMyPushTokenV1 = "/api/v1/me/push";

  try {
    final response = await http.patch(
      Uri.parse(_baseUrl + updateMyPushTokenV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "pushToken": pushToken,
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

Future<Response> createTesterUtCase(int utId) async {
  String token = await getLoginInfo();
  String createTesterUtCaseV1 = "/api/v1/tester/uts/$utId/utcases";

  try {
    final response = await http.post(
      Uri.parse(_baseUrl + createTesterUtCaseV1),
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class TesterUTCase {
  final int id;
  final int utId;
  final int testerId;
  final String testerName;
  final String status;
  final String question1;
  final String answer1;
  final String question2;
  final String answer2;
  final String question3;
  final String answer3;
  final String question4;
  final String answer4;
  final String question5;
  final String answer5;
  final String question6;
  final String answer6;
  final String question7;
  final String answer7;
  final String question8;
  final String answer8;
  final String question9;
  final String answer9;
  final String question10;
  final String answer10;
  final String question11;
  final String answer11;
  final String question12;
  final String answer12;
  final String question13;
  final String answer13;
  final String question14;
  final String answer14;
  final String question15;
  final String answer15;
  final String question16;
  final String answer16;
  final String question17;
  final String answer17;
  final String question18;
  final String answer18;
  final String question19;
  final String answer19;
  final String question20;
  final String answer20;
  final UT ut;
  final DateTime createdAt;
  final DateTime submittedAt;

  TesterUTCase({
    required this.id,
    required this.utId,
    required this.testerId,
    required this.testerName,
    required this.status,
    required this.question1,
    required this.answer1,
    required this.question2,
    required this.answer2,
    required this.question3,
    required this.answer3,
    required this.question4,
    required this.answer4,
    required this.question5,
    required this.answer5,
    required this.question6,
    required this.answer6,
    required this.question7,
    required this.answer7,
    required this.question8,
    required this.answer8,
    required this.question9,
    required this.answer9,
    required this.question10,
    required this.answer10,
    required this.question11,
    required this.answer11,
    required this.question12,
    required this.answer12,
    required this.question13,
    required this.answer13,
    required this.question14,
    required this.answer14,
    required this.question15,
    required this.answer15,
    required this.question16,
    required this.answer16,
    required this.question17,
    required this.answer17,
    required this.question18,
    required this.answer18,
    required this.question19,
    required this.answer19,
    required this.question20,
    required this.answer20,
    required this.ut,
    required this.createdAt,
    required this.submittedAt,
  });

  factory TesterUTCase.fromJson(Map<String, dynamic> json) {
    return TesterUTCase(
      id: json["id"],
      utId: json["utId"],
      testerId: json["testerId"],
      testerName: json["testerName"],
      status: json["status"],
      question1: json["question1"],
      answer1: json["answer1"],
      question2: json["question2"],
      answer2: json["answer2"],
      question3: json["question3"],
      answer3: json["answer3"],
      question4: json["question4"],
      answer4: json["answer4"],
      question5: json["question5"],
      answer5: json["answer5"],
      question6: json["question6"],
      answer6: json["answer6"],
      question7: json["question7"],
      answer7: json["answer7"],
      question8: json["question8"],
      answer8: json["answer8"],
      question9: json["question9"],
      answer9: json["answer9"],
      question10: json["question10"],
      answer10: json["answer10"],
      question11: json["question11"],
      answer11: json["answer11"],
      question12: json["question12"],
      answer12: json["answer12"],
      question13: json["question13"],
      answer13: json["answer13"],
      question14: json["question14"],
      answer14: json["answer14"],
      question15: json["question15"],
      answer15: json["answer15"],
      question16: json["question16"],
      answer16: json["answer16"],
      question17: json["question17"],
      answer17: json["answer17"],
      question18: json["question18"],
      answer18: json["answer18"],
      question19: json["question19"],
      answer19: json["answer19"],
      question20: json["question20"],
      answer20: json["answer20"],
      ut: UT.fromJson(json["ut"]),
      // unix timestamp to DateTime
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"] * 1000),
      submittedAt:
          DateTime.fromMillisecondsSinceEpoch(json["submittedAt"] * 1000),
    );
  }
}

class QueryTesterUTCaseResponse extends Response {
  final List<TesterUTCase> utCases;

  QueryTesterUTCaseResponse({required this.utCases});

  factory QueryTesterUTCaseResponse.fromJson(Map<String, dynamic> json) {
    return QueryTesterUTCaseResponse(
        utCases: (json["utCases"] as List<dynamic>)
            .map((e) => TesterUTCase.fromJson(e))
            .toList());
  }
}

Future<Response> queryTesterUTCases() async {
  String token = await getLoginInfo();
  String queryTesterUTCaseV1 = "/api/v1/tester/utcases";
  final response = await http.get(
    Uri.parse(_baseUrl + queryTesterUTCaseV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success(
      data: QueryTesterUTCaseResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))["data"],
      ),
    );
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> submitTesterUTCase(List<String> answers, int utCaseId) async {
  String token = await getLoginInfo();
  String submitTesterUTCaseV1 = "/api/v1/tester/utcases/$utCaseId/submit";

  try {
    final response = await http.patch(
      Uri.parse(_baseUrl + submitTesterUTCaseV1),
      headers: {
        "Authorization": token,
      },
      body: jsonEncode({
        "answer1": answers.isNotEmpty ? answers[0] : "",
        "answer2": answers.length > 1 ? answers[1] : "",
        "answer3": answers.length > 2 ? answers[2] : "",
        "answer4": answers.length > 3 ? answers[3] : "",
        "answer5": answers.length > 4 ? answers[4] : "",
        "answer6": answers.length > 5 ? answers[5] : "",
        "answer7": answers.length > 6 ? answers[6] : "",
        "answer8": answers.length > 7 ? answers[7] : "",
        "answer9": answers.length > 8 ? answers[8] : "",
        "answer10": answers.length > 9 ? answers[9] : "",
        "answer11": answers.length > 10 ? answers[10] : "",
        "answer12": answers.length > 11 ? answers[11] : "",
        "answer13": answers.length > 12 ? answers[12] : "",
        "answer14": answers.length > 13 ? answers[13] : "",
        "answer15": answers.length > 14 ? answers[14] : "",
        "answer16": answers.length > 15 ? answers[15] : "",
        "answer17": answers.length > 16 ? answers[16] : "",
        "answer18": answers.length > 17 ? answers[17] : "",
        "answer19": answers.length > 18 ? answers[18] : "",
        "answer20": answers.length > 19 ? answers[19] : "",
      }),
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

Future<Response> resignTesterUTCase(int utCaseId) async {
  String token = await getLoginInfo();
  String resignTesterUTCaseV1 = "/api/v1/tester/utcases/$utCaseId/resign";

  try {
    final response = await http.patch(
      Uri.parse(_baseUrl + resignTesterUTCaseV1),
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}

class MakerUTCase {
  final int id;
  final int utId;
  final String testerName;
  final String status;
  final String question1;
  final String answer1;
  final String question2;
  final String answer2;
  final String question3;
  final String answer3;
  final String question4;
  final String answer4;
  final String question5;
  final String answer5;
  final String question6;
  final String answer6;
  final String question7;
  final String answer7;
  final String question8;
  final String answer8;
  final String question9;
  final String answer9;
  final String question10;
  final String answer10;
  final String question11;
  final String answer11;
  final String question12;
  final String answer12;
  final String question13;
  final String answer13;
  final String question14;
  final String answer14;
  final String question15;
  final String answer15;
  final String question16;
  final String answer16;
  final String question17;
  final String answer17;
  final String question18;
  final String answer18;
  final String question19;
  final String answer19;
  final String question20;
  final String answer20;
  final DateTime submittedAt;

  MakerUTCase({
    required this.id,
    required this.utId,
    required this.testerName,
    required this.status,
    required this.question1,
    required this.answer1,
    required this.question2,
    required this.answer2,
    required this.question3,
    required this.answer3,
    required this.question4,
    required this.answer4,
    required this.question5,
    required this.answer5,
    required this.question6,
    required this.answer6,
    required this.question7,
    required this.answer7,
    required this.question8,
    required this.answer8,
    required this.question9,
    required this.answer9,
    required this.question10,
    required this.answer10,
    required this.question11,
    required this.answer11,
    required this.question12,
    required this.answer12,
    required this.question13,
    required this.answer13,
    required this.question14,
    required this.answer14,
    required this.question15,
    required this.answer15,
    required this.question16,
    required this.answer16,
    required this.question17,
    required this.answer17,
    required this.question18,
    required this.answer18,
    required this.question19,
    required this.answer19,
    required this.question20,
    required this.answer20,
    required this.submittedAt,
  });

  factory MakerUTCase.fromJson(Map<String, dynamic> json) {
    return MakerUTCase(
      id: json["id"],
      utId: json["utId"],
      testerName: json["testerName"],
      status: json["status"],
      question1: json["question1"],
      answer1: json["answer1"],
      question2: json["question2"],
      answer2: json["answer2"],
      question3: json["question3"],
      answer3: json["answer3"],
      question4: json["question4"],
      answer4: json["answer4"],
      question5: json["question5"],
      answer5: json["answer5"],
      question6: json["question6"],
      answer6: json["answer6"],
      question7: json["question7"],
      answer7: json["answer7"],
      question8: json["question8"],
      answer8: json["answer8"],
      question9: json["question9"],
      answer9: json["answer9"],
      question10: json["question10"],
      answer10: json["answer10"],
      question11: json["question11"],
      answer11: json["answer11"],
      question12: json["question12"],
      answer12: json["answer12"],
      question13: json["question13"],
      answer13: json["answer13"],
      question14: json["question14"],
      answer14: json["answer14"],
      question15: json["question15"],
      answer15: json["answer15"],
      question16: json["question16"],
      answer16: json["answer16"],
      question17: json["question17"],
      answer17: json["answer17"],
      question18: json["question18"],
      answer18: json["answer18"],
      question19: json["question19"],
      answer19: json["answer19"],
      question20: json["question20"],
      answer20: json["answer20"],
      // unix timestamp to DateTime
      submittedAt:
          DateTime.fromMillisecondsSinceEpoch(json["submittedAt"] * 1000),
    );
  }
}

class QueryMakerUTCaseResponse extends Response {
  final List<MakerUTCase> utCases;

  QueryMakerUTCaseResponse({required this.utCases});

  factory QueryMakerUTCaseResponse.fromJson(Map<String, dynamic> json) {
    return QueryMakerUTCaseResponse(
        utCases: (json["utCases"] as List<dynamic>)
            .map((e) => MakerUTCase.fromJson(e))
            .toList());
  }
}

Future<Response> queryMakerUTCases(int utId) async {
  String token = await getLoginInfo();
  String queryMakerUTCaseV1 = "/api/v1/maker/uts/$utId/utcases";
  final response = await http.get(
    Uri.parse(_baseUrl + queryMakerUTCaseV1),
    headers: {
      "Content-Type": "application/json",
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    return Success(
      data: QueryMakerUTCaseResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))["data"],
      ),
    );
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    return Error.fromJson(jsonDecode(responseBody));
  }
}

Future<Response> deleteUser() async {
  String token = await getLoginInfo();
  String deleteUserV1 = "/api/v1/me";

  try {
    final response = await http.delete(
      Uri.parse(_baseUrl + deleteUserV1),
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode != 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Error.fromJson(jsonDecode(responseBody));
    }
    return Success();
  } catch (e) {
    return Error(message: "잠시 후 다시 시도해주세요");
  }
}
