import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:flutter/material.dart';

class TransactionFrame extends StatelessWidget {
  final Widget title;
  final Widget menu;
  final Widget child;

  const TransactionFrame({
    super.key,
    required this.title,
    required this.menu,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        width: width,
        height: height - 60,
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
        child: (PlatformUtils.instance.resizeWhen(width, 650))
            ? Column(
                children: [
                  const HeaderWidget(),
                  Expanded(
                    child: Row(
                      children: [
                        menu,
                        Expanded(child: child),
                      ],
                    ),
                  ),
                  // const FooterWeb(),
                ],
              )
            : const WebMobileBlankWidget(),
      ),
    );
  }
}
