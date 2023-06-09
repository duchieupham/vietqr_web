import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/notification_dto.dart';
import 'package:VietQR/models/notification_input_dto.dart';

class NotificationRepository {
  const NotificationRepository();

  Future<int> getCounter(String userId) async {
    int result = 0;
    try {
      final String url = '${EnvConfig.getBaseUrl()}notification/count/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data['count'] ?? 0;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<NotificationDTO>> getNotificationsByUserId(
      NotificationInputDTO dto) async {
    List<NotificationDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}notifications';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<NotificationDTO>((json) => NotificationDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<bool> updateNotificationStatus(String userId) async {
    bool result = false;
    try {
      Map<String, dynamic> data = {'userId': userId};
      final String url = '${EnvConfig.getBaseUrl()}notification/status';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
