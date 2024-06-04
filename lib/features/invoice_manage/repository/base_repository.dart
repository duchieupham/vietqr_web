import '../../../models/metadata_dto.dart';

class BaseRepo {
  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
