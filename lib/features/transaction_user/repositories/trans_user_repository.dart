import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';

class TransUserRepository {
  const TransUserRepository();

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
}
