import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/pin_code_input.dart';
import 'package:VietQR/features/mobile_recharge/provider/confirm_pass_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupConfirmPassword extends StatelessWidget {
  final Function(String) onConfirmSuccess;
  PopupConfirmPassword({Key? key, required this.onConfirmSuccess})
      : super(key: key);

  final TextEditingController _passEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ChangeNotifierProvider<ConfirmPassProvider>(
        create: (context) => ConfirmPassProvider(),
        child:
            Consumer<ConfirmPassProvider>(builder: (context, provider, child) {
          return Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Xác nhận lại mật khẩu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Nhập lại mật khẩu để thực hiện nạp tiền điện thoại',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 32)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: PinCodeInput(
                  obscureText: true,
                  controller: _passEditingController,
                  autoFocus: true,
                  onChanged: provider.changePass,
                  onCompleted: (value) {
                    provider.requestPayment(value,
                        onConfirmSuccess: onConfirmSuccess);
                  },
                ),
              ),
              if (provider.errorPass)
                const Text(
                  'Mật khẩu không đúng, vui lòng thử lại',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              const SizedBox(
                height: 8,
              ),
              const Spacer(),
              ButtonWidget(
                text: 'Xác nhận',
                borderRadius: 5,
                height: 40,
                textSize: 14,
                function: () {
                  if (provider.completedInput) {
                    provider.requestPayment(provider.pass,
                        onConfirmSuccess: onConfirmSuccess);
                  } else {
                    provider.updateErrorPass(true);
                  }
                },
                textColor: AppColor.WHITE,
                bgColor: AppColor.BLUE_TEXT,
              ),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                  text: 'Huỷ',
                  borderRadius: 5,
                  height: 40,
                  textSize: 14,
                  textColor: AppColor.BLACK,
                  bgColor: AppColor.GREY_BUTTON,
                  function: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        }),
      ),
    );
  }
}
