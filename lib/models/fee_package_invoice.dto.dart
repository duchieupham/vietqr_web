import 'dart:convert';

class FeePackageInvoiceDTO {
  final String timeProcess;
  final String bankAccount;
  final String bankShortName;
  final String connectionType;
  final String title;
  final int totalCount;
  final int totalAmountReceive;
  final int fixFee;
  final double percentFee;
  final int vatAmount;
  final int totalAmount;
  final double vat;
  final int totalAfterVat;
  final String invoiceItemId;

  FeePackageInvoiceDTO({
    required this.timeProcess,
    required this.bankAccount,
    required this.bankShortName,
    required this.connectionType,
    required this.title,
    required this.totalCount,
    required this.totalAmountReceive,
    required this.fixFee,
    required this.percentFee,
    required this.vatAmount,
    required this.totalAmount,
    required this.vat,
    required this.totalAfterVat,
    required this.invoiceItemId,
  });

  factory FeePackageInvoiceDTO.fromJson(Map<String, dynamic> json) {
    return FeePackageInvoiceDTO(
      timeProcess: json['timeProcess'],
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      connectionType: json['connectionType'],
      title: json['title'],
      totalCount: json['totalCount'],
      totalAmountReceive: json['totalAmountReceive'],
      fixFee: json['fixFee'],
      percentFee: json['percentFee'],
      vatAmount: json['vatAmount'],
      totalAmount: json['totalAmount'],
      vat: json['vat'],
      totalAfterVat: json['totalAfterVat'],
      invoiceItemId: json['invoiceItemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeProcess': timeProcess,
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'connectionType': connectionType,
      'title': title,
      'totalCount': totalCount,
      'totalAmountReceive': totalAmountReceive,
      'fixFee': fixFee,
      'percentFee': percentFee,
      'vatAmount': vatAmount,
      'totalAmount': totalAmount,
      'vat': vat,
      'totalAfterVat': totalAfterVat,
      'invoiceItemId': invoiceItemId,
    };
  }
}
