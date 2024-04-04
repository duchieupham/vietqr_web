// To parse this JSON data, do
//
//     final settingAccountDto = settingAccountDtoFromJson(jsonString);

import 'dart:convert';

SettingAccountDTO settingAccountDtoFromJson(String str) =>
    SettingAccountDTO.fromJson(json.decode(str));

String settingAccountDtoToJson(SettingAccountDTO data) =>
    json.encode(data.toJson());

// category:
// 1: tính năng xem GD đã được map cửa hàng theo cấp (toàn bộ, trực thuộc)
// 2: tính năng xem GD chưa xác nhận theo cấp (được duyệt các yêu cầu, yêu cầu duyệt map vào cửa hàng)
// 3: tính năng xuất Excel theo cấp (toàn bộ, trực thuộc)

class SettingAccountDTO {
  final String id;
  final String userId;
  final bool guideWeb;
  final bool guideMobile;
  final bool voiceWeb;
  final bool voiceMobile;
  final bool voiceMobileKiot;
  final bool status;
  final String edgeImgId;
  final String footerImgId;
  final int themeType;
  final dynamic themeImgUrl;
  final String logoUrl;
  final bool keepScreenOn;
  final int qrShowType;
  final List<MerchantRole> merchantRoles;

  SettingAccountDTO({
    this.id = '',
    this.userId = '',
    this.guideWeb = false,
    this.guideMobile = false,
    this.voiceWeb = false,
    this.voiceMobile = false,
    this.voiceMobileKiot = false,
    this.status = false,
    this.edgeImgId = '',
    this.footerImgId = '',
    this.themeType = 0,
    this.themeImgUrl,
    this.logoUrl = '',
    this.keepScreenOn = false,
    this.qrShowType = 0,
    this.merchantRoles = const [],
  });

  factory SettingAccountDTO.fromJson(Map<String, dynamic> json) =>
      SettingAccountDTO(
        id: json["id"] ?? '',
        userId: json["userId"] ?? '',
        guideWeb: json["guideWeb"] ?? false,
        guideMobile: json["guideMobile"] ?? false,
        voiceWeb: json["voiceWeb"] ?? false,
        voiceMobile: json["voiceMobile"] ?? false,
        voiceMobileKiot: json["voiceMobileKiot"] ?? false,
        status: json["status"] ?? false,
        edgeImgId: json["edgeImgId"] ?? '',
        footerImgId: json["footerImgId"] ?? '',
        themeType: json["themeType"] ?? 0,
        themeImgUrl: json["themeImgUrl"] ?? '',
        logoUrl: json["logoUrl"] ?? '',
        keepScreenOn: json["keepScreenOn"] ?? false,
        qrShowType: json["qrShowType"] ?? 0,
        merchantRoles: (json["merchantRoles"] as List)
            .map((e) => MerchantRole.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "guideWeb": guideWeb,
        "guideMobile": guideMobile,
        "voiceWeb": voiceWeb,
        "voiceMobile": voiceMobile,
        "voiceMobileKiot": voiceMobileKiot,
        "status": status,
        "edgeImgId": edgeImgId,
        "footerImgId": footerImgId,
        "themeType": themeType,
        "themeImgUrl": themeImgUrl,
        "logoUrl": logoUrl,
        "keepScreenOn": keepScreenOn,
        "qrShowType": qrShowType,
        "merchantRoles":
            List<dynamic>.from(merchantRoles.map((x) => x.toJson())),
      };
}

class MerchantRole {
  final String merchantId;
  final String bankId;
  final List<Role> roles;
  // final List<int> categories;
  // final List<int> roles;

  MerchantRole({
    this.merchantId = '',
    this.bankId = '',
    this.roles = const [],
    // this.categories = const [],
    // this.roles = const [],
  });

  bool get isAdmin => roles.any((role) => role.category == 0 && role.role == 0);

  bool get isUnclassified => roles
      .any((role) => role.category == 2 && (role.role == 2 || role.role == 4));

  bool get isAllTab =>
      roles.any((role) => role.category == 2 && role.role == 2);

  bool get disableTab =>
      roles.isNotEmpty &&
      roles[0].category == 2 &&
      (roles[0].role == 4 || roles[0].role == 2);

  bool get isUpdateTrans => roles.any((role) => role.category == 2);

  bool get isUpdateTransRequest => roles.contains(4);

  factory MerchantRole.fromJson(Map<String, dynamic> json) => MerchantRole(
        merchantId: json["merchantId"] ?? '',
        bankId: json["bankId"] ?? '',
        roles: (json["roles"] as List).map((e) => Role.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "bankId": bankId,
        // "vouchers": vouchers != null
        //     ? vouchers?.map((voucher) => voucher.voucherCode)?.toList()
        //     : null,
        "roles": roles,
      };
}

class Role {
  final int category;
  final int role;

  Role({
    this.category = 0,
    this.role = 0,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        category: json["category"] ?? 0,
        role: json["role"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "role": role,
      };
}
