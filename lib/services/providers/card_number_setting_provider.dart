import 'package:flutter/material.dart';

class CardNumberSettingProvider with ChangeNotifier {
  int _enterCount = 0;
  String _vietQRId = '';
  String _confirm = '';

  int get enterCount => _enterCount;
  String get vietQRId => _vietQRId;
  String get confirm => _confirm;

  void updateEnterCount(int value) {
    _enterCount = value;
    notifyListeners();
  }

  void updateVietQRId(String value) {
    _vietQRId = value;
    notifyListeners();
  }

  void updateConfirm(String value) {
    _confirm = value;
    notifyListeners();
  }

  void reset() {
    _enterCount = 0;
    _vietQRId = '';
    _confirm = '';
  }
}
