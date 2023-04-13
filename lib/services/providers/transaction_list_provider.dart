import 'package:flutter/widgets.dart';

class TransactionListProvider with ChangeNotifier {
  int _page = 0;
  bool _isEnded = false;
  bool _isTransactionEmpty = false;

  int get page => _page;
  bool get ended => _isEnded;
  bool get transactionEmpty => _isTransactionEmpty;

  void updateTransactionEmpty(bool value) {
    _isTransactionEmpty = value;
    notifyListeners();
  }

  void updateEnded(bool value) {
    _isEnded = value;
    notifyListeners();
  }

  void updatePage(int value) {
    _page = value;
    notifyListeners();
  }

  void reset() {
    _page = 0;
    _isEnded = false;
    _isTransactionEmpty = false;
    notifyListeners();
  }
}
