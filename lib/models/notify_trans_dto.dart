import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifyTransDTO {
  final String notificationType;
  final String traceId;
  final String bankAccount;
  final String bankName;
  final String bankCode;
  final String amount;
  final String bankId;
  final String branchName;
  final String businessName;
  final String notificationId;
  final int time;
  final String refId;
  final String transactionReceiveId;
  final String content;
  final int status;
  final String transType;
  final String audioLink;
  final String terminalName;
  final String terminalCode;
  final String rawTerminalCode;
  final String orderId;
  final String referenceNumber;

  NotifyTransDTO({
    required this.notificationType,
    required this.traceId,
    required this.bankAccount,
    required this.bankName,
    required this.bankCode,
    required this.amount,
    required this.bankId,
    required this.branchName,
    required this.businessName,
    required this.notificationId,
    required this.time,
    required this.refId,
    required this.transactionReceiveId,
    required this.content,
    required this.status,
    required this.transType,
    required this.audioLink,
    required this.terminalName,
    required this.terminalCode,
    required this.rawTerminalCode,
    required this.orderId,
    required this.referenceNumber,
  });

  String get getTransStatus => 'Giao dịch thành công';

  String get getTransType => (transType.trim() == 'C') ? '+' : '-';

  String get getAmount =>
      '$getTransType ${CurrencyUtils.instance.getCurrencyFormatted(amount)} VND';

  Color get colorAmount => (transType.trim() == 'C')
      ? isTransUnclassified
          ? AppColor.BLUE_TEXT
          : AppColor.GREEN
      : AppColor.RED_CALENDAR;

  String get timePayment => time == 0
      ? '-'
      : DateFormat('dd/MM/yyyy HH:mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  ///
  bool get isTerNotEmpty => terminalName.isNotEmpty || terminalCode.isNotEmpty;

  bool get isTerEmpty => terminalName.isEmpty && terminalCode.isEmpty;

  bool get isTransUnclassified =>
      terminalName.isEmpty && terminalCode.isEmpty && orderId.isEmpty;

  String get icon => (transType.trim() == 'C')
      ? isTransUnclassified
          ? AppImages.icSuccessInBlue
          : AppImages.icSuccessInGreen
      : AppImages.icSuccessOut;

  factory NotifyTransDTO.fromJson(Map<String, dynamic> json) {
    return NotifyTransDTO(
      notificationType: json['notificationType'] ?? '',
      traceId: json['traceId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankName: json['bankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      amount: json['amount'] ?? '',
      bankId: json['bankId'] ?? '',
      branchName: json['branchName'] ?? '',
      businessName: json['businessName'] ?? '',
      notificationId: json['notificationId'] ?? '',
      time: int.tryParse(json['time'] ?? '') ?? 0,
      refId: json['refId'] ?? '',
      transactionReceiveId: json['transactionReceiveId'] ?? '',
      content: json['content'] ?? '',
      status: int.tryParse(json['status'] ?? '') ?? 0,
      transType: json['transType'] ?? '',
      audioLink: json['audioLink'] ?? '',
      terminalName: json["terminalName"] ?? '',
      terminalCode: json["terminalCode"] ?? '',
      rawTerminalCode: json["rawTerminalCode"] ?? '',
      orderId: json["orderId"] ?? '',
      referenceNumber: json["referenceNumber"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notificationType'] = notificationType;
    data['traceId'] = traceId;
    data['bankAccount'] = bankAccount;
    data['bankName'] = bankName;
    data['bankCode'] = bankCode;
    data['amount'] = amount;
    data['bankId'] = bankId;
    data['branchName'] = branchName;
    data['businessName'] = businessName;
    data['notificationId'] = notificationId;
    data['time'] = time;
    data['refId'] = refId;
    data['transactionReceiveId'] = transactionReceiveId;
    data['content'] = content;
    data['status'] = status;
    data['transType'] = transType;
    data['audioLink'] = audioLink;
    return data;
  }
}
