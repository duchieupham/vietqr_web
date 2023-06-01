import 'package:VietQR/main.dart';

class GuideHelper {
  const GuideHelper._privateConsrtructor();

  static const GuideHelper _instance = GuideHelper._privateConsrtructor();
  static GuideHelper get instance => _instance;
  //
  Future<void> initialGuide() async {
    await sharedPrefs.setBool('GUIDE_DISABLE', false);
  }

  Future<void> updateGuideDisable(bool value) async {
    await sharedPrefs.setBool('GUIDE_DISABLE', value);
  }

  bool isGuideDisabled() {
    return sharedPrefs.getBool('GUIDE_DISABLE')!;
  }
}
