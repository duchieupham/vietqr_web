import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:flutter/material.dart';

import '../../models/bank_account_dto.dart';

enum PageInvoice { LIST, DETAIL }

class InvoiceProvider extends ChangeNotifier {
  PageInvoice pageInvoice = PageInvoice.LIST;

  List<BankAccountDTO> listBank = [];
  List<BankAccountDTO> filterBanks = [];
  List<SelectInvoiceItem> listSelectInvoice = [];

  List<InvoiceStatus> statusList = [
    const InvoiceStatus(id: 0, name: 'Chưa thanh toán'),
    const InvoiceStatus(id: 1, name: 'Đã Thanh toán'),
    // const InvoiceStatus(id: 2, name: ''),
  ];

  List<InvoiceTime> timeList = [
    const InvoiceTime(id: 0, name: 'Tất cả'),
    const InvoiceTime(id: 1, name: 'Tháng'),
    // const InvoiceStatus(id: 2, name: ''),
  ];

  int? selectBankType = 0;
  BankAccountDTO? selectBank;
  DateTime? invoiceMonth;
  bool? isMonthSelect = false;
  bool isFilter = false;

  InvoiceTime? invoiceTime = const InvoiceTime(id: 0, name: 'Tất cả');

  InvoiceStatus _invoiceStatus =
      const InvoiceStatus(id: 0, name: 'Chưa thanh toán');

  InvoiceStatus get invoiceStatus => _invoiceStatus;

  int? selectedStatus = 0;

  String _invoiceId = '';
  String? get invoiceId => _invoiceId;

  void onPageChange(PageInvoice page, {String? invoiceId}) {
    if (page == PageInvoice.DETAIL) {
      _invoiceId = invoiceId!;
    }

    pageInvoice = page;
    notifyListeners();
  }

  void selectMonth(DateTime? month, bool? monthSelect) {
    invoiceMonth = month;
    isMonthSelect = monthSelect;
    notifyListeners();
  }

  void changeBankType(int? bankType) {
    selectBankType = bankType;
    notifyListeners();
  }

  void selectBankAccount(BankAccountDTO? bank) {
    selectBank = bank;
    notifyListeners();
  }

  void changeTime(InvoiceTime time) {
    invoiceTime = time;
    notifyListeners();
  }

  void changeStatus(int type) {
    selectedStatus = type;
    notifyListeners();
  }

  void selectStatus(InvoiceStatus value) {
    _invoiceStatus = value;
    notifyListeners();
  }

  void setListSelectItem(List<InvoiceItemDetailDTO> items) {
    listSelectInvoice = items
        .map((e) => SelectInvoiceItem(isSelect: false, invoiceItem: e))
        .toList();
    notifyListeners();
  }

  void appliedInvoiceItem(bool value, int index) {
    listSelectInvoice[index].isSelect = value;

    notifyListeners();
  }

  void appliedAllItem(bool value) {
    for (var e in listSelectInvoice) {
      e.isSelect = value;
    }
    notifyListeners();
  }

  void filterBankList(String? filter) {
    if (filter!.isNotEmpty) {
      isFilter = true;
      filterBanks = listBank
          .where((e) =>
              e.bankAccount.toLowerCase().contains(filter.toLowerCase()) ||
              e.userBankName.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      isFilter = false;
    }
    notifyListeners();
  }

  void setListBank(List<BankAccountDTO> list) {
    listBank = list;
    notifyListeners();
  }

  void reset() {
    selectBankType = 0;
    _invoiceStatus = const InvoiceStatus(id: 0, name: 'Chưa thanh toán');
    invoiceTime = const InvoiceTime(id: 0, name: 'Tất cả');
    selectBank = null;
    invoiceMonth = null;
    notifyListeners();
  }
}

class SelectInvoiceItem {
  bool? isSelect;
  final InvoiceItemDetailDTO invoiceItem;

  SelectInvoiceItem({
    this.isSelect,
    required this.invoiceItem,
  });
}

class InvoiceTime {
  final int id;
  final String name;

  const InvoiceTime({required this.id, required this.name});
}

class InvoiceStatus {
  final int id;
  final String name;

  const InvoiceStatus({required this.id, required this.name});
}
