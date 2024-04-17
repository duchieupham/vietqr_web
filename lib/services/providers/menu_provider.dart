import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  String _type = '';
  String get type => _type;

  int _initPage = 0;
  int get initPage => _initPage;

  bool _isShowMenu = true;
  bool get showMenu => _isShowMenu;
  void updateShowMenu(bool value) {
    _isShowMenu = value;
    notifyListeners();
  }

  MenuHomeType _menuHomeType = MenuHomeType.HOME;
  MenuHomeType get menuHomeType => _menuHomeType;

  bool _isAccountIsMerchant = false;
  bool get isAccountIsMerchant => _isAccountIsMerchant;

  void selectType(String select) {
    _type = select;
    notifyListeners();
  }

  void selectMenu(MenuHomeType value) {
    _menuHomeType = value;
    notifyListeners();
  }

  void changePage(MenuHomeType value) {
    if (value == MenuHomeType.HOME) {
      _initPage = 0;
    } else if (value == MenuHomeType.MERCHANT) {
      _initPage = 1;
    }
    // else if (value == MenuHomeType.ADD_LINK_BANK_MB) {
    //   _initPage = 2;
    // }
    else if (value == MenuHomeType.BUSINESS) {
      _initPage = 3;
    } else if (value == MenuHomeType.CREATE_QR) {
      if (Session.instance.accountIsMerchantDTO.customerSyncId.isNotEmpty) {
        _initPage = 5;
      } else {
        _initPage = 3;
      }
    }
  }

  checkAccountIsMerchant() async {
    await Session.instance.checkAccountIsMerchant();
    if (Session.instance.accountIsMerchantDTO.customerSyncId.isNotEmpty) {
      UserInformationHelper.instance.setAccountIsMerchant(true);
      _isAccountIsMerchant = true;
    } else {
      UserInformationHelper.instance.setAccountIsMerchant(false);
      _isAccountIsMerchant = false;
    }
    // notifyListeners();
  }
}
