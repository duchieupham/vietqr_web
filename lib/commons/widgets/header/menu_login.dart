import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuLogin extends StatelessWidget {
  const MenuLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuLoginProvider>(builder: (context, provider, child) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
            height: 32,
          ),
          const Expanded(child: SizedBox.shrink()),
          Expanded(
            flex: 4,
            child: LayoutBuilder(builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildItemMenu('Tạo mã QR',
                            isSelected: provider.page == 0, onTap: () {
                          context.go('/create-qr');
                        }),
                        _buildItemMenu('Tài liệu kết nối',
                            isSelected: provider.page == 1, onTap: () {
                          context.go('/service');
                        }),
                        _buildItemMenu('Tin tức',
                            isSelected: provider.page == 2, onTap: () {}),
                        _buildItemMenu('Giới thiệu',
                            isSelected: provider.page == 3, onTap: () {}),
                        _buildItemMenu('Liên hệ',
                            isSelected: provider.page == 4, onTap: () {}),
                        _buildItemMenu('Đăng nhập',
                            isSelected: provider.page == 5, onTap: () {
                          context.go('/login');
                        }),
                        _buildItemMenu('Đăng ký',
                            isSelected: provider.page == 6, onTap: () {
                          context.go('/register');
                        }),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
          const Expanded(child: SizedBox.shrink()),
        ],
      );
    });
  }

  Widget _buildItemMenu(String title,
      {bool isSelected = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color:
                        isSelected ? AppColor.BLUE_TEXT : AppColor.TRANSPARENT,
                    width: 2))),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: isSelected ? AppColor.BLUE_TEXT : AppColor.BLACK),
        ),
      ),
    );
  }
}
