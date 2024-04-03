import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:flutter/material.dart';

class TopUpFrame extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;

  const TopUpFrame({
    super.key,
    required this.widget1,
    required this.widget2,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
        width: width,
        height: height,
        child: (PlatformUtils.instance.resizeWhen(width, 1000))
            ? Column(
                children: [
                  const HeaderWidget(
                    isHeaderGuest: true,
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: height - 60,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shrinkWrap: true,
                            children: [widget1, widget2],
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                ],
              )
            : const WebMobileBlankWidget());
  }
}
