import 'package:VietQR/features/home/repositories/home_repository.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class ActiveVhitekProvider with ChangeNotifier {
  int _page = 0;
  int get page => _page;

  String _mid = '';
  String get mid => _mid;

  String _midAddress = '';
  String get midAddress => _midAddress;

  String _email = '';
  String get email => _email;

  String _userName = '';
  String get userName => _userName;

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  String _password = '';
  String get password => _password;

  String _passwordConfirm = '';
  String get passwordConfirm => _passwordConfirm;

  bool _isErrPasswordConfirm = false;
  bool get isErrPasswordConfirm => _isErrPasswordConfirm;

  bool _isErrPassword = false;
  bool get isErrPassword => _isErrPassword;

  String _userIdVhitek = '';
  String get userIdVhitek => _userIdVhitek;

  String _errorPass = '';
  String get errorPass => _errorPass;

  final homeRepository = const HomeRepository();
  BankAccountDTO _bankAccountDTO = BankAccountDTO();
  BankAccountDTO get bankAccountDTO => _bankAccountDTO;

  List<BankAccountDTO> bankAccounts = [];
  bool isLoadingGetListBank = false;
  getListBankAccount() async {
    List<BankAccountDTO> result = await homeRepository
        .getListBankAccount(UserInformationHelper.instance.getUserId());
    bankAccounts = result.where((e) => e.isAuthenticated).toList();
  }

  updateBankAccountDTO(BankAccountDTO value) {
    _bankAccountDTO = value;
    notifyListeners();
  }

  void changePage(int page) {
    _page = page;
    notifyListeners();
  }

  changeUserIdVhitek(String value) {
    _userIdVhitek = value;
  }

  changeMid(String value) {
    _mid = value;
  }

  changeMidAddress(String value) {
    _midAddress = value;
  }

  changeEmail(String value) {
    _email = value;
  }

  changeUserName(String value) {
    _userName = value;
  }

  changePhoneNumber(String value) {
    _phoneNumber = value;
  }

  changePassword(String value) {
    _password = value;
  }

  changePasswordConfirm(String value) {
    _passwordConfirm = value;
  }

  checkErrPassword() {
    if (password.length < 8) {
      _errorPass = 'Mật khẩu ít nhất 8 ký tự';
      _isErrPassword = true;
    } else {
      _isErrPassword = false;
    }

    if (_password != _passwordConfirm) {
      _isErrPasswordConfirm = true;
    } else {
      _isErrPasswordConfirm = false;
    }
    notifyListeners();
  }
}
