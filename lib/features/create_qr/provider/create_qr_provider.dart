import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/bank_account_dto.dart';

class CreateQRProvider with ChangeNotifier {
  bool _isAmountErr = false;
  bool _isValidCreate = false;
  String _transactionAmount = '0';
  String _currencyFormatted = '0';
  String money = StringUtils.formatNumber(0);
  final NumberFormat numberFormat = NumberFormat("##,#0", "en_US");
  static const _locale = 'en';

  bool get amountErr => _isAmountErr;
  bool get isValidCreate => _isValidCreate;
  String get transactionAmount => _transactionAmount;
  String get currencyFormatted => _currencyFormatted;

  BankAccountDTO _bankAccountDTO = BankAccountDTO();
  BankAccountDTO get bankAccountDTO => _bankAccountDTO;

  String bankId = '';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');

  void updateValidCreate(bool value) {
    _isValidCreate = value;
    notifyListeners();
  }

  void updateAmountErr(bool value) {
    _isAmountErr = value;
    notifyListeners();
  }

  void updateTransactionAmount(String value) {
    if (_transactionAmount.length <= 9) {
      _transactionAmount += value;
      updateCurrencyFormat(_transactionAmount);
      notifyListeners();
    }
  }

  void updateBankAccountDto(BankAccountDTO value) {
    _bankAccountDTO = value;
    voidChooseBank(_bankAccountDTO.id);
  }

  voidChooseBank(String id) {
    bankId = id;
    notifyListeners();
  }

  void updateMoney(String value) {
    if (value.isNotEmpty) {
      int data = int.parse(value.replaceAll(',', ''));

      money = StringUtils.formatNumber(data);
    } else {
      money = value;
    }
  }

  void updateMoneyFormCalculator(String value) {
    if (value.isNotEmpty) {
      int data = int.parse(value.replaceAll(',', ''));

      money = StringUtils.formatNumber(data);
    } else {
      money = value;
    }
    notifyListeners();
  }

  void updateCurrencyFormat(String value) {
    if (value.isNotEmpty && value.characters.first == '0') {
      value = value.substring(1);
      _transactionAmount = _transactionAmount.substring(1);
    }
    if (value.isEmpty) {
      _currencyFormatted = '0';
    } else if (value.length > 3) {
      _currencyFormatted = _formatNumber(value.replaceAll(',', ''));
    } else {
      _currencyFormatted = value;
    }

    notifyListeners();
  }

  void reset() {
    _isAmountErr = false;
    _isValidCreate = false;
    _transactionAmount = '0';
    _currencyFormatted = '0';
    notifyListeners();
  }
}
