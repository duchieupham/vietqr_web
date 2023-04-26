import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:flutter/widgets.dart';

class AddBankFrame extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;

  const AddBankFrame({
    super.key,
    required this.widget1,
    required this.widget2,
  });

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
                const HeaderWidget(
                  isSubHeader: true,
                ),
                SizedBox(
                  width: 700,
                  height: height - 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        height: height - 60,
                        child: widget1,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      Expanded(child: widget2),
                    ],
                  ),
                )
              ],
            )
          : const SizedBox(),
    );
  }
}
