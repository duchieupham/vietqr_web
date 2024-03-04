import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/member_store_dto.dart';
import 'package:VietQR/models/store_detail_dto.dart';
import 'package:VietQR/models/store_model.dart';

class EnterpriseRepository {
  const EnterpriseRepository();

  Future<StoreModel> getStore(
      String userId, int offset, String merchantId, String value) async {
    StoreModel model = StoreModel();
    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal/web?userId=$userId&offset=$offset&merchantId=$merchantId&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          model = StoreModel.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return model;
  }

  Future<StoreDetailDTO> getStoreDetail(
      String terminalId, String userId) async {
    StoreDetailDTO model = StoreDetailDTO(bank: BankAccountDTO());
    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal/web/detail/$terminalId?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          model = StoreDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return model;
  }

  Future<List<MemberStoreModel>> getMemberStore(String userId, int offset,
      String terminalId, String value, int type) async {
    List<MemberStoreModel> result = [];
    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal/web/member-detail/$terminalId?offset=$offset&type=$type&value=$value&userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<MemberStoreModel>((json) => MemberStoreModel.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
