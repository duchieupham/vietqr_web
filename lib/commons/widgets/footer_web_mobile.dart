import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterMobileWeb extends StatefulWidget {
  const FooterMobileWeb({super.key});

  @override
  State<FooterMobileWeb> createState() => _FooterWebState();
}

class _FooterWebState extends State<FooterMobileWeb> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: AppColor.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giới thiệu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              'VietQR là chuẩn thanh toán QR của EMV Co.\nGiao dịch nhanh chóng, đơn giản hóa trải nghiêm và tăng tốc độ thanh toán thông qua việc quét mã QR. VietQR được phát triển nhằm tạo sự thanh toán thuận tiện cho mọi người.',
              style: TextStyle(
                  fontSize: 12, color: AppColor.BLACK.withOpacity(0.8)),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          _buildUrlSystem(),
          const SizedBox(
            height: 12,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Thông tin liên hệ:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 16,
                color: AppColor.BLACK,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Email:   ',
                style: TextStyle(
                  fontSize: 12,
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
                    color: AppColor.BLUE_TEXT,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 12)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone_rounded,
                size: 16,
                color: AppColor.BLACK,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Hotline:   ',
                style: TextStyle(
                  fontSize: 12,
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
                  '1900.6234',
                  style: TextStyle(
                    color: AppColor.BLUE_TEXT,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text('  -  '),
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
                    color: AppColor.BLUE_TEXT,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          _buildSocial(),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Tải ứng dụng VietQR VN qua',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildButtonInstallApp(),
        ],
      ),
    );
  }

  Widget _buildButtonInstallApp() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            width: 260,
            text: 'App Store',
            assetImage: AppImages.logoAppStore,
            onTap: () async {
              await launchUrl(Uri.parse(
                  'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          _buildButton(
            width: 260,
            text: 'Google Play',
            assetImage: AppImages.logoGooglePlay,
            onTap: () async {
              await launchUrl(Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUrlSystem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trang web của chúng tôi',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600
              // fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            _buildItemTitle('vietqr.vn'),
            const SizedBox(
              width: 16,
            ),
            // const SizedBox(
            //     height: 12,
            //     child: VerticalDivider(
            //       color: AppColor.GREY_LIGHT,
            //     )),
            _buildItemTitle('vietqr.com'),
            // const SizedBox(
            //     height: 12,
            //     child: VerticalDivider(
            //       color: AppColor.GREY_LIGHT,
            //     )),
            const SizedBox(
              width: 16,
            ),
            _buildItemTitle('vietqr.org'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mạng xã hội',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600
              // fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Image(
              image: ImageUtils.instance.getImageNetWork(AppImages.logoFB),
              width: 28,
              height: 28,
            ),
            const SizedBox(
              width: 12,
            ),
            Image(
              image: ImageUtils.instance.getImageNetWork(AppImages.logoTele),
              width: 28,
              height: 28,
            ),
            const SizedBox(
              width: 12,
            ),
            Image(
              image: ImageUtils.instance.getImageNetWork(AppImages.logoYTB),
              width: 28,
              height: 28,
            ),
            const SizedBox(
              width: 12,
            ),
            Image(
              image: ImageUtils.instance.getImageNetWork(AppImages.logoZL),
              width: 28,
              height: 28,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemTitle(String text) {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse('https://$text'));
      },
      child: Text(
        text,
        style: const TextStyle(
            decoration: TextDecoration.underline,
            color: AppColor.BLUE_TEXT,
            fontSize: 12),
      ),
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
        height: 28,
        padding: const EdgeInsets.all(0),
        bgColor: AppColor.BLACK,
        borderRadius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: ImageUtils.instance.getImageNetWork(assetImage),
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
                  style: TextStyle(color: AppColor.WHITE, fontSize: 6),
                ),
                Text(
                  text,
                  style: const TextStyle(color: AppColor.WHITE, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
