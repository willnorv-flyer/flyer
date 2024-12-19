class UserV1 {
  final int id;
  final String email;
  final String nickname;
  final int birthday;
  final String gender;
  final String job;
  final int cash;
  final String userType;
  final String phoneNumber;
  final String corporateEmail;
  final String websiteUrl;
  final int pushAgreedAt;

  UserV1({
    required this.id,
    required this.email,
    required this.nickname,
    required this.birthday,
    required this.gender,
    required this.job,
    required this.cash,
    required this.userType,
    required this.phoneNumber,
    required this.corporateEmail,
    required this.websiteUrl,
    required this.pushAgreedAt,
  });

  factory UserV1.fromJson(Map<String, dynamic> json) {
    return UserV1(
      id: json["id"],
      email: json["email"],
      nickname: json["nickname"],
      birthday: json["birthday"],
      gender: json["gender"],
      job: json["job"],
      cash: json["cash"],
      userType: json["userType"],
      phoneNumber: json["phoneNumber"],
      corporateEmail: json["corporateEmail"],
      websiteUrl: json["websiteUrl"],
      pushAgreedAt: json["pushAgreedAt"],
    );
  }
}
