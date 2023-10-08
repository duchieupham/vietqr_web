import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:flutter/material.dart';

class BusinessInformationFrame extends StatelessWidget {
  final List<Widget> widget1;
  final List<Widget> widget2;
  final Widget menu;

  const BusinessInformationFrame({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      child: SizedBox(
        width: width,
        height: height - 60,
        child: (PlatformUtils.instance.resizeWhen(width, 1000))
            ? Column(
              children: [
                const HeaderWidget(),
                Expanded(
                  child: Row(
                      children: [
                        menu,
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
                          flex: 3,
                          child: SizedBox(
                            height: height - 60,
                            child: ListView(
                              padding: const EdgeInsets.only(right: 20),
                              shrinkWrap: true,
                              children: widget2,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink())
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
