class TransactionInputDTO {
  String bankId;
  int offset;
  int status;
  int type;
  int typeTime;
  String from;
  String to;
  String value;
  String userId;
  String terminalCode;

  TransactionInputDTO({
    this.bankId = '',
    this.offset = 0,
    this.status = 0,
    this.type = 9,
    this.typeTime = 1,
    this.from = '',
    this.to = '',
    this.value = '',
    this.userId = '',
    this.terminalCode = '',
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['offset'] = offset;
    data['terminalCode'] = terminalCode;
    data['status'] = status;
    data['type'] = type;
    data['from'] = from;
    data['to'] = to;
    data['value'] = value;
    return data;
  }
}
