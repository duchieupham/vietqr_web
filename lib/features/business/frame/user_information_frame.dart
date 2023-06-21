import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:flutter/material.dart';

class BusinessInformationFrame extends StatelessWidget {
  final List<Widget> widget1;
  final List<Widget> widget2;

  const BusinessInformationFrame({
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
                  isSubHeader: true,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 380,
                      height: height - 60,
                      child: ListView(
                        padding: const EdgeInsets.only(left: 40, right: 20),
                        shrinkWrap: true,
                        children: widget1,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: height - 60,
                        child: ListView(
                          padding: const EdgeInsets.only(right: 20),
                          shrinkWrap: true,
                          children: widget2,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : const WebMobileBlankWidget(),
    );
  }
}
