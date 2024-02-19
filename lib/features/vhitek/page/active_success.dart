import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveSuccess extends StatelessWidget {
  const ActiveSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveVhitekProvider>(builder: (context, provider, child) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        children: [
          const SizedBox(
            height: 56,
          ),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.icSuccess),
            height: 220,
          ),
          const SizedBox(
            height: 8,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Kích hoạt thành công',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              provider.mid,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    });
  }
}
