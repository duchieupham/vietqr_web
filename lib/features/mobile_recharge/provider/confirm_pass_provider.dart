import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/mobile_recharge/repositories/mobile_recharge_repository.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class ConfirmPassProvider extends ChangeNotifier {
  MobileRechargeRepository mobileRechargeRepository =
      const MobileRechargeRepository();
  bool _errorPass = false;
  bool get errorPass => _errorPass;

  String _pass = '';
  String get pass => _pass;

  bool _completedInput = false;
  bool get completedInput => _completedInput;

  updateErrorPass(bool value) {
    _errorPass = value;

    notifyListeners();
  }

  changePass(String value) {
    _pass = value;
    if (_pass.length == 6) {
      onCompleted(true);
    } else {
      onCompleted(false);
    }
  }

  onCompleted(bool value) {
    _completedInput = value;
    notifyListeners();
  }

  Future requestPayment(String pass,
      {required Function(String) onConfirmSuccess}) async {
    DialogWidget.instance.openLoadingDialog(msg: 'Đang xác thực mật khẩu');
    Map<String, dynamic> data = {};
    String passWord = EncryptUtils.instance.encrypted(
      UserInformationHelper.instance.getPhoneNo(),
      pass,
    );
    data['password'] = passWord;
    data['userId'] = UserInformationHelper.instance.getUserId();
    data['paymentType'] = 1;

    ResponseMessageDTO responseMessageDTO =
        await mobileRechargeRepository.requestPayment(data);

    if (responseMessageDTO.status == 'SUCCESS') {
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
      onConfirmSuccess(responseMessageDTO.message);
      updateErrorPass(false);
    }

    _handleError(responseMessageDTO);
  }

  _handleError(ResponseMessageDTO responseMessageDTO) {
    if (responseMessageDTO.status == 'FAILED') {
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
      if (responseMessageDTO.message == 'E55') {
        updateErrorPass(true);
      } else {
        DialogWidget.instance.openMsgDialog(
            title: 'Nạp tiền thất bại',
            msg: ErrorUtils.instance
                .getErrorMessage(responseMessageDTO.message));
      }
    }
    if (responseMessageDTO.message == '') {
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
      DialogWidget.instance.openMsgDialog(
          title: 'Nạp tiền thất bại',
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message));
    }
  }
}
