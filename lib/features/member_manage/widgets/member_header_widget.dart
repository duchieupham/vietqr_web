import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/layouts/horizontal_dashedline_painter.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:flutter/material.dart';

class MemberHeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final MerchantDTO? dto;
  final GestureTapCallback? onTap;

  const MemberHeaderWidget(
      {super.key,
      required this.title,
      required this.child,
      required this.dto,
      this.onTap});

  TextStyle get styles =>
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Text('Quản lý nhân viên', style: styles),
                  const SizedBox(width: 8),
                  Text('/', style: styles),
                  const SizedBox(width: 8),
                  Text(title, style: styles),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTap,
                    child: Row(
                      children: [
                        Text(dto?.name ?? '',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        Image(
                          image: ImageUtils.instance
                              .getImageNetWork(AppImages.icChooseBank),
                          width: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColor.GREY_DADADA),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
