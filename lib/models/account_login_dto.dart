class AccountLoginDTO {
  final String phoneNo;
  final String email;
  final String password;
  final String platform;
  final String device;
  final String fcmToken;

  const AccountLoginDTO({
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.platform,
    required this.device,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['email'] = email;
    data['password'] = password;
    data['fcmToken'] = fcmToken;
    data['device'] = device;
    data['platform'] = platform;
    print(data);
    return data;
  }
}
