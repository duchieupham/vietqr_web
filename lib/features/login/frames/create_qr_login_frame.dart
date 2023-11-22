import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:flutter/material.dart';

class CreateQRLoginFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget1;
  final Widget widget2;
  final Widget menuTop;
  final Widget bottom;

  const CreateQRLoginFrame({
    super.key,
    required this.width,
    required this.height,
    required this.widget1,
    required this.widget2,
    required this.menuTop,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
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
        child: (PlatformUtils.instance.resizeWhen(width, 750))
            ? Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    ),
                    child: menuTop,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 640,
                                child: widget1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 10),
                                  child: widget2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  bottom,
                ],
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    ),
                    child: menuTop,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView(
                        children: [
                          widget1,
                          const SizedBox(
                            height: 40,
                          ),
                          widget2,
                        ],
                      ),
                    ),
                  ),
                  const FooterWeb(
                    showListBank: false,
                    bgColor: AppColor.WHITE,
                  )
                ],
              ),
      ),
    );
  }
}
