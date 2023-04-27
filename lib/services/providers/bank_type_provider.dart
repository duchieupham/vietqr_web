import 'package:VietQR/models/bank_type_dto.dart';
import 'package:flutter/widgets.dart';

class BankTypeProvider with ChangeNotifier {
  BankTypeDTO _bankType = const BankTypeDTO(
    id: '',
    bankCode: '',
    bankName: '',
    imageId: '',
    status: 0,
  );

  bool _isNameErr = false;
  bool _isBankAccountErr = false;
  bool _isNationalErr = false;
  bool _isPhoneErr = false;
  bool _isAgreeWithPolicy = false;

  BankTypeDTO get bankType => _bankType;
  bool get nameErr => _isNameErr;
  bool get bankAccountErr => _isBankAccountErr;
  bool get nationalErr => _isNationalErr;
  bool get phoneErr => _isPhoneErr;
  bool get agreeWithPolicy => _isAgreeWithPolicy;

  void updateAgreePolicy(bool value) {
    _isAgreeWithPolicy = value;
    notifyListeners();
  }

  bool isValidUnauthenticateForm() {
    return (_bankType.id.isNotEmpty && !_isNameErr && !_isBankAccountErr);
  }

  bool isValidAuthenticateForm() {
    return (_bankType.id.isNotEmpty &&
        !_isNameErr &&
        !_isBankAccountErr &&
        !_isNationalErr &&
        !_isPhoneErr);
  }

  void updateBankType(BankTypeDTO value) {
    _bankType = value;
    notifyListeners();
  }

  void updateNameErr(bool value) {
    _isNameErr = value;
    notifyListeners();
  }

  void updateBankAccountErr(bool value) {
    _isBankAccountErr = value;
    notifyListeners();
  }

  void updateNationalErr(bool value) {
    _isNationalErr = value;
    notifyListeners();
  }

  void updatePhoneErr(bool value) {
    _isPhoneErr = value;
    notifyListeners();
  }

  void reset() {
    _bankType = const BankTypeDTO(
      id: '',
      bankCode: '',
      bankName: '',
      imageId: '',
      status: 0,
    );
    _isNameErr = false;
    _isBankAccountErr = false;
    _isNationalErr = false;
    _isPhoneErr = false;
    _isAgreeWithPolicy = false;
  }
}
