import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:flutter/material.dart';

class CreateQRFrame extends StatelessWidget {
  final List<Widget> widget1;
  final List<Widget> widget2;
  final Widget widget3;

  const CreateQRFrame({
    super.key,
    required this.widget1,
    required this.widget2,
    required this.widget3,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: (PlatformUtils.instance.resizeWhen(width, 1000))
          ? Column(
              children: [
                const HeaderWidget(
                  isSubHeader: true,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 380,
                      height: height - 60,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        children: widget1,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: height - 60,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shrinkWrap: true,
                          children: widget2,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 450,
                      height: height - 60,
                      child: widget3,
                    ),
                  ],
                )
              ],
            )
          : (PlatformUtils.instance.resizeWhen(width, 700))
              ? const SizedBox()
              // Column(
              //     children: [
              //       const HeaderWidget(
              //         isSubHeader: true,
              //       ),
              //       SizedBox(
              //         width: width,
              //         height: height - 60,
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: ListView(
              //                 shrinkWrap: true,
              //                 children: [
              //                   Column(
              //                     children: widget1,
              //                   ),
              //                   const Padding(
              //                       padding: EdgeInsets.only(top: 30)),
              //                   Column(
              //                     children: widget2,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             SizedBox(
              //               width: 450,
              //               height: height - 60,
              //               child: widget3,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   )
              : const SizedBox(),
    );
  }
}
