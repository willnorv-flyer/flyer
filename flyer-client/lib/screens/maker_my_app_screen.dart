import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/screens/%08update_maker_app_screen.dart';
import 'package:flyer_client/screens/search_maker_app_screen.dart';
import 'package:flyer_client/util/colors.dart';

class MakerMyAppScreen extends StatefulWidget {
  const MakerMyAppScreen({super.key});

  @override
  State<MakerMyAppScreen> createState() => _MakerMyAppScreenState();
}

class _MakerMyAppScreenState extends State<MakerMyAppScreen> {
  Future<Response> queryAppAssetsFuture = queryAppAssets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "등록된 앱",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SearchMakerAppScreen(
                    queryAppAssetsFuture: queryAppAssetsFuture,
                  );
                },
                isScrollControlled: true,
                useSafeArea: true,
              ).then(
                (value) => {
                  setState(
                    () {
                      queryAppAssetsFuture = queryAppAssets();
                    },
                  )
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.add, color: Color(primaryColor)),
                  Text(
                    "추가",
                    style: TextStyle(
                      color: Color(primaryColor),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
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
                            appAsset.shortDescription.trim().isEmpty
                                ? "앱을 소개하는 문구를 추가해주세요"
                                : appAsset.shortDescription,
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
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (!context.mounted) {
                                      return;
                                    }
                                    Response deleteAppAssetResponse =
                                        await deleteAppAsset(appAsset.id);
                                    if (deleteAppAssetResponse is Error) {
                                      Fluttertoast.showToast(
                                        msg: "앱 삭제에 실패했습니다",
                                      );
                                    } else {
                                      setState(() {
                                        queryAppAssetsFuture = queryAppAssets();
                                      });
                                      Fluttertoast.showToast(
                                        msg: "앱을 삭제했습니다",
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 17,
                                        bottom: 9,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "삭제",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Color(errorColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(thickness: 0.3),
                                GestureDetector(
                                  onTap: () => {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return UpdateMakerAppScreen(
                                            appAsset: appAsset);
                                      },
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                    ).then(
                                      (value) => {
                                        Navigator.of(context).pop(),
                                        setState(
                                          () {
                                            queryAppAssetsFuture =
                                                queryAppAssets();
                                          },
                                        )
                                      },
                                    ),
                                  },
                                  child: InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 9,
                                        bottom: 9,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "문구 수정",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Color(primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(thickness: 0.3),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 9,
                                        bottom: 17,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "취소",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      trailing: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/overflow_vertical.png",
                          width: 24,
                          height: 24,
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
    );
  }
}
