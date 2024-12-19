import 'package:flutter/material.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/models/ut_client_model.dart';
import 'package:flyer_client/screens/maker_choose_ut_target_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerChooseUTAppScreen extends StatefulWidget {
  const MakerChooseUTAppScreen({super.key, required this.utClientModel});

  final UtClientModel utClientModel;

  @override
  State<MakerChooseUTAppScreen> createState() => _MakerChooseUTAppScreenState();
}

class _MakerChooseUTAppScreenState extends State<MakerChooseUTAppScreen> {
  Future<Response> queryAppAssetsFuture = queryAppAssets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "앱 선택",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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
                          "UT 생성 취소",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "입력한 정보가 모두 사라집니다.\nUT 생성을 취소하시겠습니까?",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(thickness: 0.3),
                        // 네, 취소합니다.
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 5),
                              child: Text(
                                "네 취소합니다.",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(primaryColor),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Color(primaryColor),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75,
          child: FutureBuilder(
            future: queryAppAssetsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                QueryAppAssetResponse queryAppAssetResponse =
                    (snapshot.data as Success).data as QueryAppAssetResponse;
                if (queryAppAssetResponse.appAssets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "등록한 앱 없음",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "스토어에 출시한 앱을",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.outline,
                              height: 1),
                        ),
                        Text(
                          "플라이어에 등록해보세요!",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    ...queryAppAssetResponse.appAssets.map(
                      (appAsset) => ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            appAsset.iconUrl,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        // title max 2 lines overflow ellipsis
                        title: Text(
                          appAsset.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appAsset.platform == "IOS"
                                  ? "App Store"
                                  : "Google Play",
                              style: TextStyle(
                                color: Color(primaryColor),
                                fontSize: 12,
                                letterSpacing: -0.4,
                              ),
                            ),
                            Text(
                              appAsset.shortDescription,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 13,
                                letterSpacing: -0.4,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        onTap: () async {
                          widget.utClientModel.appAsset = appAsset;
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MakerChooseUTTargetScreen(
                                    utClientModel: widget.utClientModel,
                                  ),
                                ),
                              )
                              .then(
                                (value) => {
                                  if (value != null && value is UtClientModel)
                                    {
                                      widget.utClientModel.appAsset =
                                          value.appAsset,
                                      widget.utClientModel
                                              .targetUserDescription =
                                          value.targetUserDescription,
                                      widget.utClientModel.surveyQuestions =
                                          value.surveyQuestions,
                                    }
                                },
                              );
                        },
                        trailing: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            // rgba 60 60 67, 0.3
                            color: Color(0x4D3C3C43),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
