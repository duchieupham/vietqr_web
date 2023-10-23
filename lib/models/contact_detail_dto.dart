import 'package:flutter/material.dart';

class ContactDetailDTO {
  final String id;
  final String nickname;
  final String value;
  final String additionalData;
  final int type;
  final int status;
  final String bankShortName;
  final String bankName;
  final String imgId;
  final String bankAccount;
  final int colorType;
  final int relation;
  final String email;
  final String address;
  final String company;
  final String website;
  final String phoneNo;

  ContactDetailDTO({
    this.id = '',
    this.nickname = '',
    this.value = '',
    this.additionalData = '',
    this.type = 0,
    this.status = 0,
    this.bankShortName = '',
    this.bankName = '',
    this.imgId = '',
    this.bankAccount = '',
    this.colorType = 0,
    this.relation = 0,
    this.email = '',
    this.address = '',
    this.company = '',
    this.website = '',
    this.phoneNo = '',
  });

  factory ContactDetailDTO.fromJson(Map<String, dynamic> json) =>
      ContactDetailDTO(
        id: json["id"] ?? '',
        nickname: json["nickname"] ?? '',
        value: json["value"] ?? '',
        additionalData: json["additionalData"] ?? '',
        type: json["type"] ?? 0,
        status: json["status"] ?? 0,
        bankShortName: json["bankShortName"] ?? '',
        bankName: json["bankName"] ?? '',
        imgId: json["imgId"] ?? '',
        bankAccount: json["bankAccount"] ?? '',
        colorType: json["colorType"] ?? 0,
        relation: json["relation"] ?? 0,
        email: json["email"] ?? '',
        address: json["address"] ?? '',
        company: json["company"] ?? '',
        website: json["website"] ?? '',
        phoneNo: json["phoneNo"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "note": additionalData,
        "colorType": colorType.toString(),
        "address": address,
        "company": company,
        "email": email,
        "phoneNo": phoneNo,
        "website": website,
        "imgId": imgId,
      };

  Gradient getBgGradient() {
    switch (colorType) {
      case 0:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 1:
        return LinearGradient(
          colors: [
            const Color(0xFF52FBFF),
            const Color(0xFF06711B),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 2:
        return LinearGradient(
          colors: [
            const Color(0xFFEECDFF),
            const Color(0xFF49558A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 3:
        return LinearGradient(
          colors: [
            const Color(0xFFFBAE1F),
            const Color(0xFFFC6A01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 4:
        return LinearGradient(
          colors: [
            const Color(0xFFFF6DC6),
            const Color(0xFFF8837A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
