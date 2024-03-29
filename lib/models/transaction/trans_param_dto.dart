import 'package:VietQR/features/transaction/states/transaction_state.dart';

class TransParamDTO {
  String? bankId;
  int? offset;
  int? status;
  int? typeFilter;
  int? timeType;
  DateTime? from;
  DateTime? to;
  String? value;
  String? userId;
  String? terminalCode;

  TransParamDTO({
    this.bankId = '',
    this.offset = 0,
    this.status = 0,
    this.typeFilter = 9,
    this.timeType = 0,
    this.from,
    this.to,
    this.value = '',
    this.userId = '',
    this.terminalCode = '',
  });

  String get timeKey => timeType != null ? timeType!.timeKeyExt.name : '';

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['offset'] = offset;
    data['terminalCode'] = terminalCode;
    data['status'] = status;
    data['type'] = typeFilter;
    data['from'] = from;
    data['to'] = to;
    data['value'] = value;
    return data;
  }
}
