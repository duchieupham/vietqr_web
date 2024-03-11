import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/models/transaction_receive_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';

class TransactionRepository {
  TransactionRepository();

  String get userId => UserInformationHelper.instance.getUserId().trim();
  int limit = 20;

  Future<List<RelatedTransactionReceiveDTO>> getTransactionByBankId(
      TransactionInputDTO dto) async {
    List<RelatedTransactionReceiveDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transactions/list?bankId=${dto.bankId}&type=${dto.type}&offset=${dto.offset * limit}&value=${dto.value}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<RelatedTransactionReceiveDTO>(
                (json) => RelatedTransactionReceiveDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  // - 9: all
  // - 1: reference_number (mã giao dịch)
  // - 2: order_id
  // - 3: content
  // - 4: terminal code
  // - 5: status
  Future<List<RelatedTransactionReceiveDTO>> getTransNotOwner(
      TransactionInputDTO dto) async {
    List<RelatedTransactionReceiveDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}terminal/transactions?terminalCode=${dto.terminalCode}&userId=$userId&bankId=${dto.bankId}&type=${dto.type}&offset=${dto.offset * limit}&value=${dto.value}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<RelatedTransactionReceiveDTO>(
                (json) => RelatedTransactionReceiveDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<RelatedTransactionReceiveDTO>> getTransUnsettled(
      TransactionInputDTO dto) async {
    List<RelatedTransactionReceiveDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transactions/unsettled?bankId=${dto.bankId}&userId=$userId'
          '&type=${dto.type}&offset=${dto.offset * limit}&value=${dto.value}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<RelatedTransactionReceiveDTO>(
                (json) => RelatedTransactionReceiveDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

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
}
