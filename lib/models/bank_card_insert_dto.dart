class BankCardInsertDTO {
  final String bankTypeId;
  final String userId;
  final String userBankName;
  final String bankAccount;
  final int type;
  final String branchId;
  final String nationalId;
  final String phoneAuthenticated;

  const BankCardInsertDTO({
    required this.bankTypeId,
    required this.userId,
    required this.userBankName,
    required this.bankAccount,
    required this.type,
    required this.branchId,
    required this.nationalId,
    required this.phoneAuthenticated,
  });

  factory BankCardInsertDTO.fromJson(Map<String, dynamic> json) {
    return BankCardInsertDTO(
      bankTypeId: json['bankTypeId'] ?? '',
      userId: json['userId'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      type: json['type'] ?? 0,
      branchId: json['branchId'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankTypeId'] = bankTypeId;
    data['userId'] = userId;
    data['userBankName'] = userBankName;
    data['bankAccount'] = bankAccount;
    data['type'] = type;
    data['branchId'] = branchId;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    return data;
  }
}
