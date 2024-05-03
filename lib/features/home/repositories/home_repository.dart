import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_account_remove_dto.dart';
import 'package:VietQR/models/bank_card_insert_dto.dart';
import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_information_dto.dart';
import 'package:VietQR/models/bank_name_search_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/confirm_otp_bank_dto.dart';
import 'package:VietQR/models/qr_create_dto.dart';
import 'package:VietQR/models/qr_create_list_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/register_authentication_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:crypto/crypto.dart';

class HomeRepository {
  const HomeRepository();

  Future<List<BankTypeDTO>> getBankTypes() async {
    List<BankTypeDTO> listBanks = [];

    try {
      String url = '${EnvConfig.getBaseUrl()}bank-type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listBanks = data
              .map<BankTypeDTO>((json) => BankTypeDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBanks;
  }

  Future<List<QRGeneratedDTO>> generateQRList(List<QRCreateDTO> list) async {
    List<QRGeneratedDTO> result = [];
    try {
      final QRCreateListDTO qrCreateListDTO = QRCreateListDTO(dtos: list);
      final String url = '${EnvConfig.getBaseUrl()}qr/generate-list';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: qrCreateListDTO.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<QRGeneratedDTO>((json) => QRGeneratedDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> insertBankCard(BankCardInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> insertBankCardUnauthenticated(
      BankCardInsertUnauthenticatedDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> checkExistedBank(
    String bankAccount,
    String bankTypeId,
    String type,
    String userId,
  ) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/check-existed?bankAccount='
          '$bankAccount&bankTypeId=$bankTypeId&userId=$userId&type=$type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
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

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
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

  Future<ResponseMessageDTO> removeBankAccount(BankAccountRemoveDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> removeMemberFromBankAccount(
      String bankId, String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank/remove';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: {'bankId': bankId, 'userId': userId},
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  //

  //request OTP
  Future<ResponseMessageDTO> requestOTP(BankCardRequestOTP dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getUrl()}bank/api/request_otp_bank';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  //confirm OTP
  Future<ResponseMessageDTO> confirmOTP(ConfirmOTPBankDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getUrl()}bank/api/confirm_otp_bank';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  //get detail
  Future<AccountBankDetailDTO> getAccountBankDetail(String bankId) async {
    AccountBankDetailDTO result = const AccountBankDetailDTO(
      id: '',
      bankAccount: '',
      userBankName: '',
      bankCode: '',
      bankName: '',
      imgId: '',
      type: 0,
      userId: '',
      bankTypeId: '',
      bankTypeStatus: 0,
      nationalId: '',
      qrCode: '',
      phoneAuthenticated: '',
      businessDetails: [],
      transactions: [],
      authenticated: false,
      caiValue: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank/detail/$bankId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = AccountBankDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> updateRegisterAuthenticationBank(
      RegisterAuthenticationDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/register-authentication';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
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

  // Future<BankNameInformationDTO> searchBankName(BankNameSearchDTO dto) async {
  //   BankNameInformationDTO result = const BankNameInformationDTO(
  //     accountName: '',
  //     customerName: '',
  //     customerShortName: '',
  //   );
  //   try {
  //     final String url =
  //         '${EnvConfig.getUrl()}bank/api/account/info/${dto.bankCode}/${dto.accountNumber}/${dto.accountType}/${dto.transferType}';
  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       result = BankNameInformationDTO.fromJson(data);
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }

  Future<BankNameInformationDTO> searchBankName(BankNameSearchDTO dto) async {
    String generateCheckSum(
        String bankCode, String accountType, String accountNumber) {
      String key = "VietQRAccesskey";
      String toHash = bankCode + accountType + accountNumber + key;
      // Tạo hash MD5
      var bytes = utf8.encode(toHash);
      var digest = md5.convert(bytes);
      return digest.toString();
    }

    String checkSum =
        generateCheckSum(dto.bankCode, dto.accountType, dto.accountNumber);

    BankNameInformationDTO result = const BankNameInformationDTO(
      accountName: '',
      customerName: '',
      customerShortName: '',
    );
    try {
      final String url = '${EnvConfig.getUrl()}bank/api/account/info';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {
          'bankCode': dto.bankCode,
          'accountNumber': dto.accountNumber,
          'accountType': dto.accountType,
          'transferType': dto.transferType,
          'checkSum': checkSum,
        },
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankNameInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> unRequestOTP(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getUrl()}bank/api/unregister_request';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> unConfirmOTP(ConfirmOTPBankDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getUrl()}bank/api/unregister_confirm';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

// Future<ResponseMessageDTO> addContact(AddContactDTO dto, {File? file}) async {
//   ResponseMessageDTO result =
//       const ResponseMessageDTO(status: '', message: '');
//   try {
//     final String url = '${EnvConfig.getBaseUrl()}contacts';
//
//     Map<String, dynamic> body = {};
//
//     body = dto.toJson();
//
//     final List<http.MultipartFile> files = [];
//
//     if (file != null) {
//       final imageFile = await http.MultipartFile.fromPath('image', file.path);
//       files.add(imageFile);
//     }
//
//     final response = await BaseAPIClient.postMultipartAPI(
//       url: url,
//       fields: body,
//       files: files,
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 400) {
//       var data = jsonDecode(response.body);
//       result = ResponseMessageDTO.fromJson(data);
//     } else {
//       result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//   }
//   return result;
// }
}
