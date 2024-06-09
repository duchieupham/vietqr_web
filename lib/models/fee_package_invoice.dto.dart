class FeePackageInvoiceDTO {
  String invoiceItemId;
  String timeProcess;
  String bankAccount;
  String bankShortName;
  bool mmsActive;
  String title;
  int totalCount;
  int totalAmountReceive;
  int fixFee;
  double percentFee;
  int amount;
  int totalAmount;
  double vat;
  int totalAfterVat;

  FeePackageInvoiceDTO({
    required this.timeProcess,
    required this.bankAccount,
    required this.bankShortName,
    required this.mmsActive,
    required this.title,
    required this.totalCount,
    required this.totalAmountReceive,
    required this.fixFee,
    required this.percentFee,
    required this.amount,
    required this.totalAmount,
    required this.vat,
    required this.totalAfterVat,
    required this.invoiceItemId,
  });

  factory FeePackageInvoiceDTO.fromJson(Map<String, dynamic> json) {
    return FeePackageInvoiceDTO(
      invoiceItemId: json['invoiceItemId'],
      timeProcess: json['timeProcess'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      mmsActive: json['mmsActive'],
      title: json['title'],
      totalCount: json['totalCount'],
      totalAmountReceive: json['totalAmountReceive'],
      fixFee: json['fixFee'],
      percentFee: json['percentFee']
          .toDouble(), // Assuming this might be parsed as int but should be double
      amount: json['amount'],
      totalAmount: json['totalAmount'],
      vat: json['vat']
          .toDouble(), // Assuming this might be parsed as int but should be double
      totalAfterVat: json['totalAfterVat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceItemId': invoiceItemId,
      'timeProcess': timeProcess,
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'mmsActive': mmsActive,
      'title': title,
      'totalCount': totalCount,
      'totalAmountReceive': totalAmountReceive,
      'fixFee': fixFee,
      'percentFee': percentFee,
      'amount': amount,
      'totalAmount': totalAmount,
      'vat': vat,
      'totalAfterVat': totalAfterVat,
    };
  }
}
