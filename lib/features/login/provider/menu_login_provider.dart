import 'package:flutter/material.dart';

class MenuLoginProvider with ChangeNotifier {
  int _page = 5;
  int get page => _page;

  changePage(int value) async {
    _page = value;
    notifyListeners();
  }
}
