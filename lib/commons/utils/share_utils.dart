import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/models/qr_generated_dto.dart';

class ShareUtils {
  const ShareUtils._privateConsrtructor();

  static const ShareUtils _instance = ShareUtils._privateConsrtructor();
  static ShareUtils get instance => _instance;

  String getTextSharing(QRGeneratedDTO dto) {
    String result = '';
    String prefix =
        '${dto.bankAccount}\n${dto.userBankName}\n${dto.bankCode} - ${dto.bankName}';
    String suffix = '';
    if (dto.amount.isNotEmpty && dto.amount != '0') {
      suffix =
          '\n${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND\n';
      if (dto.content.isNotEmpty) {
        suffix += dto.content;
      }
    }
    result = prefix + suffix;
    return result;
  }
}
