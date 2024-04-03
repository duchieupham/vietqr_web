class BankCardRequestOTP {
  final String nationalId;
  final String accountNumber;
  final String accountName;
  final String applicationType;
  final String phoneNumber;

  const BankCardRequestOTP({
    this.nationalId = '',
    this.accountNumber = '',
    this.accountName = '',
    this.applicationType = '',
    this.phoneNumber = '',
  });

  factory BankCardRequestOTP.fromJson(Map<String, dynamic> json) {
    return BankCardRequestOTP(
      nationalId: json['nationalId'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      applicationType: json['applicationType'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['nationalId'] = nationalId;
    data['accountNumber'] = accountNumber;
    data['accountName'] = accountName;
    data['applicationType'] = applicationType;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
