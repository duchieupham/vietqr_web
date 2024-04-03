// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

import 'package:VietQR/commons/utils/currency_utils.dart';

StoreModel storeModelFromJson(String str) =>
    StoreModel.fromJson(json.decode(str));

String storeModelToJson(StoreModel data) => json.encode(data.toJson());

class StoreModel {
  final String merchantId;
  final String merchantName;
  final String merchantAddress;
  final int totalTerminals;
  List<Terminal> terminals;

  StoreModel({
    this.merchantId = '',
    this.merchantName = '',
    this.merchantAddress = '',
    this.totalTerminals = -1,
    this.terminals = const [],
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        merchantId: json["merchantId"],
        merchantName: json["merchantName"],
        merchantAddress: json["merchantAddress"],
        totalTerminals: json["totalTerminals"],
        terminals: json["terminals"] == null
            ? []
            : List<Terminal>.from(
                json["terminals"]!.map((x) => Terminal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "merchantName": merchantName,
        "merchantAddress": merchantAddress,
        "totalTerminals": totalTerminals,
        "terminals": List<dynamic>.from(terminals.map((x) => x.toJson())),
      };
}

class Terminal {
  final String? terminalId;
  final String? terminalName;
  final String? terminalAddress;
  final int? totalTrans;
  final int? totalAmount;
  final int? totalMember;
  final String? terminalCode;
  final String? bankName;
  final String? bankAccount;
  final String? bankShortName;
  final String? bankAccountName;

  String get amount =>
      CurrencyUtils.instance.getCurrencyFormatted(totalAmount.toString());

  Terminal({
    this.terminalId,
    this.terminalName,
    this.terminalAddress,
    this.totalTrans,
    this.totalAmount,
    this.totalMember,
    this.terminalCode,
    this.bankName,
    this.bankAccount,
    this.bankShortName,
    this.bankAccountName,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
        terminalId: json["terminalId"] ?? '-',
        terminalName: json["terminalName"] ?? '-',
        terminalAddress: json["terminalAddress"] ?? '-',
        totalTrans: json["totalTrans"],
        totalAmount: json["totalAmount"],
        totalMember: json["totalMember"],
        terminalCode: json["terminalCode"],
        bankName: json["bankName"] ?? '-',
        bankAccount: json["bankAccount"] ?? '-',
        bankShortName: json["bankShortName"] ?? '-',
        bankAccountName: json["bankAccountName"] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        "terminalId": terminalId,
        "terminalName": terminalName,
        "terminalAddress": terminalAddress,
        "totalTrans": totalTrans,
        "totalAmount": totalAmount,
        "totalMember": totalMember,
        "terminalCode": terminalCode,
        "bankName": bankName,
        "bankAccount": bankAccount,
        "bankShortName": bankShortName,
        "bankAccountName": bankAccountName,
      };
}
