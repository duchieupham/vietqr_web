import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/services/shared_references/session.dart';
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
    } else if (value == MenuHomeType.MERCHANT) {
      _initPage = 1;
    } else if (value == MenuHomeType.ADD_LINK_BANK_ACCOUNT) {
      if(Session.instance.accountIsMerchantDTO.customerSyncId.isNotEmpty){
        _initPage = 2;
      }else{
        _initPage = 1;
      }

    } else if (value == MenuHomeType.ADD_LINK_BANK_MB) {
      if(Session.instance.accountIsMerchantDTO.customerSyncId.isNotEmpty){
        _initPage = 3;
      }else{
        _initPage = 2;
      }

    } else if (value == MenuHomeType.BUSINESS) {
      if(Session.instance.accountIsMerchantDTO.customerSyncId.isNotEmpty){
        _initPage = 4;
      }else{
        _initPage = 3;
      }
    } else if (value == MenuHomeType.CREATE_QR) {
      if(Session.instance.accountIsMerchantDTO.customerSyncId.isNotEmpty){
        _initPage = 5;
      }else{
        _initPage = 3;
      }
    }
  }
}
