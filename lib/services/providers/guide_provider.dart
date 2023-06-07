import 'package:VietQR/features/home/repositories/user_setting_repository.dart';
import 'package:VietQR/services/shared_references/guide_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class GuideProvider with ChangeNotifier {
  int _index = 0;
  bool _isGuideDisabled = false;

  int get index => _index;
  bool get guideDisabled => _isGuideDisabled;

  bool _guideWeb = false;
  bool get guideWeb => _guideWeb;
  UserSettingRepository userSettingRepository = const UserSettingRepository();
  void updateIndex(int value) {
    _index = value;
    if (value == 0) {
      _isGuideDisabled = GuideHelper.instance.isGuideDisabled();
    }
    notifyListeners();
  }

  void changeGuideWeb(bool value) {
    _guideWeb = value;
    notifyListeners();
  }

  Future<void> updateGuideDisabled() async {
    if (_guideWeb) {
      String userId = UserInformationHelper.instance.getUserId();
      Map<String, dynamic> data = {'userId': userId, 'guideWeb': 0};
      userSettingRepository.updateGuideWeb(data);
    }
    await GuideHelper.instance.updateGuideDisable(false);
    notifyListeners();
  }
}
