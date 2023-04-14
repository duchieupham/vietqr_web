import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:flutter/material.dart';

class CreateQRFrame extends StatelessWidget {
  const CreateQRFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: (PlatformUtils.instance.resizeWhen(width, 700))
          ? Column(
              children: [
                HeaderWidget(
                  isSubHeader: true,
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
