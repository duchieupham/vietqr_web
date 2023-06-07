import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';

class UserSettingRepository {
  const UserSettingRepository();

  Future<bool> getGuideWeb(String userId) async {
    bool result = false;
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts/setting/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data['guideWeb'];
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> updateGuideWeb(Map<String, dynamic> data) async {
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts/setting';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
