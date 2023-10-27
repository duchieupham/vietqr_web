import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/features/home/repositories/home_repository.dart';
import 'package:VietQR/features/transaction_user/blocs/tran_user_bloc.dart';
import 'package:VietQR/features/transaction_user/events/tran_user_event.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class TransUserProvider with ChangeNotifier {
  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 0, title: 'Số tài khoản'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Order ID'),
    const FilterTransaction(id: 3, title: 'Nội dung')
  ];

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả');
  FilterTransaction get valueFilter => _valueFilter;

  List<FilterTimeTransaction> listTimeFilter = [
    const FilterTimeTransaction(id: 0, title: 'Tất cả'),
    const FilterTimeTransaction(id: 1, title: 'Khoảng thời gian'),
  ];
  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 0, title: 'Tất cả');
  FilterTimeTransaction get valueTimeFilter => _valueTimeFilter;
  DateTime _toDate = DateTime.now();
  DateTime get toDate => _toDate;

  DateTime _formDate = DateTime.now();
  DateTime get fromDate => _formDate;

  BankAccountDTO _bankAccountDTO = BankAccountDTO();
  BankAccountDTO get bankAccountDTO => _bankAccountDTO;

  String _keywordSearch = '';
  String get keywordSearch => _keywordSearch;

  int _currentPage = 0;
  int get currentPage => _currentPage;
  int offset = 0;
  bool isCalling = true;
  ScrollController scrollControllerList = ScrollController();
  final homeRepository = const HomeRepository();

  List<BankAccountDTO> bankAccounts = [];

  init(TransactionUserBloc transactionUserBloc, Function initData) {
    initData();
    getListBankAccount();
    scrollControllerList.addListener(() {
      if (isCalling) {
        if (scrollControllerList.offset ==
            scrollControllerList.position.maxScrollExtent) {
          offset = offset + 20;
          Map<String, dynamic> param = {};
          param['type'] = _valueFilter.id;
          if (_valueTimeFilter.id == 0 ||
              (_valueFilter.id != 0 && _valueFilter.id != 9)) {
            param['from'] = '0';
            param['to'] = '0';
          } else {
            param['from'] = TimeUtils.instance.getCurrentDate(_formDate);
            param['to'] = TimeUtils.instance.getCurrentDate(_toDate);
          }
          param['value'] = _keywordSearch;

          param['offset'] = offset;
          param['userId'] = UserInformationHelper.instance.getUserId();
          transactionUserBloc.add(GetListTransactionByEvent(
            param: param,
            isLoadMore: true,
          ));
          isCalling = false;
        }
      }
    });
  }

  getListBankAccount() async {
    bankAccounts = await homeRepository
        .getListBankAccount(UserInformationHelper.instance.getUserId());
    _bankAccountDTO = bankAccounts.first;
  }

  updateCallLoadMore(bool value) {
    isCalling = value;
  }

  updateOffset(int value) {
    offset = value;
  }

  resetFilter() {
    _valueFilter = const FilterTransaction(id: 9, title: 'Tất cả');
    _valueTimeFilter = const FilterTimeTransaction(id: 0, title: 'Tất cả');
    notifyListeners();
  }

  void changeFilter(FilterTransaction value) {
    _valueFilter = value;
    if (_valueFilter.id == 9) {
      _valueTimeFilter = const FilterTimeTransaction(id: 0, title: 'Tất cả');
    }

    if (_valueFilter.id == 0) {
      _keywordSearch = _bankAccountDTO.bankAccount;
    }
    notifyListeners();
  }

  void changeBankAccount(BankAccountDTO value) {
    _bankAccountDTO = value;
    _keywordSearch = value.bankAccount;
    notifyListeners();
  }

  void changeTimeFilter(FilterTimeTransaction value) {
    _valueTimeFilter = value;
    notifyListeners();
  }

  updateKeyword(String value) {
    String text = value.trim();
    if (text.contains('')) {
      _keywordSearch = text.replaceAll(' ', '-');
    } else {
      _keywordSearch = text;
    }
  }

  void updateFromDate(DateTime value) {
    _formDate = value;
    notifyListeners();
  }

  void updateToDate(DateTime value) {
    _toDate = value;
    notifyListeners();
  }

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
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
