import 'dart:io';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceSection extends StatefulWidget {
  const ServiceSection({Key? key}) : super(key: key);

  @override
  State<ServiceSection> createState() => _ServiceSectionState();
}

class _ServiceSectionState extends State<ServiceSection> {
  bool isCheckApp = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Dịch vụ',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildListService(context),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Mạng xã hội',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildSocialNetwork(context)
      ],
    );
  }

  Widget _buildSocialNetwork(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        _buildItemService(
            context, 'assets/images/logo-telegram-dash.png', 'Telegram',
            () async {
          // Navigator.pushNamed(context, Routes.CONNECT_TELEGRAM);
        }),
        _buildItemService(context, 'assets/images/logo-lark-dash.png', 'Lark',
            () async {
          // Navigator.pushNamed(context, Routes.CONNECT_LARK);
        }),
      ],
    );
  }

  Widget _buildListService(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        _buildItemService(context, 'assets/images/ic-vqr-3D-unit.png',
            'Nạp tiền dịch vụ VietQR', () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
        }, isFirst: true),
        _buildItemService(context, 'assets/images/logo-mobile-money-3D.png',
            'Nạp tiền\nđiện thoại', () {
          // Navigator.pushNamed(context, Routes.MOBILE_RECHARGE);
        }),
        _buildItemService(context, 'assets/images/ic-mb.png', 'Mở TK\nMB Bank',
            () {
          _launchUrl();
        }),
        _buildItemService(
            context,
            'assets/images/logo-vietqr-kiot-dashboard.png',
            'VietQR Kiot\n', () async {
          if (PlatformUtils.instance.isAndroidApp()) {
            // final intent = AndroidIntent(
            //     action: 'action_view',
            //     data: Uri.encodeFull(
            //         'https://play.google.com/store/apps/details?id=com.vietqr.kiot&hl=en_US'),
            //     package: 'com.vietqr.kiot');
            // intent.launch();
          } else if (PlatformUtils.instance.isIOsApp()) {
            await DialogWidget.instance.openMsgDialog(
              title: 'Thông báo',
              msg:
                  'Chúng tôi đang bảo trì VietQR Kiot cho nền tảng iOS. Tính năng này sẽ sớm phụ vụ quý khách.',
              function: () {
                Navigator.pop(context);
              },
            );
          }
        }),
        _buildItemService(
          context,
          'assets/images/ic-business-3D.png',
          'Đăng ký Merchant',
          () async {
            // Navigator.pushNamed(context, Routes.BUSINESS);
          },
        ),
      ],
    );
  }

  Future<void> _launchUrl() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/search?q=mbbank&c=apps&hl=vi-VN';
    } else {
      url = 'https://apps.apple.com/vn/app/mb-bank/id1205807363?l=vi';
    }

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Widget _buildItemService(
      BuildContext context, String pathIcon, String title, VoidCallback onTap,
      {bool isFirst = false}) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: getDeviceType() == 'phone' ? width / 5 - 7 : 70,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isFirst
                ? Container(
                    padding: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(pathIcon, height: 44))
                : Image.asset(pathIcon, height: 45),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
}
