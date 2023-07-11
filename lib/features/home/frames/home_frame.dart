import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/guide_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFrame extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  const HomeFrame({
    super.key,
    required this.widget1,
    required this.widget2,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height - 60,
      child: (PlatformUtils.instance.resizeWhen(width, 600))
          ? SizedBox(
              width: width,
              height: height,
              child: Row(
                children: [
                  Expanded(child: widget1),
                  SizedBox(
                    width: 400,
                    height: height - 60,
                    child: widget2,
                  ),
                ],
              ),
            )
          : const WebMobileBlankWidget(),
    );
  }
}
