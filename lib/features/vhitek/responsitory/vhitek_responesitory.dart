import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/response_message_dto.dart';

class VhitekRepository {
  const VhitekRepository();

  Future<ResponseMessageDTO> checkValidUser(String email) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url =
          '${EnvConfig.getBaseUrl()}service/vhitek/check-user?email=$email';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> createUser(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    print(param);
    try {
      String url = '${EnvConfig.getBaseUrl()}service/vhitek/create-user';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> active(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}service/vhitek/active-terminal';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      if (data != null) {
        result = ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
