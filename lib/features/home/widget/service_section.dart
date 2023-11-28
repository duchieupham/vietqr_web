import 'dart:io';

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        _buildItemService(context, AppImages.logoTelegramDash, 'Telegram',
            () async {
          DialogWidget.instance.openMsgQRInstallApp();
        }),
        _buildItemService(context, AppImages.logoLarkDash, 'Lark', () async {
          DialogWidget.instance.openMsgQRInstallApp();
        }),
      ],
    );
  }

  Widget _buildListService(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        _buildItemService(
            context, AppImages.icVqr3DUnit, 'Nạp tiền dịch vụ VietQR', () {
          DialogWidget.instance.openMsgQRInstallApp();
        }, isFirst: true),
        _buildItemService(
            context, AppImages.logoMobileMoney3D, 'Nạp tiền\nđiện thoại', () {
          context.go('/naptien');
        }),
        _buildItemService(context, AppImages.icMb, 'Mở TK\nMB Bank', () {
          _launchUrl();
        }),
        _buildItemService(
            context, AppImages.logoVietqrKiotDashboard, 'VietQR Kiot\n', () {
          DialogWidget.instance.openMsgQRInstallApp();
        }),
        _buildItemService(
          context,
          AppImages.icBusiness3D,
          'Đăng ký Merchant',
          () async {
            DialogWidget.instance.openMsgQRInstallApp();
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
                    child: Image(
                        image: ImageUtils.instance.getImageNetWork(pathIcon),
                        height: 44))
                : Image(
                    image: ImageUtils.instance.getImageNetWork(pathIcon),
                    height: 45),
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
