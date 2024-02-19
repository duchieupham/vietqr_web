import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/generate_username_pass_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';

class MerchantRQRepository {
  const MerchantRQRepository();

  Future<ResponseMessageDTO> insert(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}customer-sync/uat/request';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );

      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<ResponseMessageDTO> checkValidMerchantName(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}customer-sync/account/check-merchant';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );

      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<GenerateUserNamePassDto> generateUsernamePassword(
      Map<String, dynamic> param) async {
    GenerateUserNamePassDto result = const GenerateUserNamePassDto();
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}customer-sync/account/generate';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = GenerateUserNamePassDto.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future getToken(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO();
    print('---------------------------------------$param');
    try {
      String url =
          'https://dev.vietqr.org/vqr/api/admin/customer-sync/check-token';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
