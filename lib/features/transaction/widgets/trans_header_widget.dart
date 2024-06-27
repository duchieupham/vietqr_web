import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';

class TransHeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final BankAccountDTO? dto;
  final GestureTapCallback? onTap;

  const TransHeaderWidget(
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Text('Giao dịch', style: styles),
                const SizedBox(width: 8),
                Text('/', style: styles),
                const SizedBox(width: 8),
                Text(title, style: styles),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      if (dto?.imgId != null) ...[
                        Image(
                            image: ImageUtils.instance
                                .getImageNetWork(dto?.imgId ?? ''),
                            width: 36),
                        Text(
                          dto?.bankAccount ?? '',
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
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
          Expanded(child: child),
        ],
      ),
    );
  }
}
