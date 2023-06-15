import 'dart:convert';
import 'dart:typed_data';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/password_update_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:http/http.dart' as http;
import '../../../commons/constants/configurations/stringify.dart';

class InformationUserRepository {
  const InformationUserRepository();

  Future<ResponseMessageDTO> updateUserInformation(
      AccountInformationDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/information';
      final response = await BaseAPIClient.putAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode != 403) {
        var data = jsonDecode(response.body);
        UserInformationHelper.instance.setAccountInformation(dto);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(
            status: Stringify.RESPONSE_STATUS_FAILED, message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(PasswordUpdateDTO dto) async {
    Map<String, dynamic> result = {'check': false, 'msg': ''};
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/password';
      PasswordUpdateDTO encryptedDTO = PasswordUpdateDTO(
        userId: dto.userId,
        oldPassword:
            EncryptUtils.instance.encrypted(dto.phoneNo, dto.oldPassword),
        newPassword:
            EncryptUtils.instance.encrypted(dto.phoneNo, dto.newPassword),
        phoneNo: dto.phoneNo,
      );
      final response = await BaseAPIClient.putAPI(
        url: url,
        body: encryptedDTO.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        result['check'] = true;
      } else {
        var data = jsonDecode(response.body);
        ResponseMessageDTO messageDTO = ResponseMessageDTO.fromJson(data);
        if (messageDTO.message == 'Old Password is not match.' ||
            messageDTO.message == 'E01') {
          result['msg'] = 'Mật khẩu cũ không khớp.';
        } else {
          result['msg'] = messageDTO.message;
        }
        result['check'] = false;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> updateAvatar(
      String imgId, String userId, List<int>? imageData) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final Map<String, dynamic> data = {
        'userId': userId,
        'imgId': imgId,
      };
      final String url = '${EnvConfig.getBaseUrl()}user/image';
      final List<http.MultipartFile> files = [];
      if (imageData!.isNotEmpty) {
        final imageFile = http.MultipartFile.fromBytes('image', imageData);

        files.add(imageFile);
        final response = await BaseAPIClient.postMultipartAPI(
          url: url,
          fields: data,
          files: files,
        );
        if (response.statusCode == 200 || response.statusCode == 400) {
          var data = jsonDecode(response.body);
          result = ResponseMessageDTO.fromJson(data);
          if (result.message.trim().isNotEmpty) {
            await UserInformationHelper.instance.setImageId(result.message);
          }
        } else {
          result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<ResponseMessageDTO> deActiveUser(String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/deactive/$userId';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: null,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        // await _resetServices();
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  // Future<void> _resetServices() async {
  //   BuildContext context = NavigationService.navigatorKey.currentContext!;
  //   Provider.of<CreateQRProvider>(context, listen: false).reset();
  //   Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
  //   Provider.of<BankAccountProvider>(context, listen: false).reset();
  //   Provider.of<UserEditProvider>(context, listen: false).reset();
  //   Provider.of<RegisterProvider>(context, listen: false).reset();
  //   Provider.of<SuggestionWidgetProvider>(context, listen: false).reset();
  //   await EventBlocHelper.instance.updateLogoutBefore(true);
  //   await UserInformationHelper.instance.initialUserInformationHelper();
  //   await AccountHelper.instance.setBankToken('');
  //   await AccountHelper.instance.setToken('');
  // }
}
