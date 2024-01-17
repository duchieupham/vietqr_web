import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/menu_drawer.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final html.IFrameElement _iFrameElement = html.IFrameElement();
  bool openMenuDrawer = false;
  @override
  void initState() {
    context.read<MenuLoginProvider>().changePage(2);
    _iFrameElement.src = 'https://vietqr.com/tin-tuc-vietqr.html';

    _iFrameElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );
    super.initState();
  }

  getTitle(int index) {
    switch (index) {
      case 0:
        return 'Tạo mã QR';
      case 1:
        return 'Tài liệu kết nối';
      case 2:
        return 'Tin tức';
      case 3:
        return 'Giới thiệu';
      case 4:
        return 'Liên hệ';
      case 5:
        return 'Đăng nhập';
      case 6:
        return 'Đăng ký';
      default:
        return 'VietQR';
    }
  }

  final Widget _iframWidget = HtmlElementView(
    key: UniqueKey(),
    viewType: 'iframeElement',
  );
  @override
  Widget build(BuildContext context) {
    double sizeText = 14;
    final double width = MediaQuery.of(context).size.width;
    return (PlatformUtils.instance.resizeWhen(width, 750))
        ? Scaffold(
            appBar: AppBar(toolbarHeight: 0),
            body: Container(
              color: AppColor.WHITE,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    ),
                    child: const MenuLogin(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: _iframWidget,
                  ),
                  const FooterWeb(
                    showListBank: true,
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            drawerEnableOpenDragGesture: false,
            backgroundColor: AppColor.TRANSPARENT,
            appBar: AppBar(
              backgroundColor: AppColor.BLUE_TEXT.withOpacity(0.2),
              title: Consumer<MenuLoginProvider>(
                  builder: (context, provider, child) {
                return Text(
                  getTitle(provider.page),
                  style: const TextStyle(color: AppColor.BLACK),
                );
              }),
              leading: Builder(builder: (context) {
                return InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                      setState(() {
                        openMenuDrawer = true;
                      });
                    },
                    child: Container(
                        margin:
                            const EdgeInsets.only(top: 8, left: 16, bottom: 8),
                        decoration: BoxDecoration(
                            color: AppColor.WHITE.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Icon(
                          Icons.menu,
                          size: 20,
                          color: AppColor.BLACK,
                        )));
              }),
            ),
            drawer: const MenuDrawer(),
            body: Container(
              color: AppColor.WHITE,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        if (openMenuDrawer)
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: AppColor.BLACK.withOpacity(0.1),
                          ),
                        _iframWidget,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
