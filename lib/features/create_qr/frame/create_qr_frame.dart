import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_dropdown.dart';
import 'package:flutter/material.dart';

import 'dart:html' as html;

import '../../wallet/wallet_screen.dart';

class CreateQRFrame extends StatefulWidget {
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;

  const CreateQRFrame({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.widget3,
  });

  @override
  State<CreateQRFrame> createState() => _HomeFrameState();
}

class _HomeFrameState extends State<CreateQRFrame> {
  String type = '0';
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
                    Expanded(
                      child: Row(
                        children: [
                          MenuLeft(
                            currentType: MenuHomeType.CREATE_QR,
                            subMenuQr: [
                              ItemDropDownMenu(
                                title: 'Tạo mã VietQR',
                                isSelect: type == "0" ? true : false,
                                onTap: () => onTapMenu('0'),
                              ),
                              ItemDropDownMenu(
                                title: 'Ví QR',
                                isSelect: type == "1" ? true : false,
                                onTap: () => onTapMenu('1'),
                              ),
                            ],
                          ),
                          _buildBody(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : _forMobile(),
      ),
    );
  }

  Widget createQrSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Tạo mã VietQR',
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
              Expanded(child: widget.widget1),
              const SizedBox(width: 30),
              Expanded(child: widget.widget2),
              const SizedBox(width: 30),
              Expanded(child: widget.widget3),
              const SizedBox(width: 16),
              // Expanded(flex: 2, child: widget.widget3),
              // const SizedBox(width: 16),
            ],
          )),
          const FooterWeb(),
        ],
      ),
    );
  }

  void onTapMenu(String value) {
    if (value == '0') {
      html.window.history.pushState(value, '/qr', '/create-qr');
      type = value;
    } else {
      html.window.history.pushState(value, '/qr', '/qr-wallet');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == '0') {
      return createQrSection();
    }
    return const WalletScreen();
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
