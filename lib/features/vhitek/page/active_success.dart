import 'dart:js' as js;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActiveSuccess extends StatefulWidget {
  final Function(int) edit;

  const ActiveSuccess({super.key, required this.edit});

  @override
  State<ActiveSuccess> createState() => _ActiveSuccessState();
}

class _ActiveSuccessState extends State<ActiveSuccess> {
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
                        'Kích hoạt thành công',
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
            Column(
              children: [
                ButtonWidget(
                  text: 'Kích hoạt máy cho cửa hàng',
                  textColor: AppColor.WHITE,
                  borderRadius: 5,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () => widget.edit(4),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                ButtonWidget(
                  text: 'Hoàn tất',
                  textColor: AppColor.BLUE_TEXT,
                  borderRadius: 5,
                  bgColor: AppColor.BLUE_TEXT.withOpacity(0.25),
                  function: () {
                    js.context
                        .callMethod('sendDataToFlutter', ['CLOSE_WEB', '*']);
                    context.push('/home');
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
