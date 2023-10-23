import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';

class LoginFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget1;
  final Widget widget2;

  const LoginFrame({
    super.key,
    required this.width,
    required this.height,
    required this.widget1,
    required this.widget2,
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
      child: SingleChildScrollView(
        child: (PlatformUtils.instance.resizeWhen(width, 850))
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BoxLayout(
                          width: width - 90,
                          height: 850,
                          borderRadius: 20,
                          enableShadow: true,
                          padding: EdgeInsets.zero,
                          child: widget2,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      BoxLayout(
                        width: 400,
                        height: 850,
                        borderRadius: 20,
                        bgColor: Theme.of(context).canvasColor,
                        enableShadow: true,
                        child: widget1,
                      ),
                    ],
                  ),
                ),
              )
            : BoxLayout(
                width: width * 0.8,
                height: 430,
                borderRadius: 5,
                enableShadow: true,
                child: widget1,
              ),
      ),
    );
  }
}
