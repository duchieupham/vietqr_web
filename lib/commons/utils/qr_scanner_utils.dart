import 'package:VietQR/commons/constants/vietqr/aid.dart';
import 'package:VietQR/commons/constants/vietqr/viet_qr_id.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/viet_qr_scanned_dto.dart';

class QRScannerUtils {
  const QRScannerUtils._privateConsrtructor();

  static const QRScannerUtils _instance = QRScannerUtils._privateConsrtructor();
  static QRScannerUtils get instance => _instance;

  VietQRScannedDTO getBankAccountFromQR(String qr) {
    VietQRScannedDTO result = const VietQRScannedDTO(
      caiValue: '',
      bankAccount: '',
    );
    try {
      if (qr.isNotEmpty) {
        if (qr.contains(VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID)) {
          String mechantAccountInformationLength = qr
              .split(VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID)[1]
              .substring(0, 2);
          LOG.info(
              'mechantAccountInformationLength: $mechantAccountInformationLength');
          String mechantAccountInformationValue = '';
          //14
          int length =
              (int.tryParse(mechantAccountInformationLength) ?? 0) + 14;
          mechantAccountInformationValue = qr.substring(14, length);
          LOG.info(
              'mechantAccountInformationValue: $mechantAccountInformationValue');
          //cut NAPAIS_AID
          String information = '';
          if (mechantAccountInformationValue.isNotEmpty) {
            information =
                mechantAccountInformationValue.split(AID.AID_NAPAS)[1];
          }
          LOG.info('information: $information');
          //get CAI length
          if (information.contains(VietQRId.PAYLOAD_FORMAT_INDICATOR_ID)) {
            String caiLength = information.substring(6, 8);
            if (information.substring(6, 8).isNotEmpty) {
              // LOG.info('caiLength: $caiLength');
              String caiValue =
                  information.substring(8, int.parse(caiLength) + 8);
              String bankAccountInformation = information.split(caiValue)[1];
              // LOG.info(
              //     'Bank Account bankAccountInformation: $bankAccountInformation');
              String bankAccountLength = bankAccountInformation.substring(2, 4);
              String bankAccount = bankAccountInformation.substring(
                  4, int.parse(bankAccountLength) + 4);
              LOG.info('CAI value: $caiValue');
              LOG.info('Bank Account: $bankAccount');
              result = VietQRScannedDTO(
                  caiValue: caiValue, bankAccount: bankAccount);
            }
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }

    return result;
  }

  Future<TypeQR> checkScan(String code) async {
    VietQRScannedDTO vietQRScannedDTO =
        QRScannerUtils.instance.getBankAccountFromQR(code);
    if (vietQRScannedDTO.caiValue.isNotEmpty &&
        vietQRScannedDTO.bankAccount.isNotEmpty) {
      return TypeQR.QR_BANK;
    } else if (code.contains('|')) {
      return TypeQR.QR_CMT;
    } else if (code.trim().contains('VQRID')) {
      return TypeQR.QR_ID;
    } else if (code.trim().contains('http') || code.trim().contains('https')) {
      return TypeQR.QR_LINK;
    } else if (code.trim().contains('VCARD')) {
      return TypeQR.QR_VCARD;
    } else if (code.toUpperCase().trim().contains('VHI') ||
        code.toUpperCase().trim().contains('TSE') ||
        code.toUpperCase().trim().contains('VTS')) {
      return TypeQR.QR_SALE;
    } else {
      // if (code.trim().endsWith('=')) {
      //   String dec = AESConvert.decrypt(code);
      //   if (dec.contains(AESConvert.accessKey)) {
      //     if (UserInformationHelper.instance.getUserId().isEmpty) {
      //       return TypeQR.NEGATIVE_TWO;
      //     }
      //     return TypeQR.LOGIN_WEB;
      //   }
      // }
    }
    return TypeQR.OTHER;
  }
}
