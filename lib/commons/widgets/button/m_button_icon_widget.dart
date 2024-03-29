import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class MButtonIconWidget extends StatelessWidget {
  final double width, height;
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final Color? bgColor, textColor, iconColor;
  final double? textSize, iconSize;
  final double borderRadius;
  final EdgeInsets padding;
  final BoxBorder? border;

  const MButtonIconWidget({
    super.key,
    this.width = 80,
    this.height = 30,
    this.icon,
    required this.title,
    required this.onTap,
    this.bgColor,
    this.textColor = AppColor.BLACK,
    this.iconColor,
    this.textSize = 11,
    this.borderRadius = 5,
    this.iconSize = 12,
    this.border,
    this.padding = const EdgeInsets.fromLTRB(5, 5, 8, 5),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: textSize,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
