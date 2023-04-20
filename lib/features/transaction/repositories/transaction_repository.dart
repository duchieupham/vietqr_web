import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';

class TransactionRepository {
  const TransactionRepository();

  Future<List<RelatedTransactionReceiveDTO>> getTransactionByBankId(
      TransactionInputDTO dto) async {
    List<RelatedTransactionReceiveDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}transaction/list';

      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
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
}
