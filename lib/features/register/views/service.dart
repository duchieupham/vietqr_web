import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeText = 14;
    context.read<MenuLoginProvider>().changePage(1);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
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
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: constraints.maxWidth >= 700 ? 80 : 40,
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
                    if (constraints.maxWidth < 750)
                      Expanded(
                          child: _buildFormForMobile(
                              constraints.maxWidth < 750 ? 12 : 14))
                    else
                      Align(
                          alignment: Alignment.center,
                          child: _buildFormForWeb(
                              constraints.maxWidth < 750 ? 12 : 14))
                  ],
                ),
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
                    child: Text(
                      'Tài liệu kết nối API VietQR VN - Nhận biến động số dư',
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
                Container(
                  width: 460,
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
                    child: Text(
                      'Tài liệu refund cho đối tác',
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
