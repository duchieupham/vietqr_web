class AccountLoginMethodDTO {
  // Method: CARD, USER_ID
  final String method;
  final String cardNumber;
  final String userId;
  final String platform;
  final String device;
  final String fcmToken;

  const AccountLoginMethodDTO({
    required this.method,
    required this.cardNumber,
    required this.userId,
    required this.platform,
    required this.device,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['method'] = method;
    data['cardNumber'] = cardNumber;
    data['userId'] = userId;
    data['fcmToken'] = fcmToken;
    data['device'] = device;
    data['platform'] = platform;
    return data;
  }
}
