import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_full_widget.dart';
import 'package:VietQR/commons/widgets/header/header_half_widget.dart';
import 'package:flutter/widgets.dart';

class HeaderWidget extends StatelessWidget {
  final bool? isSubHeader;

  const HeaderWidget({
    super.key,
    this.isSubHeader,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 60,
      child: (PlatformUtils.instance.resizeWhen(width, 600))
          ? HeaderFullWidget(
              isSubHeader: isSubHeader,
            )
          : HeaderHalfWidget(isSubHeader: isSubHeader),
    );
  }
}
