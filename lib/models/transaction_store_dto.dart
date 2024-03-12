import 'dart:convert';

import 'package:intl/intl.dart';

List<TransactionStoreDTO> transactionStoreDtoFromJson(String str) =>
    List<TransactionStoreDTO>.from(
        json.decode(str).map((x) => TransactionStoreDTO.fromJson(x)));

String transactionStoreDtoToJson(List<TransactionStoreDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionStoreDTO {
  final String? transactionId;
  final int? amount;
  final String? bankAccount;
  final String? bankName;
  final String? bankShortName;
  final String? bankCode;
  final String? content;
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
      .format(DateTime.fromMillisecondsSinceEpoch(time ?? 0 * 1000));

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

  TransactionStoreDTO({
    this.transactionId,
    this.amount,
    this.bankAccount,
    this.bankName,
    this.bankShortName,
    this.bankCode,
    this.content,
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
        transactionId: json["transactionId"],
        amount: json["amount"],
        bankAccount: json["bankAccount"],
        bankName: json["bankName"],
        bankShortName: json["bankShortName"],
        bankCode: json["bankCode"],
        content: json["content"],
        time: json["time"],
        timePaid: json["timePaid"],
        status: json["status"],
        type: json["type"],
        note: json["note"],
        referenceNumber: json["referenceNumber"],
        orderId: json["orderId"],
        terminalCode: json["terminalCode"],
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
