class InvoiceFeeDTO {
  String? invoiceId;
  String? billNumber;
  String? invoiceNumber;
  String? invoiceName;
  int? timeCreated;
  int? timePaid;
  int? status;
  String? bankId;
  String? bankAccount;
  String? bankShortName;
  String? userBankName;

  String? qrCode;
  String? midName;
  String? vso;

  int? totalAmount;

  InvoiceFeeDTO({
    this.invoiceId,
    this.billNumber,
    this.invoiceNumber,
    this.invoiceName,
    this.timeCreated,
    this.timePaid,
    this.status,
    this.bankId,
    this.bankAccount,
    this.userBankName,
    this.midName,
    this.vso,
    this.bankShortName,
    this.qrCode,
    this.totalAmount,
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
