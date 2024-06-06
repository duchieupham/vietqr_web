import 'dart:convert';

import 'package:VietQR/models/setting_account_sto.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUser(SettingAccountDTO dto) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('USER', jsonEncode(dto.toJson()));
}

Future<void> setDialog(bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('IS_DIALOG_OPEN', value);
}

Future<bool> getDialog() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('IS_DIALOG_OPEN') ?? false;
}

Future<SettingAccountDTO?> getUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? encodedCart = prefs.getString('USER');
  if (encodedCart != null) {
    SettingAccountDTO user =
        SettingAccountDTO.fromJson(jsonDecode(encodedCart));
    return user;
  }
  return null;
}

Future<void> deleteUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("USER");
}
