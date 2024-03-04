import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/models/bank_account_dto.dart';

class StoreDetailDTO {
  final String id;
  final String name;
  final String address;
  final String code;
  final int totalTrans;
  final int totalAmount;
  final int revGrowthPrevDate;
  final int revGrowthPrevMonth;
  final BankAccountDTO bank;

  StoreDetailDTO({
    this.id = '',
    this.name = '',
    this.address = '',
    this.code = '',
    this.totalTrans = 0,
    this.totalAmount = 0,
    this.revGrowthPrevDate = 0,
    this.revGrowthPrevMonth = -1,
    required this.bank,
  });

  String get amount =>
      CurrencyUtils.instance.getCurrencyFormatted(totalAmount.toString());

  factory StoreDetailDTO.fromJson(Map<String, dynamic> json) => StoreDetailDTO(
        id: json["id"] ?? '',
        name: json["name"] ?? '-',
        address: json["address"] ?? '-',
        code: json["code"] ?? '-',
        totalTrans: json["totalTrans"] ?? 0,
        totalAmount: json["totalAmount"] ?? 0,
        revGrowthPrevDate: json["revGrowthPrevDate"] ?? 0,
        revGrowthPrevMonth: json["revGrowthPrevMonth"] ?? 0,
        bank: json["bank"] == null
            ? BankAccountDTO()
            : BankAccountDTO.fromJson(json['bank']),
      );
}
