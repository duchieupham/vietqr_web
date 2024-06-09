import 'dart:convert';

import 'package:VietQR/features/invoice_manage/repository/base_repository.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/fee_package_invoice.dto.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:VietQR/models/invoice_detail_qr_dto.dart';
import 'package:VietQR/models/invoice_excel_dto.dart';
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:VietQR/models/metadata_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';

import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';

class InvoiceRepository extends BaseRepo {
  String userId = UserInformationHelper.instance.getUserId();

  Future<List<InvoiceFeeDTO>?> getInvoiceList(
      {int? status,
      String? bankId,
      int? filterBy,
      String? time,
      int? page,
      int? size}) async {
    List<InvoiceFeeDTO>? result = [];

    try {
      //  final String url = '${EnvConfig.getBaseUrl()}key-active-bank/annual-fee';
      String userId = UserInformationHelper.instance.getUserId().trim();
      final String url =
          '${EnvConfig.getBaseUrl()}invoice/$userId?filterBy=$filterBy&time=${time ?? ''}&page=$page&size=${size ?? 20}&bankId=$bankId&status=$status';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return result = data['data'].map<InvoiceFeeDTO>((json) {
          return InvoiceFeeDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<FeePackageInvoiceDTO>> getListFeePackageInvoice({
    String? bankId,
    String? time,
  }) async {
    List<FeePackageInvoiceDTO> result = [];

    try {
      // final String url = '${EnvConfig.getBaseUrl()}account-bank/$userId';
      String userId = UserInformationHelper.instance.getUserId().trim();
      final String url =
          '${EnvConfig.getBaseUrl()}invoice/fee-package/$userId?bankId=$bankId&time=$time';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<FeePackageInvoiceDTO>((json) {
            return FeePackageInvoiceDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<InvoiceDetailQrDTO?> requestPaymnet({
    required String invoiceId,
    required List<String> itemItemIds,
    // String? bankIdRecharge,
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['invoiceId'] = invoiceId;
      param['itemItemIds'] = itemItemIds;
      // param['bankIdRecharge'] = bankIdRecharge;

      String url = '${EnvConfig.getBaseUrl()}invoice/request-payment';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceDetailQrDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to request payment: ${e.toString()}");
    }
    return null;
  }

  Future<InvoiceDetailDTO?> getInvoiceDetail(String invoiceId) async {
    try {
      String url = '${EnvConfig.getBaseUrl()}invoice/detail/$invoiceId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch Invoice detail: ${e.toString()}");
    }
    return null;
  }

  Future<InvoiceExcelDTO?> getInvoiceExcel(String invoiceId) async {
    try {
      // String url = '${EnvConfig.getBaseUrl()}invoice/detail/$invoiceId';
      String url =
          'https://dev.vietqr.org/vqr/mock/api/invoice/transaction-list?invoiceId=$invoiceId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return InvoiceExcelDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to fetch Invoice detail: ${e.toString()}");
    }
    return null;
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
