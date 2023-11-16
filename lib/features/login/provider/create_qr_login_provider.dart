import 'package:flutter/material.dart';

class CreateQRLoginProvider with ChangeNotifier {
  bool _showMoreOption = false;
  bool get showMoreOption => _showMoreOption;

  int _page = 0;
  int get page => _page;

  bool _isPhoneNumberErr = false;
  bool get isPhoneNumberErr => _isPhoneNumberErr;

  bool _isNameErr = false;
  bool get isNameErr => _isNameErr;

  bool _isWebsiteErr = false;
  bool get isWebsiteErr => _isWebsiteErr;

  changePage(int value) {
    _page = value;
    notifyListeners();
  }

  updateShowMoreOption(bool value) async {
    _showMoreOption = value;
    notifyListeners();
  }

  void updatePhoneNumberErr(bool value) {
    _isPhoneNumberErr = value;
    notifyListeners();
  }

  void updateWebsiteErr(String value) {
    if (value.contains('https://')) {
      _isWebsiteErr = false;
    } else if (value.contains('http://')) {
      _isWebsiteErr = false;
    } else {
      _isWebsiteErr = true;
    }

    notifyListeners();
  }

  void updateNameErr(bool value) {
    _isNameErr = value;
    notifyListeners();
  }
}
