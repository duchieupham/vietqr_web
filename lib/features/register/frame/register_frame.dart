import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';

class RegisterFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget mobileChildren;
  final Widget webChildren;

  const RegisterFrame({
    super.key,
    required this.width,
    required this.height,
    required this.mobileChildren,
    required this.webChildren,
  });

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
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
      child: (PlatformUtils.instance.resizeWhen(width, 600))
          ? SingleChildScrollView(
              child: BoxLayout(
                width: 450,
                height: 550,
                borderRadius: 5,
                enableShadow: true,
                child: webChildren,
              ),
            )
          : BoxLayout(
              width: 400,
              height: 550,
              borderRadius: 5,
              enableShadow: true,
              child: webChildren,
            ),
    );
  }
}
