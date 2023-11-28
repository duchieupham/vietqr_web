import 'dart:convert';
import 'dart:io';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/models/add_contact_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/contact_detail_dto.dart';
import 'package:VietQR/models/contact_dto.dart';
import 'package:VietQR/models/national_scanner_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:http/http.dart' as http;

class ContactRepository {
  Future<List<ContactDTO>> getListSaveContact(userId, type, offset) async {
    List<ContactDTO> list = [];
    try {
      String url =
          '${EnvConfig.getBaseUrl()}contact/list?userId=$userId&type=$type&offset=$offset';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<List<ContactDTO>> getListContactPending(userId) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/list-pending/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<ContactDetailDTO> getContactDetail(id) async {
    ContactDetailDTO dto = ContactDetailDTO();
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          dto = ContactDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return dto;
  }

  Future<ResponseMessageDTO> removeContact(String id) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/remove/$id';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateContact(query, File? file) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    final List<http.MultipartFile> files = [];
    if (file != null) {
      final imageFile = await http.MultipartFile.fromPath('image', file.path);
      files.add(imageFile);
    }
    try {
      String url = '${EnvConfig.getBaseUrl()}contact-qr/update';
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: query,
        files: files,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateContactVCard(query, File? file) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    final List<http.MultipartFile> files = [];
    if (file != null) {
      final imageFile = await http.MultipartFile.fromPath('image', file.path);
      files.add(imageFile);
    }
    try {
      String url = '${EnvConfig.getBaseUrl()}contacts/vcard/update';
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: query,
        files: files,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateRelation(query) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/relation';
      final response = await BaseAPIClient.postAPI(
          url: url, body: query, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateStatusContact(query) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/status';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: query,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<List<ContactDTO>> getListContactRecharge(userId) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/recharge?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<List<ContactDTO>> searchUser(String phoneNo) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts/list/search/$phoneNo';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>(
                (json) => ContactDTO(
                  imgId: json['imgId'] ?? '',
                  id: json['id'] ?? '',
                  carrierTypeId: json['carrierTypeId'] ?? '',
                  nickname:
                      '${json['lastName'] ?? ''} ${json['middleName'] ?? ''} ${json['firstName'] ?? ''}',
                  status: 0,
                  type: 0,
                  description: '',
                  phoneNo: json['phoneNo'] ?? '',
                  relation: json['relation'] ?? 0,
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
      return list;
    }
    return list;
  }

  Future<ResponseMessageDTO> insertVCard(List<VCardModel> list,
      {String? token, String? tokenFree}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contacts/vcard';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {'list': list},
        // token: token,
        // tokenFree: tokenFree,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: '');
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
      return result;
    }
    return result;
  }

  Future<List<ContactDTO>> searchContact(nickname, userId, type, offset) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}contacts/search';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {
          'nickname': nickname,
          'userId': userId,
          'type': type,
          'offset': offset,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<ResponseMessageDTO> addContact(AddContactDTO dto, {File? file}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}contacts';

      Map<String, dynamic> body = {};

      body = dto.toJson();

      final List<http.MultipartFile> files = [];

      if (file != null) {
        final imageFile = await http.MultipartFile.fromPath('image', file.path);
        files.add(imageFile);
      }

      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: body,
        files: files,
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

  NationalScannerDTO getNationalInformation(String value) {
    NationalScannerDTO result = const NationalScannerDTO(
      nationalId: '',
      oldNationalId: '',
      fullname: '',
      birthdate: '',
      gender: '',
      address: '',
      dateValid: '',
    );
    try {
      if (value.contains('|') && value.split('|').length == 7) {
        List<String> data = value.split('|');
        result = NationalScannerDTO(
          nationalId: data[0],
          oldNationalId: data[1],
          fullname: data[2],
          birthdate: TimeUtils.instance.convertDateString(data[3]),
          gender: data[4],
          address: data[5],
          dateValid: TimeUtils.instance.convertDateString(data[6]),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<BankTypeDTO> getBankTypeByCaiValue(String caiValue) async {
    BankTypeDTO result = const BankTypeDTO(
      id: '',
      bankCode: '',
      bankName: '',
      imageId: '',
      status: 0,
      caiValue: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-type/cai/$caiValue';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankTypeDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
