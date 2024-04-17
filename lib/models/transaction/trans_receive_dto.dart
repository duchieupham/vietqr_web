import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDTO {
  final int? page;
  final int? size;
  final int? totalPage;
  final int? totalElement;
  final List<TransReceiveDTO> items;

  TransactionDTO({
    this.page,
    this.size,
    this.totalPage,
    this.totalElement,
    this.items = const [],
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) => TransactionDTO(
        page: json["page"] ?? 0,
        size: json["size"] ?? 0,
        totalPage: json["totalPage"] ?? 0,
        totalElement: json["totalElement"] ?? 0,
        items: json["items"] == null
            ? []
            : List<TransReceiveDTO>.from(
                json["items"]!.map((x) => TransReceiveDTO.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "size": size,
        "totalPage": totalPage,
        "totalElement": totalElement,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

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
  String terminalName;
  String note;
  final String referenceNumber;
  final String orderId;
  final String bankShortName;
  final String id;
  final String bankId;
  final int timeCreated;
  final String userBankName;
  final int totalRequest;
  List<TransRequest> requests;

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
    this.terminalName = '',
    this.note = '',
    this.referenceNumber = '',
    this.orderId = '',
    this.bankShortName = '',
    this.id = '',
    this.bankId = '',
    this.timeCreated = 0,
    this.userBankName = '',
    this.totalRequest = 0,
    this.requests = const [],
  });

  double get heightRequest => requests.isEmpty ? 50 : requests.length * 50;

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

  String get transactionType {
    if (type == 0 || type == 4 || type == 5) {
      return 'QR giao dịch';
    } else if (type == 1) {
      return 'QR cửa hàng';
    } else {
      return 'Khác';
    }
  }

  String get timeCreate => time == 0
      ? '-'
      : DateFormat('HH:mm:ss\ndd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  String get timePayment => timePaid == 0
      ? '-'
      : DateFormat('HH:mm:ss\ndd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(timePaid * 1000));

  String get timeCreateEditNote => time == 0
      ? '-'
      : DateFormat('HH:mm:ss dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  String get timePaymentEditNote => timePaid == 0
      ? '-'
      : DateFormat('HH:mm:ss dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(timePaid * 1000));

  bool get isTimeCreate {
    if (transType.trim() == 'C' && (status == 2 || status == 0 || type == 0)) {
      return true;
    }
    return false;
  }

  Color get getColorStatus {
    if (transType.trim() == 'D') return AppColor.RED_CALENDAR;

    if (status == 0) return AppColor.ORANGE;

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
      transactionId: json.containsKey('transactionId')
          ? (json['transactionId'] ?? '')
          : json.containsKey('id')
              ? (json['id'] ?? '')
              : '',
      type: json['type'] ?? 0,
      transType: json['transType'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      orderId: json['orderId'] ?? '',
      note: json['note'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      terminalName: json['terminalName'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
      id: json["id"] ?? '',
      bankId: json["bankId"] ?? '',
      timeCreated: json["timeCreated"] ?? 0,
      userBankName: json["userBankName"] ?? '',
      totalRequest: json["totalRequest"] ?? 0,
      requests: json["requests"] == null
          ? []
          : List<TransRequest>.from(
              json["requests"]!.map((x) => TransRequest.fromJson(x))),
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

class TransRequest {
  final String fullName;
  final int requestType;
  final String userId;
  final String merchantId;
  final String terminalId;
  final String merchantName;
  final String transactionId;
  final String requestId;
  final String phoneNumber;
  final String terminalName;
  final String terminalCode;
  int status;

  TransRequest({
    this.fullName = '',
    this.requestType = 0,
    this.userId = '',
    this.merchantId = '',
    this.terminalId = '',
    this.merchantName = '',
    this.transactionId = '',
    this.requestId = '',
    this.phoneNumber = '',
    this.terminalName = '',
    this.terminalCode = '',
    this.status = 0,
  });

  String get nameRequest =>
      'Xác nhận GD thuộc cửa hàng $terminalName ${terminalCode.isNotEmpty ? '($terminalCode)' : ''}';

  factory TransRequest.fromJson(Map<String, dynamic> json) => TransRequest(
        fullName: json["fullName"] ?? '',
        requestType: json["requestType"] ?? 0,
        userId: json["userId"] ?? '',
        merchantId: json["merchantId"] ?? '',
        terminalId: json["terminalId"] ?? '',
        merchantName: json["merchantName"] ?? '',
        transactionId: json["transactionId"] ?? '',
        terminalCode: json["requestValue"] ?? '',
        requestId: json["requestId"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        terminalName: json["terminalName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "requestType": requestType,
        "userId": userId,
        "merchantId": merchantId,
        "terminalId": terminalId,
        "merchantName": merchantName,
        "transactionId": transactionId,
        "requestValue": terminalCode,
        "requestId": requestId,
        "phoneNumber": phoneNumber,
        "terminalName": terminalName,
      };
}
