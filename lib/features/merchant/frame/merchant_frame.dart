import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:flutter/material.dart';

class MerchantFrame extends StatelessWidget {
  final Widget table;
  final Widget menu;

  const MerchantFrame({
    super.key,
    required this.table,
    required this.menu,
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
        child: (PlatformUtils.instance.resizeWhen(width, 1000))
            ? Column(
                children: [
                  const HeaderWidget(),
                  Expanded(
                    child: Row(
                      children: [
                        menu,
                        Expanded(
                          child: SizedBox(
                            height: height - 60,
                            child: table,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const WebMobileBlankWidget(),
      ),
    );
  }
}
