import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/transaction_qr_dto.dart';
import 'package:VietQR/models/vcard_generated_dto.dart';

class QRCodeUnUTRepository {
  const QRCodeUnUTRepository();

  Future<QRGeneratedDTO> generateQR(Map<String, dynamic> data) async {
    QRGeneratedDTO result = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}qr/generate/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<VcardGenerateDto> vcardGenerateQR(Map<String, dynamic> data) async {
    VcardGenerateDto result = const VcardGenerateDto();
    try {
      final String url = '${EnvConfig.getBaseUrl()}vcard/generate';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = VcardGenerateDto.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<QRGeneratedDTO> generateQRStaging(Map<String, dynamic> data) async {
    QRGeneratedDTO result = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    try {
      const String url =
          'http://112.78.1.220:8084/vqr/api/qr/generate/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<TransactionQRDTO> getTransactionQR(String id) async {
    TransactionQRDTO result = const TransactionQRDTO();
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transactions/qr-link?refId=$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = TransactionQRDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> cancelQR(String token) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}transactions/qr-link/cancel';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'refId': token},
      );
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
}
