import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double width;

  const DividerWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 0.25,
      color: DefaultTheme.GREY_TOP_TAB_BAR,
    );
  }
}
