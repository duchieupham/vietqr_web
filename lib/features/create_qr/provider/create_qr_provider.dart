import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/bank_account_dto.dart';

class CreateQRProvider with ChangeNotifier {
  bool _isAmountErr = false;
  bool _isValidCreate = false;
  bool _isBankAccountErr = false;
  bool _isNameErr = false;

  String _transactionAmount = '0';
  String _currencyFormatted = '0';
  String money = StringUtils.formatNumber(0);
  final NumberFormat numberFormat = NumberFormat("##,#0", "en_US");
  static const _locale = 'en';

  bool get amountErr => _isAmountErr;
  bool get isValidCreate => _isValidCreate;
  String get transactionAmount => _transactionAmount;
  String get currencyFormatted => _currencyFormatted;

  bool get nameErr => _isNameErr;
  bool get bankAccountErr => _isBankAccountErr;

  TerminalQRDTO? selectTerminal;
  List<TerminalQRDTO>? listTerminal = [];
  String? inputTerminal = '';

  BankAccountDTO? bankAccountDTO;
  List<BankAccountDTO> bankAccounts = [];
  List<BankAccountDTO> filterBanks = [];
  List<BankTypeDTO> listBankType = [];
  List<BankTypeDTO> filterBankType = [];
  BankTypeDTO? selectBankType;

  bool isFilter = false;

  String bankId = '';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');

  bool showFormBankAccountOther = false;
  void selectTer(TerminalQRDTO ter) {
    selectTerminal = ter;
    notifyListeners();
  }

  void inputTer(String? value) {
    inputTerminal = value;
    notifyListeners();
  }

  void updateTerminals(List<TerminalQRDTO> list) {
    listTerminal = [
      TerminalQRDTO(
          terminalCode: '0', terminalName: 'Nhập hoặc chọn mã cửa hàng'),
      ...list
    ];
    selectTerminal = listTerminal?.first;
    notifyListeners();
  }

  void filterBankList(String? filter) {
    if (filter!.isNotEmpty) {
      isFilter = true;
      filterBanks = bankAccounts
          .where((e) =>
              e.bankAccount.toLowerCase().contains(filter.toLowerCase()) ||
              e.userBankName.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      isFilter = false;
    }
    notifyListeners();
  }

  void clear() {
    selectTerminal = TerminalQRDTO(
        terminalCode: '0', terminalName: 'Nhập hoặc chọn mã cửa hàng');
    bankAccountDTO = null;
    // notifyListeners();
  }

  void selectBank(BankAccountDTO value) {
    bankAccountDTO = value;
    notifyListeners();
  }

  void updateBankList(List<BankAccountDTO> list) {
    bankAccounts = list;
    notifyListeners();
  }

  void bankTypeSelect(BankTypeDTO dto) {
    selectBankType = dto;
    notifyListeners();
  }

  void bankTypeFilter(String? filter) {
    if (filter!.isNotEmpty) {
      isFilter = true;
      filterBankType = listBankType
          .where(
            (e) =>
                e.bankShortName.toLowerCase().contains(filter.toLowerCase()) ||
                e.bankCode.toLowerCase().contains(filter.toLowerCase()) ||
                e.bankName.toLowerCase().contains(filter.toLowerCase()),
          )
          .toList();
    } else {
      isFilter = false;
    }
    notifyListeners();
  }

  void updateBankTypeList(List<BankTypeDTO> list) {
    listBankType = list;
    notifyListeners();
  }

  void updateValidCreate(bool value) {
    _isValidCreate = value;
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

  void updateForm(bool value) {
    showFormBankAccountOther = value;
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

  // void updateBankAccountDto(BankAccountDTO value) {
  //   _bankAccountDTO = value;
  //   showFormBankAccountOther = false;

  //   voidChooseBank(_bankAccountDTO.bankId);
  // }

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
