import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:flutter/material.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool check;
  final double size;
  final VoidCallback function;

  const CheckBoxWidget({
    Key? key,
    required this.check,
    required this.size,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: function,
        child: Image(
          image: ImageUtils.instance.getImageNetWork(
              (check) ? AppImages.icChecked : AppImages.icUncheck),
          color: AppColor.BLUE_TEXT,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ));
  }
}
