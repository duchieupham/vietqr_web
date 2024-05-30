import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/features/merchant/repositories/merchant_repository.dart';
import 'package:VietQR/models/account_is_merchant.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class SynthesisReportProvider with ChangeNotifier {
  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 0, title: 'Đại lý'),
    const FilterTransaction(id: 1, title: 'TK ngân hàng'),
  ];

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 0, title: 'Đại lý');
  FilterTransaction get valueFilter => _valueFilter;

  List<FilterTimeTransaction> listTimeFilter = [
    const FilterTimeTransaction(id: 0, title: 'Năm'),
    const FilterTimeTransaction(id: 1, title: 'Tháng'),
  ];
  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 0, title: 'Năm');
  FilterTimeTransaction get valueTimeFilter => _valueTimeFilter;

  DateTime _timeCurrent = DateTime.now();
  DateTime get timeCurrent => _timeCurrent;
  BankAccountDTO _bankAccountDTO = BankAccountDTO();
  BankAccountDTO get bankAccountDTO => _bankAccountDTO;

  final MerchantRepository merchantRepository = const MerchantRepository();

  int type = 0;
  String time = '';

  List<BankAccountDTO> bankAccounts = [];
  List<int> years = [];

  int _year = DateTime.now().year;
  int get year => _year;

  int page = 0;
  changePage(int value) {
    page = value;
    notifyListeners();
  }

  updateYear(int value) {
    _year = value;
    notifyListeners();
  }

  DateTime getPreviousMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 1;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  getListBankAccount() async {
    getListYear();
    String userId = UserInformationHelper.instance.getUserId();
    AccountIsMerchantDTO dto =
        await merchantRepository.checkAccountIsMerchant(userId);
    bankAccounts = await merchantRepository.getListBank(dto.customerSyncId);
    _bankAccountDTO = bankAccounts.first;
  }

  void changeFilter(FilterTransaction value) {
    _valueFilter = value;

    changeTimeFilter(const FilterTimeTransaction(id: 0, title: 'Năm'));

    notifyListeners();
  }

  void changeBankAccount(BankAccountDTO value) {
    _bankAccountDTO = value;
    notifyListeners();
  }

  void changeTimeFilter(FilterTimeTransaction value) {
    _valueTimeFilter = value;
    _timeCurrent = DateTime.now();
    if (_valueFilter.id == 0) {
      if (_valueTimeFilter.id == 0) {
        type = 0;
        time = DateTime.now().year.toString();
      } else {
        type = 1;
        time = TimeUtils.instance.getFormatMonth(DateTime.now());
      }
    } else {
      if (_valueTimeFilter.id == 0) {
        type = 2;
        time = DateTime.now().year.toString();
      } else {
        type = 3;
        time = TimeUtils.instance.getFormatMonth(DateTime.now());
      }
    }

    notifyListeners();
  }

  void updateCurrentTime(DateTime value) {
    _timeCurrent = value;
    if (_valueTimeFilter.id == 0) {
      time = DateTime.now().year.toString();
    } else {
      time = TimeUtils.instance.getFormatMonth(value);
    }
    notifyListeners();
  }

  void getListYear() {
    years.clear();
    int intiYear = 2022;
    int currentYear = DateTime.now().year;

    int yearGap = currentYear - intiYear;
    if (yearGap == 1) {
      years = [intiYear, currentYear];
    } else {
      if (yearGap > 1) {
        for (int i = 0; i <= yearGap; i++) {
          years.add(intiYear + i);
        }
      }
    }
  }
}

class FilterTransaction {
  final String title;
  final int id;
  const FilterTransaction({required this.id, required this.title});
}

class FilterTimeTransaction {
  final String title;
  final int id;
  const FilterTimeTransaction({required this.id, required this.title});
}
