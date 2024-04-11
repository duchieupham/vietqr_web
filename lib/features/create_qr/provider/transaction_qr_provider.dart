import 'package:flutter/material.dart';

class TransactionQRProvider with ChangeNotifier {
  int _timeCountDown = 0;
  int get timeCountDown => _timeCountDown;

  bool _isRedirect = false;
  bool get isRedirect => _isRedirect;

  bool _timeExpires = false;
  bool get timeExpires => _timeExpires;

  String _url = '';
  String get url => _url;

  void updateTimeCountDown(int value) {
    if (value > 900000) {
      _timeCountDown = 900000;
    } else {
      _timeCountDown = value;
    }

    notifyListeners();
  }

  void redirectUrl(String value) {
    _url = value;
    if (_url != '' && _url != null)
      _isRedirect = true;
    else
      _isRedirect = false;

    notifyListeners();
  }

  void updateTimeExpires(bool value) {
    _timeExpires = value;
    notifyListeners();
  }
}
