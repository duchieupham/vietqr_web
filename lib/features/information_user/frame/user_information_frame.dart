import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:flutter/material.dart';

class UserInformationFrame extends StatelessWidget {
  final List<Widget> widget1;
  final List<Widget> widget2;

  const UserInformationFrame({
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
      child: (PlatformUtils.instance.resizeWhen(width, 1100))
          ? Column(
              children: [
                const HeaderWidget(
                  isSubHeader: true,
                ),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 380,
                      height: height - 60,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        children: widget1,
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      height: height - 60,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        children: widget2,
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                )
              ],
            )
          : const WebMobileBlankWidget(),
    );
  }
}
