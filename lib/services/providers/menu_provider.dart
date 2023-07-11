import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  bool _isShowMenu = true;
  bool get showMenu => _isShowMenu;
  void updateShowMenu(bool value) {
    _isShowMenu = value;
    notifyListeners();
  }

  MenuHomeType _menuHomeType = MenuHomeType.BANKLIST;
  MenuHomeType get menuHomeType => _menuHomeType;
  void selectMenu(MenuHomeType value) {
    _menuHomeType = value;
    notifyListeners();
  }
}
