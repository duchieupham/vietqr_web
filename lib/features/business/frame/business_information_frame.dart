import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 380,
                                    height: height - 110,
                                    child: ListView(
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 20),
                                      shrinkWrap: true,
                                      children: widget1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: height - 110,
                                      child: ListView(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        shrinkWrap: true,
                                        children: widget2,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox.shrink())
                                ],
                              ),
                              const FooterWeb(),
                            ],
                          ),
                        )
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
