import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/qr_create_dto.dart';

class TopUpRepository {
  const TopUpRepository();

  Future<AccountInformationDTO> getInfomation(String phoneNumber) async {
    AccountInformationDTO result = const AccountInformationDTO(
        userId: '',
        firstName: '',
        middleName: '',
        lastName: '',
        birthDate: '',
        gender: 0,
        address: '',
        email: '',
        imgId: '',
        phoneNo: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}qr/generate';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: [],
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = AccountInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
