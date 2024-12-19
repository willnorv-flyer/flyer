import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flyer_client/api/api_service.dart';
import 'package:flyer_client/banned_keywords.dart';
import 'package:flyer_client/models/app_asset.dart';
import 'package:flyer_client/util/colors.dart';

class SearchMakerAppScreen extends StatefulWidget {
  SearchMakerAppScreen({super.key, required this.queryAppAssetsFuture});

  Future<Response> queryAppAssetsFuture;

  @override
  State<SearchMakerAppScreen> createState() => _SearchMakerAppScreenState();
}

class _SearchMakerAppScreenState extends State<SearchMakerAppScreen> {
  Timer _debounce = Timer(Duration.zero, () {});
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  Future<SearchAppstoreAppsResponse>? searchAppstoreAppsFuture;
  Future<SearchGooglePlayAppsResponse>? searchGoogleplayAppsFuture;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_debounce.isActive) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (_searchController.text.isNotEmpty &&
            _searchController.text.length > 1) {
          setState(() {
            searchAppstoreAppsFuture =
                searchAppstoreApps(_searchController.text);
            searchGoogleplayAppsFuture =
                searchGooglePlayApps(_searchController.text);
            _searchText = _searchController.text;
          });
        } else {
          setState(() {
            searchAppstoreAppsFuture = null;
            searchGoogleplayAppsFuture = null;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "취소",
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text(
                    "스토어 검색",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "완료",
                          style: TextStyle(
                            color: Color(primaryColor),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x1A767880),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // search bar that can be cancelled by clicking the x button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            decoration: InputDecoration(
                              hintText: "검색",
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchText = "";
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 0.3),

            // search result
            if (_searchText.isNotEmpty)
              FutureBuilder(
                future: widget.queryAppAssetsFuture,
                builder: (queryAppAssetscontext, queryAppAssetsSnapshot) =>
                    FutureBuilder<SearchAppstoreAppsResponse>(
                  future: searchAppstoreAppsFuture,
                  builder: (appstoreApiContext, appstoreApiSnapshot) {
                    if (queryAppAssetsSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        appstoreApiSnapshot.hasError) {
                      return const CircularProgressIndicator();
                    }

                    QueryAppAssetResponse queryAppAssetResponse =
                        (queryAppAssetsSnapshot.data as Success).data
                            as QueryAppAssetResponse;

                    return FutureBuilder<SearchGooglePlayAppsResponse>(
                      future: searchGoogleplayAppsFuture,
                      builder: (playstoreApiContext, playstoreApiSnapshot) {
                        if (appstoreApiSnapshot.connectionState ==
                                ConnectionState.waiting ||
                            playstoreApiSnapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (appstoreApiSnapshot.hasError ||
                            playstoreApiSnapshot.hasError) {
                          return Center(
                            child: Text(
                              "검색 결과가 없습니다",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 15,
                              ),
                            ),
                          );
                        } else {
                          List<Widget> appstoreWidgets = [];
                          List<Widget> playstoreWidgets = [];
                          if (appstoreApiSnapshot.hasData) {
                            if (appstoreApiSnapshot.data!.results.isNotEmpty) {
                              appstoreWidgets = appstoreApiSnapshot
                                  .data!.results
                                  .where((app) => !(bannedKeywords.any(
                                      (keyword) =>
                                          app.trackName.contains(keyword))))
                                  .map((app) => ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            app.artworkUrl512,
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                        // title max 2 lines overflow ellipsis
                                        title: Text(
                                          app.trackName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          "App Store",
                                          style: TextStyle(
                                            color: Color(primaryColor),
                                            fontSize: 12,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        onTap: () async {
                                          List<AppAsset> matchingAppAsset =
                                              queryAppAssetResponse.appAssets
                                                  .where((appAsset) =>
                                                      appAsset.appId ==
                                                      "${app.trackId}")
                                                  .toList();
                                          if (matchingAppAsset.isNotEmpty) {
                                            await deleteAppAsset(
                                                matchingAppAsset.first.id);
                                            HapticFeedback.mediumImpact();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "${app.trackName} 앱을 삭제했습니다.");
                                          } else {
                                            await createAppAsset(
                                              "${app.trackId}",
                                              app.trackName,
                                              "",
                                              app.artworkUrl512,
                                              "IOS",
                                              app.genres.isEmpty
                                                  ? "기타"
                                                  : app.genres.first,
                                            );
                                            HapticFeedback.mediumImpact();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "${app.trackName} 앱을 등록했습니다.");
                                          }
                                          setState(() {
                                            widget.queryAppAssetsFuture =
                                                queryAppAssets();
                                          });
                                        },
                                        trailing: Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: queryAppAssetResponse
                                                    .appAssets
                                                    .any((appAsset) =>
                                                        appAsset.appId ==
                                                        "${app.trackId}")
                                                ? const Color(0xFF007AFF)
                                                : const Color(0xFFD1D1D6),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Icon(
                                            queryAppAssetResponse.appAssets.any(
                                                    (appAsset) =>
                                                        appAsset.appId ==
                                                        "${app.trackId}")
                                                ? Icons.check
                                                : Icons.add,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ))
                                  .toList();
                            }
                          }
                          if (playstoreApiSnapshot.hasData) {
                            if (playstoreApiSnapshot.data!.results.isNotEmpty) {
                              playstoreWidgets = playstoreApiSnapshot
                                  .data!.results
                                  .where((app) => !(bannedKeywords.any(
                                      (keyword) =>
                                          app.title.contains(keyword))))
                                  .map((app) => ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            app.icon,
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                        // title max 2 lines overflow ellipsis
                                        title: Text(
                                          app.title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          "Google Play",
                                          style: TextStyle(
                                            color: Color(primaryColor),
                                            fontSize: 12,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        onTap: () async {
                                          List<AppAsset> matchingAppAsset =
                                              queryAppAssetResponse.appAssets
                                                  .where((appAsset) =>
                                                      appAsset.appId ==
                                                      app.appId)
                                                  .toList();
                                          if (matchingAppAsset.isNotEmpty) {
                                            await deleteAppAsset(
                                                matchingAppAsset.first.id);
                                            HapticFeedback.mediumImpact();
                                            Fluttertoast.showToast(
                                                msg: "${app.title} 앱을 삭제했습니다.");
                                          } else {
                                            Response
                                                playstoreAppDetailResponse =
                                                await scrapeGooglePlayAppDetail(
                                                    app.appId);
                                            if (playstoreAppDetailResponse
                                                is Success) {
                                              PlaystoreAppDetail appDetail =
                                                  playstoreAppDetailResponse
                                                          .data
                                                      as PlaystoreAppDetail;
                                              await createAppAsset(
                                                app.appId,
                                                app.title,
                                                appDetail.summary,
                                                app.icon,
                                                "ANDROID",
                                                appDetail.genre,
                                              );
                                              HapticFeedback.mediumImpact();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "${app.title} 앱을 등록했습니다.");
                                            }
                                          }
                                          setState(() {
                                            widget.queryAppAssetsFuture =
                                                queryAppAssets();
                                          });
                                        },
                                        trailing: Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: queryAppAssetResponse
                                                    .appAssets
                                                    .any((appAsset) =>
                                                        appAsset.appId ==
                                                        app.appId)
                                                ? const Color(0xFF007AFF)
                                                : const Color(0xFFD1D1D6),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Icon(
                                            queryAppAssetResponse.appAssets.any(
                                                    (appAsset) =>
                                                        appAsset.appId ==
                                                        app.appId)
                                                ? Icons.check
                                                : Icons.add,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ))
                                  .toList();
                            }
                          }

                          // merge result of the search. switch between appstore and playstore. start with the one that has more results
                          List<Widget> mergedWidgets = [];
                          if (appstoreWidgets.length >
                              playstoreWidgets.length) {
                            for (int i = 0; i < appstoreWidgets.length; i++) {
                              mergedWidgets.add(appstoreWidgets[i]);
                              if (i < playstoreWidgets.length) {
                                mergedWidgets.add(playstoreWidgets[i]);
                              }
                            }
                          } else {
                            for (int i = 0; i < playstoreWidgets.length; i++) {
                              if (i < appstoreWidgets.length) {
                                mergedWidgets.add(appstoreWidgets[i]);
                              }
                              mergedWidgets.add(playstoreWidgets[i]);
                            }
                          }

                          return Column(
                            children: mergedWidgets,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
