import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class BorderLayout extends StatelessWidget {
  final double? width;
  final bool isError;
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double borderWidth;
  final Color? bgColor;

  const BorderLayout(
      {super.key,
      this.width,
      required this.isError,
      required this.child,
      this.padding,
      this.height,
      this.borderWidth = 0.5,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: (padding != null) ? padding : null,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
            color: (isError) ? AppColor.RED_TEXT : AppColor.GREY_TOP_TAB_BAR,
            width: borderWidth),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
