import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_create_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';

class QRGenerateRepository {
  String userId = UserInformationHelper.instance.getUserId();

  Future<List<BankAccountDTO>> getListBankAccount() async {
    List<BankAccountDTO> result = [];

    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<BankAccountDTO>((json) {
            return BankAccountDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankTypeDTO>> getBankTypes() async {
    List<BankTypeDTO> result = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}bank-type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<BankTypeDTO>((json) => BankTypeDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TerminalQRDTO>> getTerminals(String bankId) async {
    List<TerminalQRDTO> listTerminal = [];

    try {
      String url =
          '${EnvConfig.getBaseUrl()}account-bank/terminal?userId=$userId&bankId=$bankId';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listTerminal = data
              .map<TerminalQRDTO>((json) => TerminalQRDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listTerminal;
  }

  Future<QRGeneratedDTO?> generateQR({
    required String bankId,
    required String amount,
    required String content,
    required String terminalCode,
    required String orderId,
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['bankId'] = bankId;
      param['amount'] = amount;
      param['content'] = content;
      param['userId'] = userId;
      param['transType'] = 'C';
      param['terminalCode'] = terminalCode;
      param['orderId'] = orderId;

      final String url = '${EnvConfig.getBaseUrl()}qr/generate';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<QRGeneratedDTO?> generateQRUnAuthen(
      {required String bankAccount,
      required String bankCode,
      required String userBankName,
      required String amount,
      required String content}) async {
    try {
      Map<String, dynamic> param = {};
      param['bankAccount'] = bankAccount;
      param['bankCode'] = bankCode;
      param['userBankName'] = userBankName;
      param['amount'] = amount;
      param['content'] = content;
      final String url = '${EnvConfig.getBaseUrl()}qr/generate/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
