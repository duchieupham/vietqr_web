import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWeb extends StatelessWidget {
  final Color? bgColor;
  const FooterWeb({super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 580) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                              style: TextStyle(color: AppColor.GREY_TEXT),
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
                              style: TextStyle(color: AppColor.GREY_TEXT),
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
                  const Spacer(),
                  Image.asset(
                    'assets/images/logo-vietqr-vn.png',
                    width: 80,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _buildButtonInstallApp(isVertical: constraints.maxWidth < 880),
              const SizedBox(
                height: 20,
              ),
              _buildUrlSystem(isVertical: constraints.maxWidth < 980),
            ],
          ),
        );
      }
      return Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        color: AppColor.BLUE_TEXT.withOpacity(0.2),
        child: Row(
          children: [
            const Text(
              'Thông tin liên hệ: ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
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
            const Spacer(),
            const Text(
              'Tải ứng dụng trên cửa hàng:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600
                  // fontWeight: FontWeight.bold,
                  ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            _buildButton(
              width: 280,
              text: 'App Store',
              assetImage: 'assets/images/logo-app-store.png',
              onTap: () async {
                await launchUrl(Uri.parse(
                    'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
              },
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            _buildButton(
              width: 280,
              text: 'Google Play',
              assetImage: 'assets/images/logo-google-play.png',
              onTap: () async {
                await launchUrl(Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
              },
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildButtonInstallApp({bool isVertical = false}) {
    return Column(
      crossAxisAlignment:
          isVertical ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (!isVertical) ...[
          const Text(
            'Tải ứng dụng trên cửa hàng',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600
                // fontWeight: FontWeight.bold,
                ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
        if (isVertical)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButton(
                width: 280,
                text: 'App Store',
                assetImage: 'assets/images/logo-app-store.png',
                onTap: () async {
                  await launchUrl(Uri.parse(
                      'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              _buildButton(
                width: 280,
                text: 'Google Play',
                assetImage: 'assets/images/logo-google-play.png',
                onTap: () async {
                  await launchUrl(Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                },
              ),
            ],
          )
        else
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  width: 280,
                  text: 'App Store',
                  assetImage: 'assets/images/logo-app-store.png',
                  onTap: () async {
                    await launchUrl(Uri.parse(
                        'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                  },
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                _buildButton(
                  width: 280,
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

  Widget _buildUrlSystem({bool isVertical = false}) {
    if (!isVertical) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hệ thống VietQR VN:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600
                // fontWeight: FontWeight.bold,
                ),
          ),
          const Padding(padding: EdgeInsets.only(top: 25)),
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildItemTitle('vietqr.vn'),
                const SizedBox(
                    height: 12,
                    child: VerticalDivider(
                      color: AppColor.GREY_LIGHT,
                    )),
                _buildItemTitle('vietqr.com'),
                const SizedBox(
                    height: 12,
                    child: VerticalDivider(
                      color: AppColor.GREY_LIGHT,
                    )),
                _buildItemTitle('vietqr.org'),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hệ thống VietQR VN:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600
              // fontWeight: FontWeight.bold,
              ),
        ),
        const Padding(padding: EdgeInsets.only(top: 25)),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItemTitle('vietqr.vn'),
              const SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    color: AppColor.GREY_LIGHT,
                  )),
              _buildItemTitle('vietqr.com'),
              const SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    color: AppColor.GREY_LIGHT,
                  )),
              _buildItemTitle('vietqr.org'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemTitle(String text) {
    return GestureDetector(
      onTap: () async {
        await launchUrl(Uri.parse('https://$text'));
      },
      child: Text(
        text,
        style: const TextStyle(
            decoration: TextDecoration.underline, color: AppColor.BLUE_TEXT),
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
