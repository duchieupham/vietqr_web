// To parse this JSON data, do
//
//     final memberDto = memberDtoFromJson(jsonString);

import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

MemberDTO memberDtoFromJson(String str) => MemberDTO.fromJson(json.decode(str));

class MemberDTO {
  final int page;
  final int size;
  final int totalPage;
  final int totalElement;
  final List<Member> items;

  MemberDTO({
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    this.totalElement = 0,
    this.items = const [],
  });

  factory MemberDTO.fromJson(Map<String, dynamic> json) => MemberDTO(
        page: json["page"] ?? 0,
        size: json["size"] ?? 0,
        totalPage: json["totalPage"] ?? 0,
        totalElement: json["totalElement"] ?? 0,
        items: json["items"] == null
            ? []
            : List<Member>.from(json["items"]!.map((x) => Member.fromJson(x))),
      );
}

class Member {
  final String merchantId;
  final String userId;
  final String level;
  final String phoneNo;
  final String fullName;
  final List<Terminal> terminals;
  final List<TransReceiveRole> transReceiveRoles;
  final List<dynamic> transRefundRoles;
  final String imgId;

  String get nameStore => terminals.isEmpty
      ? 'Tất cả'
      : terminals.length > 2
          ? '${terminals.length} cửa hàng'
          : terminals.length == 1
              ? terminals.first.terminalName
              : '${terminals.first.terminalName} , ${terminals.last.terminalName}';

  double get heightRow => transReceiveRoles.length > 1
      ? (transReceiveRoles.length / 2) * 60
      : transReceiveRoles.length * 50;

  Member({
    this.merchantId = '',
    this.userId = '',
    this.level = '',
    this.phoneNo = '',
    this.fullName = '',
    this.terminals = const [],
    this.transReceiveRoles = const [],
    this.transRefundRoles = const [],
    this.imgId = '',
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        merchantId: json["merchantId"],
        userId: json["userId"],
        level: json["level"],
        phoneNo: json["phoneNo"],
        fullName: json["fullName"],
        terminals: json["terminals"] == null
            ? []
            : List<Terminal>.from(
                json["terminals"]!.map((x) => Terminal.fromJson(x))),
        transReceiveRoles: json["transReceiveRoles"] == null
            ? []
            : List<TransReceiveRole>.from(json["transReceiveRoles"]!
                .map((x) => TransReceiveRole.fromJson(x))),
        transRefundRoles: json["transRefundRoles"] == null
            ? []
            : List<dynamic>.from(json["transRefundRoles"]!.map((x) => x)),
        imgId: json["imgId"],
      );
}

class Terminal {
  final String terminalId;
  final String terminalCode;
  final String terminalName;

  Terminal({
    this.terminalId = '',
    this.terminalCode = '',
    this.terminalName = '',
  });

  factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
        terminalId: json["terminalId"] ?? '',
        terminalCode: json["terminalCode"] ?? '',
        terminalName: json["terminalName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "terminalId": terminalId,
        "terminalCode": terminalCode,
        "terminalName": terminalName,
      };
}

class TransReceiveRole {
  final String? name;
  final String? id;
  final String? description;
  final int? role;
  final int? color;

  TransReceiveRole({
    this.name,
    this.id,
    this.description,
    this.role,
    this.color,
  });

  // color: Màu: 0: blue, 1:green, 2: red

  Color get getColor => color == 0
      ? AppColor.BLUE_TEXT
      : color == 1
          ? AppColor.GREEN
          : AppColor.ORANGE_DARK;

  Color get getBgrColor => color == 0
      ? AppColor.BLUE_TEXT.withOpacity(0.25)
      : color == 1
          ? AppColor.GREEN.withOpacity(0.25)
          : AppColor.ORANGE_DARK.withOpacity(0.25);

  factory TransReceiveRole.fromJson(Map<String, dynamic> json) =>
      TransReceiveRole(
        name: json["name"],
        id: json["id"],
        description: json["description"],
        role: json["role"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "description": description,
        "role": role,
        "color": color,
      };
}
