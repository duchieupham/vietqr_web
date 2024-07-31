import 'dart:html' as html;

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
    return Consumer<MenuLoginProvider>(
      builder: (context, provider, child) {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 750) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Expanded(
                    child: _buildItemMenuMobile('Tạo mã QR',
                        isSelected: provider.page == 0, onTap: () {
                      provider.changePage(0);
                      context.go('/create-qr');
                    }),
                  ),
                  Expanded(
                    child: _buildItemMenuMobile('Tài liệu kết nối',
                        isSelected: provider.page == 1, onTap: () {
                      provider.changePage(1);
                      context.go('/service');
                    }),
                  ),
                  Expanded(
                    child: _buildItemMenuMobile('Tin tức',
                        isSelected: provider.page == 2, onTap: () {
                      provider.changePage(2);
                      context.go('/tin-tuc');
                    }),
                  ),
                  Expanded(
                    child: _buildItemMenuMobile('Giới thiệu',
                        isSelected: provider.page == 3, onTap: () {
                      provider.changePage(3);
                      context.go('/gioi-thieu');
                    }),
                  ),
                  Expanded(
                    child: _buildItemMenuMobile('Liên hệ',
                        isSelected: provider.page == 4, onTap: () {
                      provider.changePage(4);
                      context.go('/lien-he');
                    }),
                  ),
                  Expanded(
                    child: _buildItemMenuMobile('Đăng nhập',
                        isSelected: provider.page == 5, onTap: () {
                      provider.changePage(5);
                      context.go('/login');
                    }),
                  ),
                  Expanded(
                    child: _buildItemMenuMobile(
                      'Đăng ký',
                      isSelected: provider.page == 6,
                      onTap: () {
                        provider.changePage(6);
                        context.go('/register');
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(width: 16),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
                height: 32,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            _buildItemMenu('Tạo mã QR',
                                isSelected: provider.page == 0, onTap: () {
                              provider.changePage(0);
                              context.go('/create-qr');
                            }),
                            _buildItemMenu('Tài liệu API',
                                isSelected: provider.page == 0, onTap: () {
                              html.window
                                  .open('https://api.vietqr.vn/', 'new tab');
                            }),
                            _buildItemMenu('Tài liệu VietQR',
                                isSelected: provider.page == 0, onTap: () {
                              html.window
                                  .open('https://doc.vietqr.vn', 'new tab');
                            }),
                            _buildItemMenu('Tài liệu kết nối',
                                isSelected: provider.page == 1, onTap: () {
                              provider.changePage(1);
                              context.go('/service');
                            }),
                            _buildItemMenu('Tin tức',
                                isSelected: provider.page == 2, onTap: () {
                              provider.changePage(2);
                              context.go('/tin-tuc');
                            }),
                            _buildItemMenu('Giới thiệu',
                                isSelected: provider.page == 3, onTap: () {
                              provider.changePage(3);
                              context.go('/gioi-thieu');
                            }),
                            _buildItemMenu('Liên hệ',
                                isSelected: provider.page == 4, onTap: () {
                              provider.changePage(4);
                              context.go('/lien-he');
                            }),
                            _buildItemMenu('Đăng nhập',
                                isSelected: provider.page == 5, onTap: () {
                              provider.changePage(5);
                              context.go('/login');
                            }),
                            _buildItemMenu(
                              'Đăng ký',
                              isSelected: provider.page == 6,
                              onTap: () {
                                provider.changePage(6);
                                context.go('/register');
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildInfoTelegram(),
              const SizedBox(
                width: 12,
              )
            ],
          );
        });
      },
    );
  }

  Widget _buildInfoTelegram() {
    return InkWell(
      onTap: () {
        html.window.open('https://t.me/vietqrdev', 'new tab');
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE.withOpacity(0.5)),
        child: Row(
          children: [
            const Text(
              'My VietQR',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColor.BLACK,
                  fontSize: 12),
            ),
            const SizedBox(
              width: 8,
            ),
            Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.logoTelegram),
              width: 16,
            ),
          ],
        ),
      ),
    );
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

  Widget _buildItemMenuMobile(String title,
      {bool isSelected = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color:
                        isSelected ? AppColor.BLUE_TEXT : AppColor.TRANSPARENT,
                    width: 2))),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColor.BLUE_TEXT : AppColor.BLACK),
        ),
      ),
    );
  }
}
