import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ECOMPolicyBankWidget extends StatelessWidget {
  final String bankAccount;

  const ECOMPolicyBankWidget({
    super.key,
    required this.bankAccount,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Text(
                'Điều khoản dịch vụ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Kính gửi Quý Khách hàng,\n'),
                  const TextSpan(text: 'MBBank và Bluecom ('),
                  TextSpan(
                    text: 'vietqr.vn',
                    style: const TextStyle(
                      color: DefaultTheme.GREEN,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        html.window.open('https://vietqr.vn', '_blank');
                      },
                  ),
                  const TextSpan(
                      text:
                          ') xin gửi đến Quý Khách Điều khoản và điều kiện sử dụng dịch vụ nhận biến động số dư trên tài khoản số "'),
                  TextSpan(
                    text: bankAccount,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                      text:
                          '" của Quý khách mở tại ngân hàng MBBank. Căn cứ theo Hợp đồng Hợp tác số 01/2023/HĐDV/MB-BLUECOM ký ngày 09 tháng 03 năm 2023. Chi tiết tại đường link: '),
                  TextSpan(
                    text: 'https://vietqr.vn/mbbank-dkdv/',
                    style: const TextStyle(
                      color: DefaultTheme.GREEN,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        html.window
                            .open('https://vietqr.vn/mbbank-dkdv/', '_blank');
                      },
                  ),
                  const TextSpan(
                      text:
                          '\n\nQuý Khách vui lòng xác nhận đã đọc, hiểu và đồng ý sử dụng dịch vụ bằng cách nhập mã OTP do ngân hàng TMCP Quân đội gửi đến số điện thoại của Quý khách. Xin cảm ơn Quý Khách đã sử dụng dịch vụ của chúng tôi.'),
                ],
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              SizedBox(
                width: 30,
                height: 30,
                child: Consumer<BankTypeProvider>(
                  builder: (context, provider, child) {
                    return Checkbox(
                      activeColor: DefaultTheme.GREEN,
                      value: provider.agreeWithPolicy,
                      shape: const CircleBorder(),
                      onChanged: (bool? value) {
                        provider.updateAgreePolicy(value!);
                      },
                    );
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              const Text(
                'Tôi đã đọc và đồng ý với các điều khoản',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Consumer<BankTypeProvider>(
          builder: (context, provider, child) {
            return ButtonWidget(
              width: 600 - 40,
              height: 40,
              borderRadius: 5,
              text: 'Xác thực',
              textColor: DefaultTheme.WHITE,
              bgColor: (provider.agreeWithPolicy)
                  ? DefaultTheme.GREEN
                  : DefaultTheme.GREY_TOP_TAB_BAR,
              function: () {
                Navigator.pop(context, true);
              },
            );
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
      ],
    );
  }
}
