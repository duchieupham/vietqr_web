import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/models/info_user_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool isEnableButton = false;
  bool isButtonLogin = false;
  String phone = '';
  String? errorPhone;

  InfoUserDTO infoUserDTO = InfoUserDTO();
  List<InfoUserDTO> listInfoUsers = [];

  //0: trang login ban đầu
  // 1: trang login gần nhất
  //2 : quickLogin
  int isQuickLogin = 0;

  init() async {
    listInfoUsers = UserInformationHelper.instance.getLoginAccount();

    if (listInfoUsers.isNotEmpty) {
      isQuickLogin = 1;
    }
    notifyListeners();
  }

  void updateListInfoUser(List<String> list) async {
    await UserInformationHelper.instance.setLoginAccount(list);
    listInfoUsers = UserInformationHelper.instance.getLoginAccount();

    notifyListeners();
  }

  Future updateInfoUser(value) async {
    infoUserDTO = value;
    notifyListeners();
  }

  void updateQuickLogin(value) {
    isQuickLogin = value;
    notifyListeners();
  }

  void updateIsEnableBT(value) {
    isEnableButton = value;
    notifyListeners();
  }

  void updateBTLogin(value) {
    isButtonLogin = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value.replaceAll(" ", "");

    if (phone.length == 9) {
      if (phone[0] != '0') {
        phone = '0$phone';
      }
    }
    errorPhone = StringUtils.instance.validatePhone(phone);
    if (errorPhone != null || value.isEmpty) {
      isEnableButton = false;
    } else {
      isEnableButton = true;
    }

    notifyListeners();
  }
}
