import 'package:VietQR/services/shared_references/guide_helper.dart';
import 'package:flutter/material.dart';

class GuideProvider with ChangeNotifier {
  int _index = 0;
  bool _isGuideDisabled = GuideHelper.instance.isGuideDisabled();

  int get index => _index;
  bool get guideDisabled => _isGuideDisabled;

  void updateIndex(int value) {
    _index = value;
    notifyListeners();
  }

  Future<void> updateGuideDisabled(bool value) async {
    await GuideHelper.instance.updateGuideDisable(value);
    _isGuideDisabled = GuideHelper.instance.isGuideDisabled();
    notifyListeners();
  }
}
