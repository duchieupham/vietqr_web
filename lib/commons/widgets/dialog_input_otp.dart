import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/countdown_time_otp.dart';
import 'package:VietQR/services/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

class DialogInputOTP extends StatelessWidget {
  const DialogInputOTP({
    Key? key,
    required this.onDone,
    required this.reSendOtp,
  }) : super(key: key);

  final Function onDone;
  final Function reSendOtp;

  Future checkVerifyOtp(String otp, BuildContext context) async {
    bool isVerify = false;
    isVerify = await Provider.of<RegisterProvider>(context, listen: false)
        .verifyOTP(otp);
    if (isVerify) {
      onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 300,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          const Text(
            'OTP',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          const SizedBox(
            width: 300,
            height: 30,
            child: Text(
              'Nhập mã sác nhận đã được ửi tới bạn qua SMS',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          Container(
            width: 350,
            height: 70,
            alignment: Alignment.center,
            child: OtpTextField(
              numberOfFields: 6,
              borderColor: DefaultTheme.GREY_TOP_TAB_BAR,
              showFieldAsBox: true,
              onCodeChanged: (String code) {},
              onSubmit: (pin) {
                checkVerifyOtp(pin, context);
              },
              autoFocus: true,
            ),
          ),
          Consumer<RegisterProvider>(
            builder: (context, value, child) {
              if (value.isVerifyOTP) {
                return const SizedBox.shrink();
              } else {
                return const Text(
                  'Sai mã OTP',
                  style: TextStyle(color: DefaultTheme.RED_TEXT, fontSize: 13),
                );
              }
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          SizedBox(
              width: 250,
              height: 45,
              child: CountDownTimeOtp(
                secondsRemaining: 120,
                onResendOtp: () {
                  reSendOtp();
                },
                whenTimeExpires: () {
                  debugPrint('------- whenTimeExpires OTP');
                },
              )),
          const Padding(padding: EdgeInsets.only(top: 20)),
          ButtonWidget(
            width: 250,
            height: 30,
            text: 'Đóng',
            textColor: DefaultTheme.WHITE,
            bgColor: DefaultTheme.GREEN,
            borderRadius: 5,
            function: () {
              Navigator.pop(context);
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }
}
