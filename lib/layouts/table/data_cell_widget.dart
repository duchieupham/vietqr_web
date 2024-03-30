import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class DataCellWidget extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final GestureTapCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? width;
  final double height;

  const DataCellWidget(
      {super.key,
      this.title,
      this.textColor,
      this.onTap,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.width = 100,
      this.height = 50});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.GREY_DADADA, width: 0.25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title ?? '-',
                maxLines: 2,
                textAlign: textAlign,
                style: TextStyle(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                  fontSize: fontSize ?? 11,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
