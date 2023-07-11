import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
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
  void selectMenu(MenuHomeType value) {
    _menuHomeType = value;
    changePage(value);
    notifyListeners();
  }

  void changePage(MenuHomeType value) {
    if (value == MenuHomeType.HOME) {
      _initPage = 0;
    } else if (value == MenuHomeType.ADD_LINK_BANK_ACCOUNT ||
        value == MenuHomeType.ADD_LINK_BANK_MB) {
      _initPage = 1;
    } else if (value == MenuHomeType.BUSINESS) {
      _initPage = 2;
    }
  }
}
