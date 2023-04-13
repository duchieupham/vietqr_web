import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFrame extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  final Widget menu;

  const HomeFrame({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
              ],
            )
          : const SizedBox(),
    );
  }
}
