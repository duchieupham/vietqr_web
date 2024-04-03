class WalletDTO {
  final String amount;
  final String point;
  final String sharingCode;
  final String walletId;
  final bool enableService;

  const WalletDTO({
    this.amount = '0',
    this.enableService = false,
    this.point = '',
    this.sharingCode = '',
    this.walletId = '',
  });

  factory WalletDTO.fromJson(Map<String, dynamic> json) {
    return WalletDTO(
      amount: json['amount'] ?? '',
      point: json['point'] ?? '',
      sharingCode: json['sharingCode'] ?? '',
      walletId: json['walletId'] ?? '',
      enableService: json['enableService'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['amount'] = amount;
    data['point'] = point;
    data['sharingCode'] = sharingCode;
    data['walletId'] = walletId;
    data['enableService'] = enableService;
    return data;
  }
}
