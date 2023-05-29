import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebMobileBlankWidget extends StatelessWidget {
  const WebMobileBlankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BoxLayout(
      borderRadius: 10,
      bgColor: Theme.of(context).cardColor,
      width: 350,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/ic-viet-qr.png',
              width: 100,
              height: 100,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Xin chào,\nchúng tôi khuyến khích bạn tải ứng dụng trên chợ Android/iOS để có những trải nghiệm tốt hơn.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: () async {
                await launchUrl(Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.vietqr.product'));
              },
              child: RichText(
                text: const TextSpan(
                  text: 'Android: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            'https://play.google.com/store/apps/details?id=com.vietqr.product',
                        style: TextStyle(
                          fontSize: 15,
                          color: DefaultTheme.BANNER_DAY1,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        )),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'iOS: (đang cập nhật)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text:
                  'Nếu bạn có bất kỳ câu hỏi hoặc thắc mắc nào, xin vui lòng liên hệ với chúng tôi qua hotline ',
              style: const TextStyle(
                fontSize: 15,
                color: DefaultTheme.BLACK,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '19006234',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: '19006234',
                        );
                        await launchUrl(launchUri);
                      },
                    style: const TextStyle(
                      fontSize: 15,
                      color: DefaultTheme.BLACK,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    )),
                const TextSpan(
                    text:
                        '. Chúc bạn có một trải nghiệm tuyệt vời khi sử dụng dịch vụ của chúng tôi.\nTrân trọng.',
                    style: TextStyle(
                      fontSize: 15,
                      color: DefaultTheme.BLACK,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
