import 'package:flutter/material.dart';

class ECOMRegisterProvider with ChangeNotifier {
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;
  bool _isDomainErr = false;

  get phoneErr => _isPhoneErr;
  get passwordErr => _isPasswordErr;
  get confirmPassErr => _isConfirmPassErr;
  get domainErr => _isDomainErr;

  void updateErrs({
    required bool phoneErr,
    required bool passErr,
    required bool confirmPassErr,
    required bool domainErr,
  }) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;
    _isDomainErr = domainErr;
    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr &&
        !_isPasswordErr &&
        !_isConfirmPassErr &&
        !_isDomainErr;
  }

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
    _isDomainErr = false;
    notifyListeners();
  }
}
