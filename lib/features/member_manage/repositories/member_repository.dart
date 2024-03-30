import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/member/member_dto.dart';
import 'package:VietQR/models/member/member_input_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';

class MemberRepository {
  MemberRepository();

  String get userId => UserInformationHelper.instance.getUserId().trim();
  int limit = 20;

  Future<MemberDTO> getMembers(MemberInputDTO dto) async {
    MemberDTO result = MemberDTO();
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}merchant-member/${dto.merchantId}?'
          'page=${dto.page}&size=$limit&type=${dto.type}&value=${dto.value}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = MemberDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<MerchantDTO>> getMerchants() async {
    List<MerchantDTO> result = [];

    try {
      String url = '${EnvConfig.getBaseUrl()}merchant-list/$userId';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<MerchantDTO>((json) {
            return MerchantDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }
}
