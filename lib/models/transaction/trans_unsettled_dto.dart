class TransUnsettledDTO {
  final String? bankId;
  final String? bankAccount;
  final String? bankShortName;
  final String? userBankName;
  final int? amount;
  final String? transType;
  final String? orderId;
  final String? referenceNumber;
  final String? terminalCode;
  final int? timeCreated;
  final int? timePaid;
  final int? status;
  final String? note;
  final String? id;
  final int? type;
  final String? content;

  TransUnsettledDTO({
    this.bankId,
    this.bankAccount,
    this.bankShortName,
    this.userBankName,
    this.amount,
    this.transType,
    this.orderId,
    this.referenceNumber,
    this.terminalCode,
    this.timeCreated,
    this.timePaid,
    this.status,
    this.note,
    this.id,
    this.type,
    this.content,
  });

  factory TransUnsettledDTO.fromJson(Map<String, dynamic> json) =>
      TransUnsettledDTO(
        bankId: json["bankId"],
        bankAccount: json["bankAccount"],
        bankShortName: json["bankShortName"],
        userBankName: json["userBankName"],
        amount: json["amount"],
        transType: json["transType"],
        orderId: json["orderId"],
        referenceNumber: json["referenceNumber"],
        terminalCode: json["terminalCode"],
        timeCreated: json["timeCreated"],
        timePaid: json["timePaid"],
        status: json["status"],
        note: json["note"],
        id: json["id"],
        type: json["type"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "bankId": bankId,
        "bankAccount": bankAccount,
        "bankShortName": bankShortName,
        "userBankName": userBankName,
        "amount": amount,
        "transType": transType,
        "orderId": orderId,
        "referenceNumber": referenceNumber,
        "terminalCode": terminalCode,
        "timeCreated": timeCreated,
        "timePaid": timePaid,
        "status": status,
        "note": note,
        "id": id,
        "type": type,
        "content": content,
      };
}
