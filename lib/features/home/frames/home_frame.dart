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
  final Widget menu;
  final Widget menuCard;
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
    required this.menuCard,
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
                Consumer<MenuProvider>(
                  builder: (context, provider, child) {
                    return Stack(
                      children: [
                        Consumer<MenuCardProvider>(
                          builder: (context, menuCardProvider, child) {
                            double position = 0;
                            if (provider.showMenu) {
                              position = -350;
                            } else {
                              position = -700;
                            }
                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              left: (menuCardProvider.showMenu) ? 0 : position,
                              bottom: 0,
                              child: SizedBox(
                                width: 700,
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      width: 350,
                                      height: height - 70,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: const Border(
                                              left: BorderSide(
                                                  color: DefaultTheme
                                                      .GREY_BUTTON))),
                                      padding: EdgeInsets.zero,
                                      child: menuCard,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          left: (provider.showMenu) ? 0 : -350,
                          bottom: 0,
                          child: BoxLayout(
                            width: 350,
                            height: height - 70,
                            borderRadius: 0,
                            padding: EdgeInsets.zero,
                            bgColor: Theme.of(context).cardColor,
                            child: menu,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Consumer<GuideProvider>(
                  builder: (context, provider, child) {
                    return (!provider.guideDisabled)
                        ? const SizedBox()
                        : Container(
                            width: width,
                            height: height,
                            color: DefaultTheme.BLACK.withOpacity(0.9),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
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
                                  width: 540,
                                ),
                                _buildCheckBoxUpdateGuide(provider),
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
                                              provider.updateGuideDisabled();
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
                                                provider.updateGuideDisabled();
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
          : const WebMobileBlankWidget(),
    );
  }

  Widget _buildCheckBoxUpdateGuide(GuideProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 540,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: DefaultTheme.WHITE, // color of tick Mark
              activeColor: DefaultTheme.GREY_LIGHT,
              value: provider.guideWeb,
              side: const BorderSide(color: DefaultTheme.GREY_LIGHT, width: 2),

              onChanged: (bool? value) {
                provider.changeGuideWeb(value!);
              },
            ),
            const Text(
              'Không hiển thị hướng dẫn cho lần đăng nhập tiếp theo',
              style: TextStyle(color: DefaultTheme.WHITE),
            ),
          ],
        ),
      ),
    );
  }
}
