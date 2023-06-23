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
        image: DecorationImage(
          image: AssetImage('assets/images/bg-qr.png'),
          fit: BoxFit.cover,
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
                      BoxLayout(
                        width: 400,
                        height: 800,
                        borderRadius: 20,
                        bgColor: Theme.of(context).canvasColor,
                        enableShadow: true,
                        child: widget1,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: BoxLayout(
                          width: width - 90,
                          height: 800,
                          borderRadius: 20,
                          enableShadow: true,
                          padding: EdgeInsets.zero,
                          child: widget2,
                        ),
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
