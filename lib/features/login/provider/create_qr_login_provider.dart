import 'package:flutter/material.dart';

class CreateQRLoginProvider with ChangeNotifier {
  bool _showMoreOption = false;
  bool get showMoreOption => _showMoreOption;

  int _page = 0;
  int get page => _page;

  changePage(int value) {
    _page = value;
    notifyListeners();
  }

  updateShowMoreOption(bool value) async {
    _showMoreOption = value;
    notifyListeners();
  }
}
