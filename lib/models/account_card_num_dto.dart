class AccountCardNumDTO {
  final String userId;
  final String cardNumber;

  const AccountCardNumDTO({
    required this.userId,
    required this.cardNumber,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['cardNumber'] = cardNumber;
    return data;
  }
}
