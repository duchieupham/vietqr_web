import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class TransactionMerchantDTO {
  final String bankId;
  final String bankAccount;
  final String bankShortName;
  final String userBankName;
  final int amount;
  final String transType;
  final String orderId;
  final String referenceNumber;
  final int timePaid;
  final int timeCreated;
  final int status;
  final String id;
  final int type;
  final String content;
  String note;
  bool isEdit;

  TransactionMerchantDTO({
    this.amount = 0,
    this.bankAccount = '',
    this.bankId = '',
    this.bankShortName = '',
    this.content = '',
    this.id = '',
    this.orderId = '',
    this.referenceNumber = '',
    this.status = 0,
    this.timeCreated = 0,
    this.timePaid = 0,
    this.transType = '',
    this.note = '',
    this.type = 0,
    this.userBankName = '',
    this.isEdit = false,
  });

  factory TransactionMerchantDTO.fromJson(Map<String, dynamic> json) {
    return TransactionMerchantDTO(
      amount: json['amount'] ?? 0,
      bankAccount: json['bankAccount'] ?? '',
      bankId: json['bankId'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      content: json['content'] ?? '',
      id: json['id'] ?? false,
      orderId: json['orderId'] ?? '',
      referenceNumber: json['referenceNumber'],
      status: json['status'] ?? 0,
      timeCreated: json['timeCreated'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      transType: json['transType'] ?? '',
      type: json['type'] ?? 0,
      userBankName: json['userBankName'] ?? '',
      note: json['note'] ?? '',
      isEdit: false,
    );
  }

  Color getAmountColor() {
    // if (status == 0) {
    //   return DefaultTheme.ORANGE;
    // } else

    if (transType == 'C') {
      if (status == 0) {
        return AppColor.ORANGE;
      } else if (status == 1) {
        if (type == 0 || type == 1 || type == 4 || type == 5) {
          return AppColor.GREEN;
        } else if (type == 2) {
          return AppColor.BLUE_TEXT;
        }
        return AppColor.BLUE_TEXT;
      } else if (status == 3) {
        return AppColor.YELLOW_TEXT;
      } else if (status == 4) {
        return AppColor.PURPLE_TEXT;
      } else {
        return AppColor.GREY_TEXT;
      }
    } else {
      return AppColor.RED_TEXT;
    }
  }

  String getStatus() {
    if (status == 0) {
      return 'Chờ thanh toán';
    } else if (status == 1) {
      return 'Thành công';
    } else if (status == 3) {
      return 'Đang xử lý';
    } else if (status == 4) {
      return 'Lỗi';
    } else {
      return 'Đã huỷ';
    }
  }

  Color getStatusColor() {
    if (status == 0) {
      return AppColor.ORANGE;
    } else if (status == 1) {
      return AppColor.BLUE_TEXT;
    } else {
      return AppColor.BLACK;
    }
  }

  String getTitleType() {
    if (type == 0) {
      return 'VietQR động';
    } else if (type == 1) {
      return 'VietQR tĩnh';
    } else {
      return 'Khác';
    }
  }
}
