// To parse this JSON data, do
//
//     final memberStoreModel = memberStoreModelFromJson(jsonString);

import 'dart:convert';

List<MemberStoreModel> memberStoreModelFromJson(String str) =>
    List<MemberStoreModel>.from(
        json.decode(str).map((x) => MemberStoreModel.fromJson(x)));

String memberStoreModelToJson(List<MemberStoreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MemberStoreModel {
  final String? id;
  final String? phoneNo;
  final String? fullName;
  final String? imgId;
  final String? role;
  final int? gender;
  final String? nationalId;
  final String? email;
  final String? birthDate;

  MemberStoreModel({
    this.id,
    this.phoneNo,
    this.fullName,
    this.imgId,
    this.role,
    this.gender,
    this.nationalId,
    this.email,
    this.birthDate,
  });

  factory MemberStoreModel.fromJson(Map<String, dynamic> json) =>
      MemberStoreModel(
        id: json["id"],
        phoneNo: json["phoneNo"],
        fullName: json["fullName"],
        imgId: json["imgId"],
        role: json["role"],
        gender: json["gender"],
        nationalId: json["nationalId"],
        email: json["email"],
        birthDate: json["birthDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNo": phoneNo,
        "fullName": fullName,
        "imgId": imgId,
        "role": role,
        "gender": gender,
        "nationalId": nationalId,
        "email": email,
        "birthDate": birthDate,
      };
}
