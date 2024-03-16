import 'dart:js' as js;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActiveStoreSuccess extends StatefulWidget {
  const ActiveStoreSuccess({super.key});

  @override
  State<ActiveStoreSuccess> createState() => _ActiveSuccessState();
}

class _ActiveSuccessState extends State<ActiveStoreSuccess> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveVhitekProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 56,
                    ),
                    Image(
                      image: ImageUtils.instance
                          .getImageNetWork(AppImages.icSuccess),
                      height: 220,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Kích hoạt máy cho\ncửa  / điểm bán thành công',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        provider.mid,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ButtonWidget(
              text: 'Hoàn tất',
              textColor: AppColor.BLUE_TEXT,
              borderRadius: 5,
              bgColor: AppColor.BLUE_TEXT,
              function: () {
                js.context.callMethod('sendDataToFlutter', ['CLOSE_WEB', '*']);
                context.push('/home');
              },
            ),
          ],
        );
      },
    );
  }
}
