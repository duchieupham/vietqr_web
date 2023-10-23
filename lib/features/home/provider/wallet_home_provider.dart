import 'package:flutter/material.dart';

class WalletHomeProvider with ChangeNotifier {
  bool _showAmount = false;
  bool get showAmount => _showAmount;

  void changeShowAmount() {
    _showAmount = !_showAmount;
    notifyListeners();
  }
}
