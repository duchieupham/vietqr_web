import 'package:flutter/material.dart';

class AddBankProvider with ChangeNotifier {
  int _timeCountDown = 0;
  int get timeCountDown => _timeCountDown;

  bool _timeExpires = false;
  bool get timeExpires => _timeExpires;
  void updateTimeCountDown(int value) {
    if (value > 900000) {
      _timeCountDown = 900000;
    } else {
      _timeCountDown = value;
    }

    notifyListeners();
  }

  void updateTimeExpires(bool value) {
    _timeExpires = value;
    notifyListeners();
  }
}
