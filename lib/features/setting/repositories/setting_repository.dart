import 'dart:convert';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';

class SettingRepository {
  const SettingRepository();

  Future<String> requestTokenPlus(Map<String, String> data) async {
    String result = '';
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/token-plugin';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = data['accessToken'];
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
