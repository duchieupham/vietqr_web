import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:flutter/material.dart';

class WalletFrame extends StatefulWidget {
  final Widget widget1;
  final Widget widget2;
  final Widget menu;

  const WalletFrame({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.menu,
  });

  @override
  State<WalletFrame> createState() => _WalletFrameState();
}

class _WalletFrameState extends State<WalletFrame> {
  final PageController pageController = PageController();
  int currentPage = 0;

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
        child: (PlatformUtils.instance.resizeWhen(width, 550))
            ? SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    const HeaderWidget(),
                    widget.menu,
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            'Ví QR',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(flex: 3, child: widget.widget1),
                            const SizedBox(width: 30),
                            LayoutBuilder(builder: (context, constraints) {
                              return widget.widget2;
                            }),
                            const SizedBox(width: 30),
                          ],
                        )),
                        const FooterWeb(),
                      ],
                    )),
                    const FooterWeb(),
                  ],
                ),
              )
            : _forMobile(),
      ),
    );
  }

  Widget _forMobile() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: ['Giao dịch', 'Mã QR'].map((e) {
              int index = ['Giao dịch', 'Mã QR'].indexOf(e);
              return GestureDetector(
                onTap: () {
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                  setState(() {
                    currentPage = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.only(bottom: 4, top: 12),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: index == currentPage
                                  ? AppColor.BLUE_TEXT
                                  : Colors.transparent))),
                  child: Text(
                    e,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            children: [widget.widget1, widget.widget2],
          ),
        )
      ],
    );
  }
}
