import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';

class LoginFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget1;
  final Widget widget2;
  final Widget menuTop;

  const LoginFrame({
    super.key,
    required this.width,
    required this.height,
    required this.widget1,
    required this.widget2,
    required this.menuTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.WHITE,
            AppColor.BLUE_LIGHT,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: (PlatformUtils.instance.resizeWhen(width, 750))
          ? Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  ),
                  child: menuTop,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: widget2,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          BoxLayout(
                            width: 500,
                            borderRadius: 16,
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            bgColor: AppColor.WHITE,
                            child: widget1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const FooterWeb(
                  showListBank: true,
                )
              ],
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  ),
                  child: menuTop,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: BoxLayout(
                      width: width * 0.8,
                      borderRadius: 5,
                      enableShadow: true,
                      child: widget1,
                    ),
                  ),
                ),
                const FooterWeb(
                  showListBank: false,
                  bgColor: AppColor.WHITE,
                )
              ],
            ),
    );
  }
}
