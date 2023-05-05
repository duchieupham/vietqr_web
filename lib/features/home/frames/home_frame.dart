import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/guide_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFrame extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  final Widget menu;
  static final List<String> guideAssets = [
    'assets/images/ic-guide1.png',
    'assets/images/ic-guide2.png',
    'assets/images/ic-guide3.png',
    'assets/images/ic-guide4.png',
    'assets/images/ic-guide5.png',
  ];

  const HomeFrame({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.menu,
  });

  void _initialService(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<GuideProvider>(context, listen: false).updateIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    _initialService(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset('assets/images/bg-home-web.png').image,
        ),
      ),
      child: (PlatformUtils.instance.resizeWhen(width, 600))
          ? Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      const HeaderWidget(),
                      Row(
                        children: [
                          Expanded(child: widget1),
                          SizedBox(
                            width: 400,
                            height: height - 60,
                            child: widget2,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Consumer<MenuCardProvider>(
                  builder: (context, provider, child) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: (provider.showMenu) ? 10 : -350,
                      bottom: 10,
                      child: BoxLayout(
                        width: 350,
                        height: height - 80,
                        borderRadius: 10,
                        bgColor: Theme.of(context).cardColor,
                        child: menu,
                      ),
                    );
                  },
                ),
                Consumer<GuideProvider>(
                  builder: (context, provider, child) {
                    return (provider.guideDisabled)
                        ? const SizedBox()
                        : Container(
                            width: width,
                            height: height,
                            color: DefaultTheme.BLACK.withOpacity(0.9),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: 500,
                                //   child: Text(
                                //     'Xin chào, ${UserInformationHelper.instance.getUserFullname().trim()}',
                                //     style: const TextStyle(
                                //       color: DefaultTheme.WHITE,
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                                Image.asset(
                                  guideAssets[provider.index],
                                  width: 630,
                                ),

                                SizedBox(
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      UnconstrainedBox(
                                        child: Tooltip(
                                          message: 'Bỏ qua hướng dẫn',
                                          child: ButtonWidget(
                                            width: 250,
                                            height: 40,
                                            borderRadius: 5,
                                            // icon: Icons.close_rounded,
                                            text: 'Bỏ qua hướng dẫn',
                                            function: () {
                                              provider
                                                  .updateGuideDisabled(true);
                                              provider.updateIndex(0);
                                            },
                                            bgColor: Theme.of(context)
                                                .canvasColor
                                                .withOpacity(0.3),
                                            textColor: DefaultTheme.WHITE,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 30)),
                                      UnconstrainedBox(
                                        child: Tooltip(
                                          message: (provider.index ==
                                                  guideAssets.length - 1)
                                              ? 'Xong'
                                              : 'Tiếp theo',
                                          child: ButtonWidget(
                                            width: 250,
                                            height: 40,
                                            borderRadius: 5,
                                            // icon: Icons.navigate_next_rounded,
                                            text: (provider.index ==
                                                    guideAssets.length - 1)
                                                ? 'Xong'
                                                : 'Tiếp theo',
                                            function: () {
                                              if (provider.index ==
                                                  guideAssets.length - 1) {
                                                provider
                                                    .updateGuideDisabled(true);
                                                provider.updateIndex(0);
                                              } else {
                                                provider.updateIndex(
                                                    provider.index + 1);
                                              }
                                            },
                                            bgColor: Theme.of(context)
                                                .canvasColor
                                                .withOpacity(0.3),
                                            textColor: DefaultTheme.WHITE,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 30)),
                              ],
                            ),
                          );
                  },
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
