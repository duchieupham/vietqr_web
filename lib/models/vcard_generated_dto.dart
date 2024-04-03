class VcardGenerateDto {
  final String qr;
  final String fullname;
  final String phoneNo;
  final String email;
  final String companyName;
  final String website;
  final String address;
  const VcardGenerateDto(
      {this.qr = '',
      this.fullname = '',
      this.email = '',
      this.phoneNo = '',
      this.address = '',
      this.companyName = '',
      this.website = ''});

  factory VcardGenerateDto.fromJson(Map<String, dynamic> json) {
    return VcardGenerateDto(
      qr: json['qr'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      address: json['address'] ?? '',
      companyName: json['companyName'] ?? '',
      website: json['website'] ?? '',
    );
  }
}
