// ignore_for_file: non_constant_identifier_names

import 'package:VietQR/commons/constants/vietqr/aid.dart';
import 'package:VietQR/commons/constants/vietqr/viet_qr_id.dart';
import 'package:VietQR/commons/utils/viet_qr_utils.dart';

class QRGuid {
  static final String GUID = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
      VietQRUtils.instance.generateLengthOfValue(AID.AID_NAPAS) +
      AID.AID_NAPAS;
}
