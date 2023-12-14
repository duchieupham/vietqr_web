import 'dart:convert';

import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/models/api_service_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/callback_dto.dart';
import 'package:VietQR/models/ecomerce_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';

class CallBackRepository {
  CallBackRepository();

  final String baseUrl = 'https://dev.vietqr.org/vqr/api';

  Future<List<CallBackDTO>> getTrans(
      String bankId, String customerSyncId, int offset) async {
    List<CallBackDTO> result = [];
    try {
      String url =
          '$baseUrl/admin/transactions/customer-sync?bankId=$bankId&customerSyncId=$customerSyncId&offset=$offset';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<CallBackDTO>((json) => CallBackDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBank(String id) async {
    List<BankAccountDTO> result = [];
    try {
      String url = '$baseUrl/admin/account-bank/list?customerSyncId=$id';
      print(
          '--------------------------------------------$url---------------------');
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<BankAccountDTO>((json) => BankAccountDTO.fromJson(json))
              .toList();
          return result;
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ApiServiceDTO> getInfoApiService(String id) async {
    ApiServiceDTO result = const ApiServiceDTO();
    try {
      String url = '$baseUrl/admin/customer-sync/information?id=$id';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ApiServiceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<EcomerceDTO> getInfoEcomerce(String id) async {
    EcomerceDTO result = const EcomerceDTO();
    try {
      String url = '$baseUrl/admin/customer-sync/information?id=$id';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = EcomerceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<bool> getToken(String userName, String password) async {
    try {
      String url = '$baseUrl/token_generate';

      Map<String, String>? result = {};
      result['Authorization'] =
          'Basic ${StringUtils.instance.authBase64(userName, password)}';

      result['Content-Type'] = 'application/json';
      result['Accept'] = '*/*';

      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.CUSTOM, body: {}, header: result);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        await AccountHelper.instance.setTokenFree(data['access_token']);
        return true;
      } else {
        await AccountHelper.instance.setTokenFree('');
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<ResponseMessageDTO> runCallback(Map<String, dynamic> body) async {
    ResponseMessageDTO dto = const ResponseMessageDTO();

    try {
      String url =
          'https://dev.vietqr.org/vqr/bank/api/test/transaction-callback';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: body,
      );
      var data = jsonDecode(response.body);
      dto = ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
    }
    return dto;
  }
}
