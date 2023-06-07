class ECOMAccountLoginDTO {
  final String phoneNo;
  final String email;
  final String password;
  final String platform;
  final String device;
  final String fcmToken;
  final String hosting;

  const ECOMAccountLoginDTO({
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.platform,
    required this.device,
    required this.fcmToken,
    required this.hosting,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['email'] = email;
    data['password'] = password;
    data['fcmToken'] = fcmToken;
    data['device'] = device;
    data['platform'] = platform;
    data['hosting'] = hosting;
    print(data);
    return data;
  }
}
