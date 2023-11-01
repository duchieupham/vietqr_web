import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double width;
  final Color? color;
  const DividerWidget({super.key, required this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1,
      color: color ?? AppColor.BLACK_BUTTON.withOpacity(0.2),
    );
  }
}
