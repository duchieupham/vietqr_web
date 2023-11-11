import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;
  //height default 50
  final String text;
  final Color textColor;
  final Color bgColor;
  final VoidCallback function;
  final double? height;
  final double textSize;
  final double? borderRadius;
  final EdgeInsets padding;
  final BorderRadius? bdRadius;

  const ButtonWidget(
      {Key? key,
      this.width,
      required this.text,
      required this.textColor,
      required this.bgColor,
      required this.function,
      this.height,
      this.textSize = 14,
      this.borderRadius,
      this.bdRadius,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: width,
        padding: padding,
        height: (height != null) ? height : 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: bdRadius ??
              BorderRadius.circular(
                  (borderRadius != null) ? borderRadius! : 15),
          color: bgColor,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ),
    );
  }
}
