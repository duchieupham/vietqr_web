import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransReceiveDTO {
  final String bankAccount;
  final String amount;
  final int status;
  final int time;
  final int timePaid;
  final String content;
  final String transactionId;
  final int type;
  final String transType;
  String terminalCode;
  String note;
  final String referenceNumber;
  final String orderId;
  final String bankShortName;

  TransReceiveDTO({
    this.bankAccount = '',
    this.amount = '',
    this.status = 0,
    this.time = 0,
    this.timePaid = 0,
    this.content = '',
    this.transactionId = '',
    this.type = 0,
    this.transType = '',
    this.terminalCode = '',
    this.note = '',
    this.referenceNumber = '',
    this.orderId = '',
    this.bankShortName = '',
  });

  // api update terminalCode (chỉ enable khi is_owner = true và type = 2, transType = C, status = 1):
  bool get isEnableTerminal {
    return type == 2 || transType.trim() == 'C' || status == 1;
  }

  bool get isTimeTT {
    if (transType.trim() == 'D' ||
        (transType.trim() == 'C' &&
            (status == 1 &&
                (type == 0 ||
                    type == 1 ||
                    type == 2 ||
                    type == 4 ||
                    type == 5)))) {
      return true;
    }
    return false;
  }

  String get transactionType => type == 1
      ? 'QR cửa hàng'
      : type == 2
          ? 'QR giao dịch'
          : 'Khác';

  String get timeCreate => DateFormat('HH:mm:ss\ndd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  String get timePayment => DateFormat('HH:mm:ss\ndd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(timePaid * 1000));

  String get timeCreateEditNote => DateFormat('HH:mm:ss dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  String get timePaymentEditNote => DateFormat('HH:mm:ss dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(timePaid * 1000));

  bool get isTimeCreate {
    if (transType.trim() == 'C' && (status == 2 || status == 0 || type == 0)) {
      return true;
    }
    return false;
  }

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

  String get getStatusString {
    String result = '';
    if (status == 0) {
      result = 'Chờ thanh toán';
    } else if (status == 1) {
      result = 'Thành công';
    } else if (status == 3) {
      result = 'Thất bại';
    } else {
      result = 'Đã huỷ';
    }
    return result;
  }

  String get statusAmount {
    if (transType.trim() == 'D') {
      return '-';
    }
    return '+';
  }

  factory TransReceiveDTO.fromJson(Map<String, dynamic> json) {
    return TransReceiveDTO(
      bankAccount: json['bankAccount'] ?? '',
      amount: json['amount'] != null
          ? (json['amount'] is int)
              ? json['amount'].toString()
              : json['amount']
          : '',
      status: json['status'] ?? 0,
      time: json.containsKey('time')
          ? (json["time"] ?? 0)
          : json.containsKey('timeCreated')
              ? (json["timeCreated"] ?? 0)
              : 0,
      timePaid: json['timePaid'] ?? 0,
      content: json['content'] ?? '',
      transactionId: json['transactionId'] ?? '',
      type: json['type'] ?? 0,
      transType: json['transType'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      orderId: json['orderId'] ?? '',
      note: json['note'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankAccount'] = bankAccount;
    data['amount'] = amount;
    data['status'] = status;
    data['time'] = time;
    data['timePaid'] = timePaid;
    data['content'] = content;
    data['transactionId'] = transactionId;
    data['transType'] = transType;
    return data;
  }
}
