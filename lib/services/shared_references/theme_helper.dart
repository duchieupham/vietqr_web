import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConsrtructor();

  static const ThemeHelper _instance = ThemeHelper._privateConsrtructor();
  static ThemeHelper get instance => _instance;
  //
  Future<void> initialTheme() async {
    await sharedPrefs.setString('THEME_SYSTEM', DefaultTheme.THEME_SYSTEM);
  }

  Future<void> updateTheme(String theme) async {
    await sharedPrefs.setString('THEME_SYSTEM', theme);
  }

  String getTheme() {
    return sharedPrefs.getString('THEME_SYSTEM')!;
  }
}
