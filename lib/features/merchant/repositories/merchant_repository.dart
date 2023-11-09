import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/account_is_merchant.dart';
import 'package:VietQR/models/active_fee_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/synthesis_report_dto.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';

class MerchantRepository {
  const MerchantRepository();

  Future<AccountIsMerchantDTO> checkAccountIsMerchant(String userId) async {
    AccountIsMerchantDTO result = const AccountIsMerchantDTO();
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}customer-sync/information?accountId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<AccountIsMerchantDTO> list = data
            .map<AccountIsMerchantDTO>(
                (json) => AccountIsMerchantDTO.fromJson(json))
            .toList();
        result = list.first;
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<ResponseMessageDTO> updateNote(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}transactions/note';
      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.SYSTEM, body: param);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<List<ActiveFeeDTO>> getMerchantFee(
      String customerSyncId, String month) async {
    List<ActiveFeeDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}bank/service-fee/transaction?customerSyncId=$customerSyncId&month=$month';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<ActiveFeeDTO>((json) => ActiveFeeDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransactionMerchantDTO>> getListTransactionByUser(
      Map<String, dynamic> param) async {
    List<TransactionMerchantDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}user/transactions?userId=${param['userId']}&type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<TransactionMerchantDTO>(
                (json) => TransactionMerchantDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransactionMerchantDTO>> getListTransactionByMerchant(
      Map<String, dynamic> param) async {
    List<TransactionMerchantDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}merchant/transactions?merchantId=${param['merchantId']}&type=${param['type']}&value=${param['value']}&from=${param['from']}&to=${param['to']}&offset=${param['offset']}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<TransactionMerchantDTO>(
                (json) => TransactionMerchantDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBank(String id) async {
    List<BankAccountDTO> result = [];
    try {
      String url =
          '${EnvConfig.getBaseUrl()}admin/account-bank/list?customerSyncId=$id';

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

  Future<List<SynthesisReportDTO>> getListSynthesisReport(
      int type, String time, String id) async {
    List<SynthesisReportDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transactions/merchant/statistic?type=$type&id=$id&time=$time';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<SynthesisReportDTO>(
                (json) => SynthesisReportDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
