import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/ecom/login/model/account_login_dto.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ECOMLoginRepository {
  const ECOMLoginRepository();

  Future<bool> login(ECOMAccountLoginDTO dto) async {
    bool result = false;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String url = '${EnvConfig.getBaseUrl()}accounts';
      String fcmToken = '';

      String platform = '';
      String device = '';
      if (!PlatformUtils.instance.isWeb()) {
        if (PlatformUtils.instance.isIOsApp()) {
          platform = 'IOS';
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          device =
              '${iosInfo.name.toString()} ${iosInfo.systemVersion.toString()}';
        } else if (PlatformUtils.instance.isAndroidApp()) {
          platform = 'ANDROID';
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          device = androidInfo.model.toString();
        }
      } else {
        platform = 'Web';
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        device = webBrowserInfo.userAgent.toString();
      }
      ECOMAccountLoginDTO loginDTO = ECOMAccountLoginDTO(
        phoneNo: dto.phoneNo,
        email: dto.email,
        password: dto.password,
        platform: platform,
        device: device,
        fcmToken: fcmToken,
        hosting: dto.hosting,
      );
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: loginDTO.toJson(),
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        AccountInformationDTO accountInformationDTO =
            AccountInformationDTO.fromJson(decodedToken);
        await AccountHelper.instance.setFcmToken('');
        await AccountHelper.instance.setToken(token);
        await UserInformationHelper.instance.setPhoneNo(dto.phoneNo);
        await UserInformationHelper.instance
            .setUserECOMId(accountInformationDTO.userId);
        await UserInformationHelper.instance
            .setAccountInformation(accountInformationDTO);
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
