class QRGeneratedDTO {
  final String bankCode;
  final String bankName;
  final String bankAccount;
  final String userBankName;
  final String amount;
  final String content;
  final String qrCode;
  final String imgId;
  final String email;
  final int type;
  final String transactionRefId;
  final String qrLink;

  const QRGeneratedDTO(
      {this.bankCode = '',
      this.bankName = '',
      this.bankAccount = '',
      this.userBankName = '',
      this.amount = '',
      this.content = '',
      this.qrCode = '',
      this.imgId = '',
      this.type = 0,
      this.email = '',
      this.qrLink = '',
      this.transactionRefId = ''});

  factory QRGeneratedDTO.fromJson(Map<String, dynamic> json) {
    return QRGeneratedDTO(
        bankCode: json['bankCode'],
        bankName: json['bankName'],
        bankAccount: json['bankAccount'],
        userBankName: json['userBankName'],
        amount: json['amount'],
        content: json['content'],
        qrCode: json['qrCode'],
        imgId: json['imgId'],
        transactionRefId: json['transactionRefId'],
        qrLink: json['qrLink']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['amount'] = amount;
    data['content'] = content;
    data['qrCode'] = qrCode;
    data['imgId'] = imgId;
    return data;
  }
}
