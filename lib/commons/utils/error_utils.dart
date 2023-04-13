import 'package:VietQR/commons/enums/error_type.dart';

class ErrorUtils {
  const ErrorUtils._privateConsrtructor();

  static const ErrorUtils _instance = ErrorUtils._privateConsrtructor();
  static ErrorUtils get instance => _instance;

  String getErrorMessage(String message) {
    String result = '';
    ErrorType errorType =
        (ErrorType.values.toString().contains('ErrorType.$message') &&
                message != '')
            ? ErrorType.values.byName(message)
            : ErrorType.E04;

    switch (errorType) {
      case ErrorType.E01:
        result = 'Mật khẩu cũ không khớp';
        break;
      case ErrorType.E02:
        result = 'Tài khoản đã tồn tại';
        break;
      case ErrorType.E03:
        result = 'Không thể tạo tài khoản';
        break;
      case ErrorType.E04:
        result = 'Không thể thực hiện thao tác này. Vui lòng thử lại sau';
        break;
      case ErrorType.E05:
        result = 'Đã có lỗi xảy ra, vui lòng thử lại sau';
        break;
      case ErrorType.E06:
        result =
            'Không thể liên kết. Tài khoản ngân hàng này đã được thêm trước đó';
        break;
      case ErrorType.E07:
        result = 'Thành viên không tồn tài trong hệ thống';
        break;
      case ErrorType.E08:
        result = 'Thành viên đã được thêm vào tài khoản trước đó';
        break;
      case ErrorType.E09:
        result = 'Không thể thêm thành viên vào tài khoản';
        break;
      case ErrorType.E10:
        result = 'Không thể thêm mẫu nội dung chuyển khoản';
        break;
      case ErrorType.E11:
        result = 'Không thể xoá mẫu nội dung chuyển khoản';
        break;
      case ErrorType.E12:
        result =
            'Không thể liên kết. Tài khoản thanh toán này đã được thêm trước đó';
        break;
      case ErrorType.E13:
        result = 'Thêm tài khoản thanh toán thất bại';
        break;
      case ErrorType.E14:
        result = 'Không thể tạo doanh nghiệp';
        break;
      case ErrorType.E15:
        result = 'CMND/CCCD không hợp lệ';
        break;
      case ErrorType.E16:
        result = 'Trạng thái TK ngân hàng không hợp lệ';
        break;
      case ErrorType.E17:
        result = 'TK ngân hàng không hợp lệ';
        break;
      case ErrorType.E18:
        result = 'Tên chủ TK không hợp lệ';
        break;
      case ErrorType.E19:
        result = 'Số điện thoại không hợp lệ';
        break;
      case ErrorType.E20:
        result = 'TK ngân hàng không tồn tại';
        break;
      case ErrorType.E21:
        result = 'Có vấn đề xảy ra khi gửi OTP. Vui lòng thử lại sau';
        break;
      case ErrorType.E22:
        result = 'Không thể đăng ký nhận BĐSD. Vui lòng thử lại sau';
        break;
      case ErrorType.E23:
        result = 'TK đã đăng ký nhận BĐSD';
        break;
      default:
        result = message;
    }
    return result;
  }
}
