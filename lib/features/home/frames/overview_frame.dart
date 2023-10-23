import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/guide_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverViewFrame extends StatelessWidget {
  final Widget page;
  final Widget menu;
  final Widget menuCard;
  const OverViewFrame(
      {Key? key,
      required this.page,
      required this.menu,
      required this.menuCard})
      : super(key: key);

  void _initialService(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<GuideProvider>(context, listen: false).updateIndex(0);
    });
  }

  List<String> get guideAssets => [
        'assets/images/ic-guide1.png',
        'assets/images/ic-guide2.png',
        'assets/images/ic-guide3.png',
        'assets/images/ic-guide4.png',
        'assets/images/ic-guide5.png',
      ];
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    _initialService(context);
    return Container(
      width: width,
      height: height,
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
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                const HeaderWidget(),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: page,
                    ),
                    Consumer<MenuProvider>(
                      builder: (context, provider, child) {
                        return Consumer<MenuCardProvider>(
                          builder: (context, menuCardProvider, child) {
                            double width = 0;
                            if (provider.showMenu) {
                              if (menuCardProvider.showMenu) {
                                width = 500;
                              } else {
                                width = 220;
                              }
                            } else {
                              width = 60;
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              width: width,
                              child: SizedBox(
                                height: height - 60,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    BoxLayout(
                                      width: 220,
                                      height: height - 60,
                                      borderRadius: 0,
                                      padding: !provider.showMenu
                                          ? const EdgeInsets.only(left: 10)
                                          : EdgeInsets.zero,
                                      alignment: Alignment.centerLeft,
                                      bgColor: !provider.showMenu
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.3)
                                          : Theme.of(context).cardColor,
                                      child: menu,
                                    ),
                                    Container(
                                      width: 280,
                                      height: height - 60,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: const Border(
                                              left: BorderSide(
                                                  color:
                                                      AppColor.GREY_BUTTON))),
                                      padding: EdgeInsets.zero,
                                      child: menuCard,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Consumer<GuideProvider>(
            builder: (context, provider, child) {
              return (!provider.guideDisabled)
                  ? const SizedBox()
                  : Container(
                      width: width,
                      height: height,
                      color: AppColor.BLACK.withOpacity(0.9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                      textColor: AppColor.WHITE,
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
                                          provider
                                              .updateIndex(provider.index + 1);
                                        }
                                      },
                                      bgColor: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(0.3),
                                      textColor: AppColor.WHITE,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
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
              checkColor: AppColor.WHITE, // color of tick Mark
              activeColor: AppColor.GREY_LIGHT,
              value: provider.guideWeb,
              side: const BorderSide(color: AppColor.GREY_LIGHT, width: 2),

              onChanged: (bool? value) {
                provider.changeGuideWeb(value!);
              },
            ),
            const Text(
              'Không hiển thị hướng dẫn cho lần đăng nhập tiếp theo',
              style: TextStyle(color: AppColor.WHITE),
            ),
          ],
        ),
      ),
    );
  }
}
