import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/footer_web_mobile.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateQRMobileFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget1;
  final Widget widget2;
  final Widget menuTop;
  final Widget bottom;
  final ScrollController controller;

  const CreateQRMobileFrame({
    super.key,
    required this.width,
    required this.height,
    required this.widget1,
    required this.widget2,
    required this.menuTop,
    required this.bottom,
    required this.controller,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        backgroundColor: AppColor.TRANSPARENT,
        appBar: AppBar(
          backgroundColor: AppColor.TRANSPARENT,
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Consumer<MenuLoginProvider>(
                builder: (context, provider, child) {
              return Text(
                getTitle(provider.page),
                style: const TextStyle(color: AppColor.BLACK),
              );
            }),
          ),
          leading: Builder(builder: (context) {
            return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                    margin: const EdgeInsets.only(top: 16, left: 16),
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
        drawer: menuTop,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView(
                  controller: controller,
                  children: [
                    widget1,
                    const SizedBox(
                      height: 40,
                    ),
                    widget2,
                    const SizedBox(
                      height: 40,
                    ),
                    const FooterMobileWeb()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
