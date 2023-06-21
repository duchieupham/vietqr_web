import 'dart:convert';

import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/business_detail_dto.dart';
import 'package:VietQR/models/business_information_insert_dto.dart';
import 'package:VietQR/models/business_item_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:http/http.dart' as http;

class BusinessInformationRepository {
  const BusinessInformationRepository();

  Future<ResponseMessageDTO> insertBusinessInformation(
      BusinessInformationInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}business-information';
      final List<http.MultipartFile> files = [];
      if (dto.image != null) {
        final imageFile =
            await http.MultipartFile.fromPath('image', dto.image!.path);
        files.add(imageFile);
      }
      if (dto.coverImage != null) {
        final imageFile = await http.MultipartFile.fromPath(
            'coverImage', dto.coverImage!.path);
        files.add(imageFile);
      }
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: dto.toJson(),
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

  Future<List<BusinessItemDTO>> getBusinessItems(String userId) async {
    List<BusinessItemDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}business-informations/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BusinessItemDTO>((json) => BusinessItemDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<BusinessDetailDTO> getBusinessDetail(
      String businessId, String userId) async {
    BusinessDetailDTO result = const BusinessDetailDTO(
      id: '',
      name: '',
      address: '',
      code: '',
      imgId: '',
      coverImgId: '',
      taxCode: '',
      userRole: 0,
      managers: [],
      branchs: [],
      transactions: [],
      active: false,
    );
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}business-information/detail/$businessId/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BusinessDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
