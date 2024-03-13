import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<TransactionStoreDTO> transactionStoreDtoFromJson(String str) =>
    List<TransactionStoreDTO>.from(
        json.decode(str).map((x) => TransactionStoreDTO.fromJson(x)));

String transactionStoreDtoToJson(List<TransactionStoreDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionStoreDTO {
  final String transactionId;
  final int amount;
  final String bankAccount;
  final String bankName;
  final String bankShortName;
  final String bankCode;
  final String content;
  final String transType;
  final int? time;
  final int? timePaid;
  final int? status;
  final int? type;
  String? note;
  final String? referenceNumber;
  final String? orderId;
  final String? terminalCode;

  String get timeCreate => DateFormat('HH:mm:ss\ndd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch((time ?? 0) * 1000));

  String get timePayment => DateFormat('HH:mm:ss\ndd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch((timePaid ?? 0) * 1000));

  String get timeCreateEditNote => DateFormat('HH:mm:ss dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch((time ?? 0) * 1000));

  String get timePaymentEditNote => DateFormat('HH:mm:ss dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch((timePaid ?? 0) * 1000));

  String get transactionType => type == 1
      ? 'QR cửa hàng'
      : type == 2
          ? 'QR giao dịch'
          : 'Khác';

  String get statusType => status == 0
      ? 'Chờ thanh toán'
      : status == 1
          ? 'Thành công'
          : 'Đã hủy';

  Color get getColorStatus {
    if (transType.trim() == 'D') return AppColor.RED_CALENDAR;

    if (status == 0) return AppColor.ORANGE_DARK;

    if (status == 1 && type == 2) return AppColor.BLUE_TEXT;

    if (status == 1 && (type == 0 || type == 1 || type == 4 || type == 5)) {
      return AppColor.GREEN;
    }

    if (status == 2) return AppColor.GREY_TEXT;

    return AppColor.TRANSPARENT;
  }

  String get statusAmount {
    if (transType.trim() == 'D') {
      return '-';
    }
    return '+';
  }

  TransactionStoreDTO({
    this.transactionId = '',
    this.amount = 0,
    this.bankAccount = '',
    this.bankName = '',
    this.bankShortName = '',
    this.bankCode = '',
    this.content = '',
    this.transType = '',
    this.time,
    this.timePaid,
    this.status,
    this.type,
    this.note,
    this.referenceNumber,
    this.orderId,
    this.terminalCode,
  });

  factory TransactionStoreDTO.fromJson(Map<String, dynamic> json) =>
      TransactionStoreDTO(
        transactionId: json["transactionId"] ?? '',
        amount: json["amount"] ?? 0,
        bankAccount: json["bankAccount"] ?? '',
        bankName: json["bankName"] ?? '',
        bankShortName: json["bankShortName"] ?? '',
        bankCode: json["bankCode"] ?? '',
        content: json["content"] ?? '',
        transType: json["transType"] ?? '',
        time: json.containsKey('time')
            ? (json["time"] ?? 0)
            : json.containsKey('timeCreated')
                ? (json["timeCreated"] ?? 0)
                : 0,
        timePaid: json["timePaid"] ?? 0,
        status: json["status"] ?? 0,
        type: json["type"] ?? 0,
        note: json["note"] ?? '',
        referenceNumber: json["referenceNumber"] ?? '',
        orderId: json["orderId"] ?? '',
        terminalCode: json["terminalCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "amount": amount,
        "bankAccount": bankAccount,
        "bankName": bankName,
        "bankShortName": bankShortName,
        "bankCode": bankCode,
        "content": content,
        "time": time,
        "timePaid": timePaid,
        "status": status,
        "type": type,
        "note": note,
        "referenceNumber": referenceNumber,
        "orderId": orderId,
        "terminalCode": terminalCode,
      };
}
