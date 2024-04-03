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

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _NewsViewState();
}

class _NewsViewState extends State<ContactView> {
  final html.IFrameElement _iFrameElement1 = html.IFrameElement();

  @override
  void initState() {
    context.read<MenuLoginProvider>().changePage(4);
    _iFrameElement1.src = 'https://vietqr.com/lien-he-vietqr.html';

    _iFrameElement1.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement2',
      (int viewId) => _iFrameElement1,
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
    viewType: 'iframeElement2',
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
                    child: _iframWidget,
                  ),
                ],
              ),
            ),
          );
  }
}
