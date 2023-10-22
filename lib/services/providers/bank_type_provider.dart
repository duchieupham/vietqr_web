import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:flutter/widgets.dart';

class BankTypeProvider with ChangeNotifier {
  String _money = '';

  String get money => _money;
  void updateMoney(String value) {
    int data = int.parse(value.replaceAll('.', ''));
    _money = StringUtils.formatNumber(data);
    notifyListeners();
  }

  BankTypeDTO _bankType = const BankTypeDTO(
    id: '',
    bankCode: '',
    bankName: '',
    bankShortName: '',
    imageId: '',
    status: 0,
    caiValue: '',
  );

  BankCardRequestOTP bankCardRequestOTP = const BankCardRequestOTP();
  String requestId = '';
  String bankAccount = '';
  String name = '';
  String phone = '';
  String nationalId = '';

  bool _isNameErr = false;
  bool _isBankAccountErr = false;
  bool _isNationalErr = false;
  bool _isPhoneErr = false;
  bool _isAgreeWithPolicy = false;
  bool _isShowBankAccount = true;
  bool _isAmountErr = false;
  bool _isValidCreate = true;

  BankTypeDTO get bankType => _bankType;
  bool get nameErr => _isNameErr;
  bool get bankAccountErr => _isBankAccountErr;
  bool get nationalErr => _isNationalErr;
  bool get phoneErr => _isPhoneErr;
  bool get agreeWithPolicy => _isAgreeWithPolicy;
  bool get showBankAccount => _isShowBankAccount;
  bool get isAmountErr => _isAmountErr;
  bool get isValidCreate => _isValidCreate;

  void updateBankCardRequestOTP(BankCardRequestOTP dto) {
    bankCardRequestOTP = dto;
  }

  void updateRequestId(String value) {
    requestId = value;
  }

  void updateBankAccount(String value) {
    bankAccount = value;
  }

  void updateName(String value) {
    name = value;
  }

  void updatePhone(String value) {
    phone = value;
  }

  void updateNationalId(String value) {
    nationalId = value;
  }

  void updateShowBankAccount(bool value) {
    _isShowBankAccount = value;
    notifyListeners();
  }

  void updateValidCreate(bool value) {
    _isValidCreate = value;
    notifyListeners();
  }

  void updateAgreePolicy(bool value) {
    _isAgreeWithPolicy = value;
    notifyListeners();
  }

  bool isValidUnauthenticateForm() {
    return (_bankType.bankCode.isNotEmpty && !_isNameErr && !_isBankAccountErr);
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

  void updateAmountErr(bool value) {
    _isAmountErr = value;
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
      bankShortName: '',
      imageId: '',
      status: 0,
      caiValue: '',
    );
    _isNameErr = false;
    _isBankAccountErr = false;
    _isNationalErr = false;
    _isPhoneErr = false;
    _isAgreeWithPolicy = false;
  }
}
