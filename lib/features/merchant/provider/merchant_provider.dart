import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/repositories/merchant_repository.dart';
import 'package:VietQR/models/account_is_merchant.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class MerchantProvider with ChangeNotifier {
  List<FilterTransaction> listFilter = [
    const FilterTransaction(id: 9, title: 'Tất cả'),
    const FilterTransaction(id: 0, title: 'Số tài khoản'),
    const FilterTransaction(id: 1, title: 'Mã giao dịch'),
    const FilterTransaction(id: 2, title: 'Order ID'),
    const FilterTransaction(id: 4, title: 'Mã điểm bán'),
    const FilterTransaction(id: 3, title: 'Nội dung'),
  ];

  FilterTransaction _valueFilter =
      const FilterTransaction(id: 9, title: 'Tất cả');

  FilterTransaction get valueFilter => _valueFilter;

  List<FilterTimeTransaction> listTimeFilter = [
    const FilterTimeTransaction(id: 0, title: 'Tất cả'),
    const FilterTimeTransaction(id: 1, title: 'Hôm nay'),
    const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất'),
    const FilterTimeTransaction(id: 3, title: '30 ngày gần nhất'),
    const FilterTimeTransaction(id: 4, title: '3 tháng gần nhất'),
    const FilterTimeTransaction(id: 5, title: 'Khoảng thời gian'),
  ];
  FilterTimeTransaction _valueTimeFilter =
      const FilterTimeTransaction(id: 2, title: '7 ngày gần nhất');

  FilterTimeTransaction get valueTimeFilter => _valueTimeFilter;
  DateTime _toDate = DateTime.now();

  DateTime get toDate => _toDate;

  DateTime _formDate = DateTime.now();

  DateTime get fromDate => _formDate;

  BankAccountDTO _bankAccountDTO = BankAccountDTO();

  BankAccountDTO get bankAccountDTO => _bankAccountDTO;

  String _keywordSearch = '';

  String get keywordSearch => _keywordSearch;

  int offset = 0;
  bool isCalling = true;
  final MerchantRepository merchantRepository = const MerchantRepository();
  ScrollController scrollControllerList = ScrollController();
  int _currentPage = 0;

  int get currentPage => _currentPage;
  List<BankAccountDTO> bankAccounts = [];
  String hasTag = '';
  changeHasTag(String value) {
    hasTag = value;
    notifyListeners();
  }

  TransactionMerchantDTO transactionMerchantDTO = TransactionMerchantDTO();
  updateTransactionDto(TransactionMerchantDTO dto, {bool init = true}) {
    transactionMerchantDTO = dto;
    hasTag = '';
    if (!init) {
      notifyListeners();
    }
  }

  init(MerchantBloc merchantBloc) {
    getListBankAccount();
    scrollControllerList.addListener(() {
      if (isCalling) {
        if (scrollControllerList.offset ==
            scrollControllerList.position.maxScrollExtent) {
          offset = offset + 20;
          Map<String, dynamic> param = {};
          param['type'] = valueFilter.id;
          if (_valueTimeFilter.id == TypeTimeFilter.ALL.id ||
              (_valueFilter.id.type != TypeFilter.ALL &&
                  _valueFilter.id.type != TypeFilter.BANK_NUMBER)) {
            param['from'] = '0';
            param['to'] = '0';
          } else {
            param['from'] = TimeUtils.instance.getCurrentDate(fromDate);
            param['to'] = TimeUtils.instance.getCurrentDate(toDate);
          }
          param['value'] = keywordSearch;

          param['offset'] = offset;
          param['merchantId'] =
              Session.instance.accountIsMerchantDTO.customerSyncId;
          merchantBloc.add(GetListTransactionByMerchantEvent(
            param: param,
            isLoadMore: true,
          ));
          isCalling = false;
        }
      }
    });
  }

  getListBankAccount() async {
    String userId = UserInformationHelper.instance.getUserId();
    AccountIsMerchantDTO dto =
        await merchantRepository.checkAccountIsMerchant(userId);
    bankAccounts = await merchantRepository.getListBank(dto.customerSyncId);
    _bankAccountDTO = bankAccounts.first;
  }

  updateCallLoadMore(bool value) {
    isCalling = value;
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
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    if (value.id == TypeTimeFilter.PERIOD.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (value.id == TypeTimeFilter.TODAY.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (value.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 7));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (value.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 30));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (value.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
      DateTime endDate = Jiffy(fromDate).subtract(months: 3).dateTime;
      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    }
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
