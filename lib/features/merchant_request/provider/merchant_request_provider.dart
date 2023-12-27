import 'dart:async';

import 'package:VietQR/features/home/repositories/home_repository.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class MerchantRequestProvider with ChangeNotifier {
  String _urlConnect = '';

  String get urlConnect => _urlConnect;
  String _suffixConnect = '';

  String get suffixConnect => _suffixConnect;
  String _ipConnect = '';

  String get ipConnect => _ipConnect;

  String _portConnect = '';

  String get portConnect => _portConnect;

  String _username = '';

  String get username => _username;
  bool _errorUsername = false;

  bool get errorUsername => _errorUsername;

  String _password = '';

  String get password => _password;
  bool _errorPassword = false;

  bool get errorPassword => _errorPassword;

  String _customerName = '';

  String get customerName => _customerName;
  bool _errorCustomerName = false;

  bool get errorCustomerName => _errorCustomerName;

  String _systemUsername = '';

  String get systemUsername => _systemUsername;

  String _systemPassword = '';

  String get systemPassword => _systemPassword;
  String _merchant = '';

  String get merchant => _merchant;
  bool _errorMerchant = false;

  bool get errorMerchant => _errorMerchant;

  String _bankAccount = '';

  String get bankAccount => _bankAccount;
  bool _errorBankAccount = false;

  bool get errorBankAccount => _errorBankAccount;

  String _address = '';

  String get address => _address;
  bool _errorAddress = false;

  bool get errorAddress => _errorAddress;

  String _userBankName = '';

  String get userBankName => _userBankName;
  bool _errorUserBankName = false;

  bool get errorUserBankName => _errorUserBankName;

  TextEditingController accountName = TextEditingController();

  int valueTypeConnect = 0;

  BankAccountDTO _bankAccountDTO = BankAccountDTO();

  BankAccountDTO get bankAccountDTO => _bankAccountDTO;
  List<BankAccountDTO> bankAccounts = [];
  final homeRepository = const HomeRepository();

  int _page = 0;
  int get page => _page;

  changePage(int page) {
    _page = page;
    notifyListeners();
  }

  getListBankAccount() async {
    List<BankAccountDTO> result = await homeRepository
        .getListBankAccount(UserInformationHelper.instance.getUserId());
    result.sort((a, b) {
      if (b.isAuthenticated) {
        return 1;
      }
      return -1;
    });
    bankAccounts = result
        .where((e) => e.userId == UserInformationHelper.instance.getUserId())
        .toList();
  }

  changeTypeConnect(int type) {
    valueTypeConnect = type;
    notifyListeners();
  }

  void changeBankAccount(BankAccountDTO value) {
    _bankAccountDTO = value;
    _errorUserBankName = false;
    notifyListeners();
  }

  void updateMerchant(String value) {
    _merchant = value;
    if (_merchant.isNotEmpty) {
      if (_errorMerchant) {
        _errorMerchant = false;
        notifyListeners();
      }
    } else {
      _errorMerchant = true;
      notifyListeners();
    }
  }

  Timer? _debounce;

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      updateBankAccount(query);
    });
  }

  void updateBankAccount(String value) async {
    _bankAccount = value;
    _errorBankAccount = false;
    if (_bankAccount.isNotEmpty) {
      _errorBankAccount = false;
    } else {
      _errorBankAccount = true;
    }

    notifyListeners();
  }

  void updateAddress(String value) {
    _address = value;
    if (_address.isNotEmpty) {
      _errorAddress = false;
    } else {
      _errorAddress = true;
    }
  }

  void updateUrlConnect(String value) {
    _urlConnect = value;
  }

  void updateUserBankName(String value) {
    _userBankName = value;
    accountName.text = value.trim();
    if (_userBankName.isNotEmpty) {
      _errorUserBankName = false;
    } else {
      _errorUserBankName = true;
    }
    notifyListeners();
  }

  void updateSuffixConnect(String value) {
    _suffixConnect = value;
  }

  void updateIpConnect(String value) {
    _ipConnect = value;
  }

  void updatePortConnect(String value) {
    _portConnect = value;
  }

  void updateUsername(String value) {
    _username = value;
    if (_username.isNotEmpty) {
      _errorUsername = false;
    } else {
      _errorUsername = true;
    }
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    if (_password.isNotEmpty) {
      _errorPassword = false;
    } else {
      _errorPassword = true;
    }
    notifyListeners();
  }

  void updateSystemName(String value) {
    _systemUsername = value;
  }

  void updateSystemPass(String value) {
    _systemPassword = value;
  }

  checkValidate() {
    if (_bankAccountDTO.id.isEmpty) {
      _errorUserBankName = true;
    }
    if (_username.isEmpty) {
      _errorUsername = true;
    }
    if (_password.isEmpty) {
      _errorPassword = true;
    }
    if (_address.isEmpty) {
      _errorAddress = true;
    }
    if (_bankAccountDTO.id.isEmpty) {
      _errorBankAccount = true;
    }
    if (_merchant.isEmpty) {
      _errorMerchant = true;
    }
    notifyListeners();
  }

  bool isValidate() {
    if (_username.isNotEmpty &&
        _password.isNotEmpty &&
        _address.isNotEmpty &&
        _bankAccountDTO.id.isNotEmpty &&
        _merchant.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String getUrl() {
    String suffix = '';
    String url = '';
    if (suffixConnect.isNotEmpty) {
      if (suffixConnect[suffixConnect.length - 1] == '/') {
        suffix = suffixConnect.substring(0, suffixConnect.length - 1);
      } else {
        suffix = suffixConnect;
      }
    }
    if (urlConnect.isNotEmpty) {
      url = urlConnect;
    } else if (ipConnect.isNotEmpty) {
      url = 'http://$ipConnect:$portConnect';
    }

    if (suffix.isNotEmpty) {
      url = '$url/$suffix';
    }
    return url;
  }
}
