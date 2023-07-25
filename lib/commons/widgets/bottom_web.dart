import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomWeb extends StatelessWidget {
  final Color? bgColor;
  const BottomWeb({super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: bgColor,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông tin liên hệ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      'Email: ',
                      style: TextStyle(color: DefaultTheme.GREY_TEXT),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'mailto',
                        path: 'sales@vietqr.vn',
                      );
                      await launchUrl(launchUri);
                    },
                    child: const Text(
                      'sales@vietqr.vn',
                      style: TextStyle(
                        color: DefaultTheme.BLUE_TEXT,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      'Hotline: ',
                      style: TextStyle(color: DefaultTheme.GREY_TEXT),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '19006234',
                      );
                      await launchUrl(launchUri);
                    },
                    child: const Text(
                      '19006234',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Text(' - '),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '0922333636',
                      );
                      await launchUrl(launchUri);
                    },
                    child: const Text(
                      '09.2233.3636',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
              child: PlatformUtils.instance.resizeWhen(width, 750)
                  ? _buildButtonInstallApp()
                  : const SizedBox.shrink()),
          Image.asset(
            'assets/images/logo-vietqr-vn.png',
            width: 120,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonInstallApp() {
    return Column(
      children: [
        const Text(
          'Tải ứng dụng trên cửa hàng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600
              // fontWeight: FontWeight.bold,
              ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                width: 300,
                text: 'App Store',
                assetImage: 'assets/images/logo-app-store.png',
                onTap: () async {
                  await launchUrl(Uri.parse(
                      'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                },
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              _buildButton(
                width: 300,
                text: 'Google Play',
                assetImage: 'assets/images/logo-google-play.png',
                onTap: () async {
                  await launchUrl(Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required double width,
    required String text,
    required String assetImage,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: BoxLayout(
        width: width * 0.4,
        height: 35,
        padding: const EdgeInsets.all(0),
        bgColor: DefaultTheme.BLACK,
        borderRadius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetImage,
              width: 18,
              height: 18,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tải ứng dụng trên',
                  style: TextStyle(color: DefaultTheme.WHITE, fontSize: 6),
                ),
                Text(
                  text,
                  style:
                      const TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
