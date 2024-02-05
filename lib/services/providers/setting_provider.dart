import 'package:VietQR/features/home/repositories/home_repository.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  bool _validateHosting = false;

  bool get validateHosting => _validateHosting;

  bool _validateEndpoint = false;

  bool get validateEndpoint => _validateEndpoint;

  bool _enableVoice =
      UserInformationHelper.instance.getAccountSetting().voiceMobile;

  bool get enableVoice => _enableVoice;

  final List<String> _bankIds = [];

  List<String> get bankIds => _bankIds;

  BankAccountDTO _bankAccountDTO = BankAccountDTO();

  BankAccountDTO get bankAccountDTO => _bankAccountDTO;
  List<BankAccountDTO> bankAccounts = [];

  BankAccountDTO _bankAccountSelected = BankAccountDTO(
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

  final homeRepository = const HomeRepository();
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
        .where((e) =>
            e.userId == UserInformationHelper.instance.getUserId() &&
            e.isAuthenticated)
        .toList();
  }

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

  void updateOpenVoice(bool check) {
    _enableVoice = check;
    notifyListeners();
  }

  void updateListBank(String bankId) {
    if (_bankIds.contains(bankId)) {
      _bankIds.remove(bankId);
    } else {
      _bankIds.add(bankId);
    }
    print('--------------------------$bankIds');
    notifyListeners();
  }
}
