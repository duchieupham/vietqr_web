class InvoiceFeeDTO {
  String invoiceId;
  String billNumber;
  String invoiceNumber;
  String invoiceName;
  int timeCreated;
  int timePaid;
  int status;
  String bankId;
  String bankAccount;
  String bankShortName;
  String userBankName;

  String qrCode;
  String midName;
  String vso;

  int totalAmount;
  bool isSelect;

  InvoiceFeeDTO({
    required this.invoiceId,
    required this.billNumber,
    required this.invoiceNumber,
    required this.invoiceName,
    required this.timeCreated,
    required this.timePaid,
    required this.status,
    required this.bankId,
    required this.bankAccount,
    required this.userBankName,
    required this.midName,
    required this.vso,
    required this.bankShortName,
    required this.qrCode,
    required this.totalAmount,
    this.isSelect = true,
  });

  factory InvoiceFeeDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceFeeDTO(
      invoiceId: json['invoiceId'],
      billNumber: json['billNumber'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      invoiceName: json['invoiceName'] ?? '',
      timeCreated: json['timeCreated'],
      timePaid: json['timePaid'] ?? '',
      status: json['status'],
      midName: json['midName'] ?? '',
      userBankName: json['userBankName'] ?? '',
      vso: json['vso'] ?? '',
      bankId: json['bankId'],
      bankAccount: json['bankAccount'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      qrCode: json['qrCode'] ?? '',
      totalAmount: json['totalAmount'],
    );
  }

  void selected(bool value) {
    isSelect = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'billNumber': billNumber,
      'invoiceNumber': invoiceNumber,
      'invoiceName': invoiceName,
      'timeCreated': timeCreated,
      'timePaid': timePaid,
      'status': status,
      'bankId': bankId,
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'qrCode': qrCode,
      'totalAmount': totalAmount,
    };
  }
}
