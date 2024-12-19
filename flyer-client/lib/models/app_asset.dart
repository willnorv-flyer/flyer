class AppAsset {
  final int id;
  final int userId;
  final String appId;
  final String name;
  final String shortDescription;
  final String iconUrl;
  final String platform;
  final String category;

  AppAsset({
    required this.id,
    required this.userId,
    required this.appId,
    required this.name,
    required this.shortDescription,
    required this.iconUrl,
    required this.platform,
    required this.category,
  });

  factory AppAsset.fromJson(Map<String, dynamic> json) {
    return AppAsset(
      id: json["id"],
      userId: json["userId"],
      appId: json["appId"],
      name: json["name"],
      shortDescription: json["shortDescription"],
      iconUrl: json["iconUrl"],
      platform: json["platform"],
      category: json["category"],
    );
  }
}
