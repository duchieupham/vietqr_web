import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  Future<ResponseMessageDTO> confirmStore(
      String terminalId, String machineCode) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}terminal/qr-box';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {'terminalId': terminalId, 'machineCode': machineCode},
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
      print('--------------------------$param');
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

  Future<bool> loginByUserId(String userId) async {
    bool result = false;
    Map<String, dynamic> paramLogin = {};
    paramLogin['userId'] = userId;
    paramLogin['method'] = 'USER_ID';
    paramLogin['cardNumber'] = '';
    paramLogin['fcmToken'] = '';
    paramLogin['platform'] = 'WEB';
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String url = '${EnvConfig.getBaseUrl()}accounts/login';

      String device = '';
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      device = webBrowserInfo.userAgent.toString();
      paramLogin['device'] = device;
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: paramLogin,
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        AccountInformationDTO accountInformationDTO =
            AccountInformationDTO.fromJson(decodedToken);
        await AccountHelper.instance.setFcmToken('');
        await AccountHelper.instance.setToken(token);
        await UserInformationHelper.instance
            .setPhoneNo(accountInformationDTO.phoneNo);
        await UserInformationHelper.instance
            .setUserId(accountInformationDTO.userId);
        await UserInformationHelper.instance
            .setAccountInformation(accountInformationDTO);
        await Session.instance.checkAccountIsMerchant();
        Session.instance.fetchWallet();
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future getListTerminal(String bankId, String userId) async {
    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal/list?bankId=$bankId&userId=$userId';
    } catch (e) {}
  }
}
