import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupQrWidget extends StatefulWidget {
  String qrValue;
  PopupQrWidget({super.key, required this.qrValue});

  @override
  State<PopupQrWidget> createState() => _PopupQrWidgetState();
}

class _PopupQrWidgetState extends State<PopupQrWidget> {
  bool isLoginSelected = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 400,
      padding: const EdgeInsets.all(0.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF458BF8),
            Color(0xFFFF8021),
            Color(0xFFFF3751),
            Color(0xFFC958DB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoginSelected = true;
                        });
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) => isLoginSelected
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds)
                            : const LinearGradient(
                                colors: [Colors.black, Colors.black],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                        child: Text(
                          'QR đăng nhập',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoginSelected = false;
                        });
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) => !isLoginSelected
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds)
                            : const LinearGradient(
                                colors: [Colors.black, Colors.black],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                        child: Text(
                          'QR tải ứng dụng',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoginSelected
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoxLayout(
                          width: 250,
                          height: 250,
                          borderRadius: 20,
                          alignment: Alignment.center,
                          bgColor: AppColor.WHITE,
                          padding: const EdgeInsets.all(8),
                          child: QrImageView(
                            data: widget.qrValue,
                            size: 250,
                            // embeddedImage: const AssetImage(
                            //     'assets/images/ic-viet-qr-small.png'),
                            // embeddedImageStyle: const QrEmbeddedImageStyle(
                            //   size: Size(30, 30),
                            // ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Quét mã QR đăng nhập',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                'Sử dụng ứng dụng VietQR để quét mã\nQR đăng nhập vào website tự động.'),
                            const SizedBox(height: 120),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isLoginSelected = false;
                                });
                              },
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF458BF8),
                                    Color(0xFFFF8021),
                                    Color(0xFFFF3751),
                                    Color(0xFFC958DB),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: const Text(
                                  'Bạn chưa tải ứng dụng VietQR?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoxLayout(
                          width: 250,
                          height: 250,
                          borderRadius: 20,
                          alignment: Alignment.center,
                          bgColor: AppColor.WHITE,
                          padding: const EdgeInsets.all(8),
                          child: QrImageView(
                            data: 'https://onelink.to/q7zwpe',
                            size: 250,
                            // embeddedImage: const AssetImage(
                            //     'assets/images/ic-viet-qr-small.png'),
                            // embeddedImageStyle: const QrEmbeddedImageStyle(
                            //   size: Size(30, 30),
                            // ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Quét mã QR để tải ứng dụng',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                'Tải ứng dụng VietQR trên điện thoại\ncủa bạn bằng cách quét mã QR này.\nHoặc tải ứng dụng trên cửa hàng:'),
                            const SizedBox(height: 8),
                            _buildButton(
                              width: 600,
                              text: 'App Store',
                              assetImage: AppImages.logoAppStore,
                              onTap: () async {
                                await launchUrl(Uri.parse(
                                    'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildButton(
                              width: 600,
                              text: 'Google Play',
                              assetImage: AppImages.logoGooglePlay,
                              onTap: () async {
                                await launchUrl(Uri.parse(
                                    'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
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
      height: 50,
      padding: const EdgeInsets.all(0),
      bgColor: AppColor.BLACK,
      borderRadius: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: ImageUtils.instance.getImageNetWork(assetImage),
            width: 40,
            height: 40,
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
                style: TextStyle(color: AppColor.WHITE, fontSize: 12),
              ),
              Text(
                text,
                style: const TextStyle(color: AppColor.WHITE, fontSize: 20),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
