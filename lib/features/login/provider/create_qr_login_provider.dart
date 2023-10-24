import 'package:flutter/material.dart';

class CreateQRLoginProvider with ChangeNotifier {
  bool _showMoreOption = false;
  bool get showMoreOption => _showMoreOption;

  updateShowMoreOption(bool value) async {
    _showMoreOption = value;
    notifyListeners();
  }
}
