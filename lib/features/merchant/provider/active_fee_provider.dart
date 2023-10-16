import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:flutter/material.dart';

class ActiveFeeProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  DateTime _dateTime = DateTime.now();
  DateTime get currentDate => _dateTime;
  String get dateTime => TimeUtils.instance.formatDateToString(_dateTime);

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void changeDate(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }
}
