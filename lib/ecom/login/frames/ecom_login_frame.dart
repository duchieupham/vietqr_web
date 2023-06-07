import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';

class ECOMLoginFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget1;
  final Widget widget2;

  const ECOMLoginFrame({
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
                        width: 700,
                        height: 540,
                        borderRadius: 10,
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
                height: 540,
                borderRadius: 5,
                enableShadow: true,
                child: widget1,
              ),
      ),
    );
  }
}
