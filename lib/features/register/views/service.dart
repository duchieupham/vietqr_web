import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/footer_web_mobile.dart';
import 'package:VietQR/commons/widgets/header/menu_drawer.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

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
    context.read<MenuLoginProvider>().changePage(1);

    return Container(
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
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 750) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  ),
                  child: const MenuLogin(),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tài liệu kỹ thuật',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: _buildFormForWeb(14))
                    ],
                  ),
                ),
                const FooterWeb(
                  showListBank: true,
                )
              ],
            ),
          );
        } else {
          return Scaffold(
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
            drawer: const MenuDrawer(),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tài liệu kỹ thuật',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: _buildFormForMobile(
                              constraints.maxWidth < 750 ? 12 : 14)),
                      const SizedBox(
                        height: 40,
                      ),
                      const FooterMobileWeb(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildFormForWeb(double sizeText) {
    return SizedBox(
      width: 760,
      child: Column(
        children: [
          Container(
            height: 58,
            color: AppColor.BLUE_TEXT.withOpacity(0.3),
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Tên tài liệu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Ngày cập nhật',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Truy cập',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/101uFYsCsDDjSL54jPAGAJx6X56_OQT_JbVh5mflbPjk/edit',
                          'new tab');
                    },
                    child: Text(
                      'Tài liệu kết nối API VietQR VN - Nhận biến động số dư (Host to Host)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '28/06/2024',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/101uFYsCsDDjSL54jPAGAJx6X56_OQT_JbVh5mflbPjk/edit',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/101uFYsCsDDjSL54jPAGAJx6X56_OQT_JbVh5mflbPjk/edit',
                          'new tab');
                    },
                    child: Text(
                      'Tài liệu kết nối API VietQR VN - Nhận biến động số dư (Host to Client & Cloud Platform)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '28/06/2024',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/101uFYsCsDDjSL54jPAGAJx6X56_OQT_JbVh5mflbPjk/edit',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1FEwXIRAAG3nLlGc3a0vsCoDuY4wqdHb7aofD9X19WVI/edit',
                          'new tab');
                    },
                    child: Text(
                      'Tài liệu API Refund Transaction',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '28/06/2024',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1FEwXIRAAG3nLlGc3a0vsCoDuY4wqdHb7aofD9X19WVI/edit',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/11E367PsXykff37P6c4_-uP3JkvZ8l3zOnOdVNx-NXd0/edit',
                          'new tab');
                    },
                    child: Text(
                      'Tài liệu Tạo Static QR Code: Mã QR tĩnh  - Dynamic QR Code: Mã QR động',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '28/06/2024',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/11E367PsXykff37P6c4_-uP3JkvZ8l3zOnOdVNx-NXd0/edit',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1ktLPG9JGNraKf4t303pLsEdieVj8exVNgql2fl8XFBg/edit?usp=sharing',
                          'new tab');
                    },
                    child: Text(
                      'API kết nối Ative tài Khoản Nhận BDSD 2 chiều app VietQR và Đối tác',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '28/06/2024',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1ktLPG9JGNraKf4t303pLsEdieVj8exVNgql2fl8XFBg/edit?usp=sharing',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/16daInn54JPFrA7LoYjullx37NBar1A9kOzQxHPMHsA0/edit?usp=sharing',
                          'new tab');
                    },
                    child: Text(
                      'API đồng bộ TERMINAL',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '28/06/2024',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/16daInn54JPFrA7LoYjullx37NBar1A9kOzQxHPMHsA0/edit?usp=sharing',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Text(
            'Tài liệu hướng dẫn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  height: 50,
                  color: AppColor.BLUE_TEXT.withOpacity(0.3),
                  child: Row(
                    children: [
                      Container(
                        width: 460,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                        child: const Text(
                          'Tên tài liệu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                        child: const Text(
                          'Ngày cập nhật',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                        child: const Text(
                          'Truy cập',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1nAmD28jgirsvknc6zxYSmhb9p9wdB826roIC2whGmN8/edit#heading=h.ym8d2gpm2ljl',
                          'new tab');
                    },
                    child: Text(
                      'Tài liệu Kết nối máy bán hàng các loại với Tài khoản thanh toán',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '24/10/2023',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1nAmD28jgirsvknc6zxYSmhb9p9wdB826roIC2whGmN8/edit#heading=h.ym8d2gpm2ljl',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Container(
                  width: 460,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1XE5603uLtPh8GXt1AXEXotE2Wnfmv9Z3y8NTb1_D29Y/edit',
                          'new tab');
                    },
                    child: Text(
                      'Tài liệu kết nối Voice box, bảng thông báo thanh toán và công tắc',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: sizeText,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '24/10/2023',
                  ),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1XE5603uLtPh8GXt1AXEXotE2Wnfmv9Z3y8NTb1_D29Y/edit',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormForMobile(double sizeText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 58,
            color: AppColor.BLUE_TEXT.withOpacity(0.3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                    child: const Text(
                      'Tên tài liệu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Ngày cập nhật',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Truy cập',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                    child: InkWell(
                      onTap: () {
                        html.window.open(
                            'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                            'new tab');
                      },
                      child: Text(
                        'Tài liệu kết nối API VietQR VN - Nhận biến động số dư',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: sizeText,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '24/10/2023',
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                    child: InkWell(
                      onTap: () {
                        html.window.open(
                            'https://docs.google.com/document/d/1FEwXIRAAG3nLlGc3a0vsCoDuY4wqdHb7aofD9X19WVI/edit?usp=sharing',
                            'new tab');
                      },
                      child: Text(
                        'Tài liệu refund cho đối tác',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: sizeText,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '24/10/2023',
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1FEwXIRAAG3nLlGc3a0vsCoDuY4wqdHb7aofD9X19WVI/edit?usp=sharing',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Text(
            'Tài liệu hướng dẫn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 58,
            color: AppColor.BLUE_TEXT.withOpacity(0.3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                    child: const Text(
                      'Tên tài liệu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Ngày cập nhật',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Truy cập',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                    child: InkWell(
                      onTap: () {
                        html.window.open(
                            'https://docs.google.com/document/d/1nAmD28jgirsvknc6zxYSmhb9p9wdB826roIC2whGmN8/edit#heading=h.ym8d2gpm2ljl',
                            'new tab');
                      },
                      child: Text(
                        'Tài liệu Kết nối máy bán hàng các loại với Tài khoản thanh toán',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: sizeText,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '24/10/2023',
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1nAmD28jgirsvknc6zxYSmhb9p9wdB826roIC2whGmN8/edit#heading=h.ym8d2gpm2ljl',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 58,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                    child: InkWell(
                      onTap: () {
                        html.window.open(
                            'https://docs.google.com/document/d/1XE5603uLtPh8GXt1AXEXotE2Wnfmv9Z3y8NTb1_D29Y/edit',
                            'new tab');
                      },
                      child: Text(
                        'Tài liệu kết nối Voice box, bảng thông báo thanh toán và công tắc',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            fontSize: sizeText,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    '24/10/2023',
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/1XE5603uLtPh8GXt1AXEXotE2Wnfmv9Z3y8NTb1_D29Y/edit',
                          'new tab');
                    },
                    child: const Text(
                      'Truy cập',
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
