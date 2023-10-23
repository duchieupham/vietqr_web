import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String bankId = '';

  onChangeBankId(value) {
    bankId = value;
    notifyListeners();
  }
}
