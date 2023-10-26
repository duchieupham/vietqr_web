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
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    'Danh sách tài liệu VietQR VN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                color: AppColor.BLUE_TEXT.withOpacity(0.3),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 400,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.BLACK_BUTTON
                                                  .withOpacity(0.2))),
                                      child: const Text(
                                        'Tên tài liệu',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.BLACK_BUTTON
                                                  .withOpacity(0.2))),
                                      child: const Text(
                                        'Ngày cập nhật',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.BLACK_BUTTON
                                                  .withOpacity(0.2))),
                                      child: const Text(
                                        'Truy cập',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 400,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.BLACK_BUTTON
                                                .withOpacity(0.2))),
                                    child: InkWell(
                                      onTap: () {
                                        html.window.open(
                                            'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                                            'new tab');
                                      },
                                      child: const Text(
                                        'Tài liệu kết nối API VietQR VN - Nhận biến động số dư',
                                        style: TextStyle(
                                            color: AppColor.BLUE_TEXT,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.BLACK_BUTTON
                                                .withOpacity(0.2))),
                                    child: const Text(
                                      '24/10/2023',
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.BLACK_BUTTON
                                                .withOpacity(0.2))),
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
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const FooterWeb(
              showListBank: true,
            )
          ],
        ),
      ),
    );
  }
}
