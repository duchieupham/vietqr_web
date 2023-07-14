import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  bool _validateHosting = false;
  bool get validateHosting => _validateHosting;

  bool _validateEndpoint = false;
  bool get validateEndpoint => _validateEndpoint;

  BankAccountDTO _bankAccountSelected = const BankAccountDTO(
      bankAccount: '',
      id: '',
      userBankName: '',
      bankCode: '',
      bankName: '',
      imgId: '',
      type: 0,
      branchId: '',
      businessId: '',
      branchName: '',
      businessName: '',
      isAuthenticated: false);
  BankAccountDTO get bankAccountSelected => _bankAccountSelected;

  void updateBankAccountSelected(BankAccountDTO value) {
    _bankAccountSelected = value;
    notifyListeners();
  }

  void updateValidEndpoint(bool value) {
    _validateEndpoint = value;
    notifyListeners();
  }

  void updateValidHosting(bool value) {
    _validateHosting = value;
    notifyListeners();
  }

  void reset() {
    _validateHosting = false;
    notifyListeners();
  }
}
