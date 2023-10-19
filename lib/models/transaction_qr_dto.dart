class TransactionQRDTO {
  final String transactionId;
  final String qr;
  final int amount;
  final String content;
  final String transType;
  final String terminalCode;
  final String orderId;
  final String sign;
  final int type;
  final int status;
  final int timeCreated;
  final String bankTypeId;
  final String userBankName;
  final String bankAccount;
  final String bankCode;
  final String bankName;
  final String bankShortName;
  final String imgId;

  const TransactionQRDTO(
      {this.type = 0,
      this.bankAccount = '',
      this.content = '',
      this.amount = 0,
      this.bankCode = '',
      this.bankName = '',
      this.bankShortName = '',
      this.transType = '',
      this.timeCreated = 0,
      this.status = 0,
      this.orderId = '',
      this.bankTypeId = '',
      this.imgId = '',
      this.qr = '',
      this.sign = '',
      this.terminalCode = '',
      this.transactionId = '',
      this.userBankName = ''});
  factory TransactionQRDTO.fromJson(Map<String, dynamic> json) {
    return TransactionQRDTO(
      type: json['type'] ?? 0,
      bankAccount: json['bankAccount'] ?? '',
      content: json['content'] ?? '',
      amount: json['amount'] ?? 0,
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      transType: json['transType'] ?? '',
      timeCreated: json['timeCreated'] ?? 0,
      status: json['status'] ?? 0,
      orderId: json['orderId'] ?? '',
      bankTypeId: json['bankTypeId'] ?? '',
      imgId: json['imgId'] ?? '',
      qr: json['qr'] ?? '',
      sign: json['sign'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      transactionId: json['transactionId'] ?? '',
      userBankName: json['userBankName'] ?? '',
    );
  }
}
