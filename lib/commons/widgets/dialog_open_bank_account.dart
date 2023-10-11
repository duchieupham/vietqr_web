import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/configurations/theme.dart';
import 'button_widget.dart';

class DialogOpenBankAccount extends StatelessWidget {
  const DialogOpenBankAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          SizedBox(
            width: width,
            child: Row(
              children: [
                const Text(
                  'Mở tài khoản MB',
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
          const Padding(padding: EdgeInsets.only(top: 20)),
          _buildLogo(),
          const Padding(padding: EdgeInsets.only(top: 25)),
          ..._buildTextIntro(),
          const Spacer(),
          ButtonWidget(
            text: 'ĐĂNG KÝ NGAY',
            height: 40,
            textColor: AppColor.WHITE,
            width: 160,
            bgColor: AppColor.MB_BLUE,
            borderRadius: 8,
            function: () async {
              await launchUrl(
                Uri.parse('https://l.linklyhq.com/l/1nhYI'),
                webOnlyWindowName: '_blank',
              );
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo-mb.png',
          width: 100,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          'assets/images/logo-vietqr-vn.png',
          width: 110,
          fit: BoxFit.contain,
        )
      ],
    );
  }

  List<Widget> _buildTextIntro() {
    return [
      const Text(
        'Đăng kí xong ngay\nTiền về liền tay',
        style: TextStyle(
            fontSize: 24,
            color: AppColor.MB_BLUE,
            fontWeight: FontWeight.bold),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          'Miễn phí chọn số tài khoản trùng số điện thoại',
          style: TextStyle(color: AppColor.MB_RED, fontSize: 16),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          'Nhận ngay 30.000 VND khi đăng ký thành công',
          style: TextStyle(color: AppColor.MB_BLUE, fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: RichText(
          text: const TextSpan(
            text: 'Cơ hội ',
            style: TextStyle(color: AppColor.MB_BLUE, fontSize: 16),
            children: <TextSpan>[
              TextSpan(
                  text: 'nhận thêm 10.000.000 VND++\n',
                  style: TextStyle(color: AppColor.MB_RED, fontSize: 16)),
              TextSpan(
                  text: 'khi giới thiệu bạn bè, người thân sử dụng App MBBank!',
                  style: TextStyle(color: AppColor.MB_BLUE, fontSize: 16)),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          'App MBBank - miễn phí chuyển khoản liên ngân hàng\ntrọn đời và lựa chọn tài khoản Số đẹp miễn phí.',
          style: TextStyle(color: AppColor.MB_BLUE, fontSize: 16),
        ),
      ),
    ];
  }
}
