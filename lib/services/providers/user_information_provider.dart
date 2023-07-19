import 'dart:convert';
import 'dart:typed_data';

import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class UserInformationProvider with ChangeNotifier {
  bool _isAvailableUpdate = false;
  int _gender = UserInformationHelper.instance.getAccountInformation().gender;
  bool _isFirstNameErr = false;
  bool _isValidEmailErr = false;
  bool _isOldPassErr = false;
  bool _isNewPassErr = false;
  bool _isConfirmPassErr = false;
  bool _isValidNationalIdlErr = false;
  bool _isValidOldNationalIdErr = false;
  bool _isValidNationalDateErr = false;

  get availableUpdate => _isAvailableUpdate;
  int get gender => _gender;
  get firstNameErr => _isFirstNameErr;
  get isValidEmailErr => _isValidEmailErr;
  get oldPassErr => _isOldPassErr;
  get newPassErr => _isNewPassErr;
  get confirmPassErr => _isConfirmPassErr;
  get validNationalId => _isValidNationalIdlErr;
  get validOldNationalId => _isValidOldNationalIdErr;
  get validNationalDate => _isValidNationalDateErr;
  Uint8List? _bytesData;
  Uint8List? get bytesData => _bytesData;
  List<int>? _selectedFile;
  List<int>? get selectedFile => _selectedFile;

  void setAvailableUpdate(bool value) {
    _isAvailableUpdate = value;
    notifyListeners();
  }

  void updateGender(int value) {
    _gender = value;
    notifyListeners();
  }

  void updateErrors(bool firstNameErr) {
    _isFirstNameErr = firstNameErr;
    notifyListeners();
  }

  void updateEmailErrors(String email) {
    if (email.isNotEmpty) {
      if (!EmailValidator.validate(email)) {
        _isValidEmailErr = true;
        notifyListeners();
      }
    }
  }

  void updateNationalIdErrors(String nationalId) {
    if (nationalId.isNotEmpty) {
      _isValidEmailErr = true;
      notifyListeners();
    }
  }

  void updatePasswordErrs(
      bool oldPassErr, bool newPassErr, bool confirmPassErr) {
    _isOldPassErr = oldPassErr;
    _isNewPassErr = newPassErr;
    _isConfirmPassErr = confirmPassErr;
    notifyListeners();
  }

  bool isValidUpdatePassword() {
    return !_isOldPassErr && !_isNewPassErr && !_isConfirmPassErr;
  }

  bool isValidUpdate() {
    return !_isFirstNameErr && !_isValidEmailErr;
  }

  void resetPasswordErr() {
    _isOldPassErr = false;
    _isNewPassErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  void reset() {
    _isAvailableUpdate = false;
    _isFirstNameErr = false;
    notifyListeners();
  }
}
