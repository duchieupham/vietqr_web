import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
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

  final Widget _iframWidget = HtmlElementView(
    key: UniqueKey(),
    viewType: 'iframeElement2',
  );
  @override
  Widget build(BuildContext context) {
    double sizeText = 14;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        color: AppColor.WHITE,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
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
              if (constraints.maxWidth < 750)
                const FooterWeb(
                  showListBank: false,
                  bgColor: AppColor.WHITE,
                )
              else
                const FooterWeb(
                  showListBank: true,
                )
            ],
          );
        }),
      ),
    );
  }
}
