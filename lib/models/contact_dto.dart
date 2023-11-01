import 'package:flutter/material.dart';

class ContactDTO {
  String id;
  String nickname;
  int status;
  int type;
  String imgId;
  String description;
  String phoneNo;
  String carrierTypeId;
  int relation;
  Color? bankColor;

  ContactDTO({
    this.id = '',
    this.nickname = '',
    this.status = 0,
    this.type = 0,
    this.imgId = '',
    this.description = '',
    this.phoneNo = '',
    this.carrierTypeId = '',
    this.relation = 0,
    this.bankColor,
  });

  setColor(value) {
    bankColor = value;
  }

  factory ContactDTO.fromJson(Map<String, dynamic> json) => ContactDTO(
        id: json["id"] ?? '',
        nickname: json["nickname"] ?? '',
        status: json["status"] ?? 0,
        type: json["type"] ?? 0,
        imgId: json["imgId"] ?? '',
        description: json["description"] ?? '',
        phoneNo: json["phoneNo"] ?? '',
        carrierTypeId: json["carrierTypeId"] ?? '',
        relation: json["relation"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "status": status,
        "type": type,
        "imgId": imgId,
        "description": description,
        "phoneNo": phoneNo,
        "carrierTypeId": carrierTypeId,
        "relation": relation,
      };
}

class VCardModel {
  final String? fullname;
  final String? phoneNo;
  final String? email;
  final String? companyName;
  final String? website;
  final String? address;
  final String? userId;
  final String? additionalData;

  VCardModel({
    this.fullname,
    this.phoneNo,
    this.email,
    this.companyName,
    this.website,
    this.address,
    this.userId,
    this.additionalData,
  });

  factory VCardModel.fromJson(Map<String, dynamic> json) => VCardModel(
        fullname: json["fullname"],
        phoneNo: json["phoneNo"],
        email: json["email"],
        companyName: json["companyName"],
        website: json["website"],
        address: json["address"],
        userId: json["userId"],
        additionalData: json["additionalData"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phoneNo": phoneNo,
        "email": email,
        "companyName": companyName,
        "website": website,
        "address": address,
        "userId": userId,
        "additionalData": additionalData,
      };
}
