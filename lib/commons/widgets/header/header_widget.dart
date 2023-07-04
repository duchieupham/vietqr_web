import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_full_widget.dart';
import 'package:VietQR/commons/widgets/header/header_guest.dart';
import 'package:VietQR/commons/widgets/header/header_half_widget.dart';
import 'package:flutter/widgets.dart';

class HeaderWidget extends StatelessWidget {
  final bool? isSubHeader;
  final bool isHeaderGuest;

  const HeaderWidget({
    super.key,
    this.isSubHeader,
    this.isHeaderGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (isHeaderGuest) {
      return SizedBox(width: width, height: 60, child: const HeaderGuest());
    }
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
