import 'package:flutter/material.dart';

enum PageMerchant { API_SERVICE, E_COMMERCE, CONNECTED_MACHINE }

class MerchantV2Provider extends ChangeNotifier {
  PageMerchant pageMerchant = PageMerchant.API_SERVICE;

  void onPageChange(PageMerchant page) {
    pageMerchant = page;
    notifyListeners();
  }
}
