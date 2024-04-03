import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/account_card_num_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';

class CardNumRepository {
  const CardNumRepository();

  Future<ResponseMessageDTO> getCardNumberByUserId(String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: "", message: "");
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/cardNumber/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> updateCardNumber(AccountCardNumDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: "", message: "");
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/cardNumber';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
