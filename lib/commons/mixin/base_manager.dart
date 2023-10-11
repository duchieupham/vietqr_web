import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

///1. quản lý view chung mà 80% các màn dùng: appbar, dialog confirm, button...
///2 lấy thông tin model chung: user
///3. khi dùng 1 lib 80% chỉ dùng ở đây để sau này lib bị bỏ hoặc lỗi => thay cho dễ
mixin BaseManager {
  BuildContext get context;

  // UserRepository get userRes => UserRepository.instance;

  bool get mounted => Navigator.of(context).mounted;

  get alwaysDisabledFocusNode => AlwaysDisabledFocusNode();

// List<BankTypeDTO> get banks => userRes.banks;

// set banks(List<BankTypeDTO> value) => userRes.banks = value;

  String get userId => UserInformationHelper.instance.getUserId();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
