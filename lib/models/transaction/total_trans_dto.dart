import 'package:VietQR/commons/utils/currency_utils.dart';

class TotalTransDTO {
  final int totalTrans;
  final int totalCashIn;
  final int totalSettled;
  final int totalCashSettled;
  final int totalUnsettled;
  final int totalCashUnsettled;
  final int totalTransRefund;
  final int totalCashRefund;

  TotalTransDTO(
      {this.totalTrans = 0,
      this.totalCashIn = 0,
      this.totalSettled = 0,
      this.totalCashSettled = 0,
      this.totalUnsettled = 0,
      this.totalCashUnsettled = 0,
      this.totalCashRefund = 0,
      this.totalTransRefund = 0});

  String get getCashIn =>
      CurrencyUtils.instance.getCurrencyFormatted(totalCashIn.toString());

  String get getCashSettled =>
      CurrencyUtils.instance.getCurrencyFormatted(totalCashSettled.toString());

  String get getCashUnsettled => CurrencyUtils.instance
      .getCurrencyFormatted(totalCashUnsettled.toString());

  String get getCashRefund => CurrencyUtils.instance
      .getCurrencyFormatted(totalCashRefund.toString());

  factory TotalTransDTO.fromJson(Map<String, dynamic> json) => TotalTransDTO(
        totalTrans: json["totalTrans"],
        totalCashIn: json["totalCashIn"],
        totalSettled: json["totalSettled"],
        totalCashSettled: json["totalCashSettled"],
        totalUnsettled: json["totalUnsettled"],
        totalCashUnsettled: json["totalCashUnsettled"],
        totalCashRefund: json["totalCashRefund"],
        totalTransRefund: json["totalTransRefund"],
      );

  Map<String, dynamic> toJson() => {
        "totalTrans": totalTrans,
        "totalCashIn": totalCashIn,
        "totalSettled": totalSettled,
        "totalCashSettled": totalCashSettled,
        "totalUnsettled": totalUnsettled,
        "totalCashUnsettled": totalCashUnsettled,
        "totalCashRefund": totalCashRefund,
        "totalTransRefund": totalTransRefund,
      };
}
