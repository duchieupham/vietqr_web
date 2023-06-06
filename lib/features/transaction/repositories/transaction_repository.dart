import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/models/transaction_receive_dto.dart';

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

  Future<TransactionReceiveDTO> getTransactionDetail(String id) async {
    TransactionReceiveDTO result = const TransactionReceiveDTO(
      time: 0,
      status: 0,
      id: '',
      type: 0,
      content: '',
      bankAccount: '',
      bankAccountName: '',
      bankId: '',
      bankCode: '',
      bankName: '',
      imgId: '',
      amount: 0,
      transType: '',
      traceId: '',
      refId: '',
      referenceNumber: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}transaction/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = TransactionReceiveDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
