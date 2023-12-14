import 'dart:async';
import 'dart:ui';

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/numeral.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/pin_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogWidget {
  //
  const DialogWidget._privateConstructor();
  static const DialogWidget _instance = DialogWidget._privateConstructor();
  static DialogWidget get instance => _instance;

  static bool isPopLoading = false;

  openPINDialog({required String title, required Function(String) onDone}) {
    final FocusNode focusNode = FocusNode();
    focusNode.requestFocus();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: (PlatformUtils.instance.isWeb())
                ? Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const Text(
                          'Mật khẩu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const SizedBox(
                          width: 250,
                          height: 60,
                          child: Text(
                            'Mật khẩu bao gồm 6 số.',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 80,
                          alignment: Alignment.center,
                          child: PinWidget(
                            width: 300,
                            pinSize: 15,
                            pinLength: Numeral.DEFAULT_PIN_LENGTH,
                            focusNode: focusNode,
                            onDone: onDone,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        ButtonWidget(
                          width: 250,
                          height: 30,
                          text: 'Đóng',
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
                          borderRadius: 5,
                          function: () {
                            focusNode.dispose();
                            Provider.of<PinProvider>(context, listen: false)
                                .reset();
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                  )
                : Container(
                    width: 350,
                    height: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              focusNode.dispose();
                              Provider.of<PinProvider>(context, listen: false)
                                  .reset();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColor.RED_TEXT,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 50)),
                        PinWidget(
                          width: 350,
                          pinSize: 15,
                          pinLength: Numeral.DEFAULT_PIN_LENGTH,
                          focusNode: focusNode,
                          onDone: onDone,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  // openOTPDialog({required Function onDone, required Function reSendOtp}) {
  //   // final FocusNode focusNode = FocusNode();
  //   // focusNode.requestFocus();
  //   return showDialog(
  //     barrierDismissible: false,
  //     context: NavigationService.navigatorKey.currentContext!,
  //     builder: (BuildContext context) {
  //       return Material(
  //         color: DefaultTheme.TRANSPARENT,
  //         child: Center(
  //             child: DialogInputOTP(
  //           onDone: onDone,
  //           reSendOtp: reSendOtp,
  //         )),
  //       );
  //     },
  //   );
  // }

  openNotificationDialog({
    required Widget child,
    required double height,
    required Function onTapBarrier,
    double? marginRight,
  }) {
    return showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        barrierColor: AppColor.TRANSPARENT,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onTapBarrier();
            },
            child: Material(
              color: AppColor.TRANSPARENT,
              child: Align(
                alignment: Alignment.topRight,
                child: BoxLayout(
                  width: 400,
                  height: height * 0.7,
                  borderRadius: 5,
                  enableShadow: true,
                  margin: EdgeInsets.only(
                    right: (marginRight != null) ? marginRight : 80,
                    top: 60,
                  ),
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                        child: Text(
                          'Thông báo',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  openBoxWebConfirm({
    required String title,
    required String confirmText,
    required String urlIcon,
    required String description,
    required VoidCallback confirmFunction,
    VoidCallback? cancelFunction,
    Color? confirmColor,
  }) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: 300,
                height: 350,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: ImageUtils.instance.getImageNetWork(urlIcon),
                      width: 80,
                      height: 80,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: 250,
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    ButtonWidget(
                      width: 250,
                      height: 30,
                      text: confirmText,
                      textColor: AppColor.WHITE,
                      bgColor: (confirmColor != null)
                          ? confirmColor
                          : AppColor.BLUE_TEXT,
                      borderRadius: 5,
                      function: confirmFunction,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    ButtonWidget(
                      width: 250,
                      height: 30,
                      text: 'Đóng',
                      textColor: Theme.of(context).hintColor,
                      bgColor: Theme.of(context).canvasColor,
                      borderRadius: 5,
                      function: (cancelFunction != null)
                          ? cancelFunction
                          : () {
                              Navigator.pop(context);
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  openContentDialog(
    VoidCallback? onClose,
    Widget child,
  ) {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: 400,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: child,
              ),
            ),
          );
        });
  }

  Future showFullModalBottomContent({
    BuildContext? context,
    required Widget widget,
  }) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false, // Ngăn người dùng kéo ModalBottomSheet
        context: context,
        backgroundColor: AppColor.TRANSPARENT,
        builder: (context) {
          return Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: widget,
          );
        });
  }

  Future showModalBottomContent(
      {BuildContext? context,
      required Widget widget,
      required double height}) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    return await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false, // Ngăn người dùng kéo ModalBottomSheet
        context: context,
        backgroundColor: AppColor.TRANSPARENT,
        builder: (context) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: keyboardHeight,
                  ),
                  width: MediaQuery.of(context).size.width - 10,
                  height: height + keyboardHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: widget,
                ),
              ),
            ),
          );
        });
  }

  Future openDateTimePickerDialog(BuildContext context,
      Function(DateTime) onChanged, DateTime initDate) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: 400,
                height: 450,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    SfDateRangePicker(
                      maxDate: DateTime.now(),
                      minDate: DateTime(1900),
                      initialDisplayDate: initDate,
                      onSelectionChanged: (date) {
                        Navigator.pop(context);
                        onChanged(date.value);
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openLoadingDialog({String msg = ''}) async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: NavigationService.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: AppColor.TRANSPARENT,
              child: Center(
                child: (PlatformUtils.instance.isWeb())
                    ? Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: AppColor.BLUE_TEXT,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            if (msg.isNotEmpty) ...[
                              const Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                msg,
                                textAlign: TextAlign.center,
                              ),
                            ] else
                              const Text(
                                'Đang tải',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      )
                    : Container(
                        width: 250,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CircularProgressIndicator(
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
              ),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  openMsgDialog(
      {required String title,
      required String msg,
      VoidCallback? function,
      BuildContext? context,
      Color? titleColor,
      Color? msgColor}) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
                child:
                    // (PlatformUtils.instance.isWeb())
                    //     ?
                    Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: ImageUtils.instance
                        .getImageNetWork(AppImages.icWarning),
                    width: 80,
                    height: 80,
                  ),

                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: msgColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  ButtonWidget(
                    width: 250,
                    height: 40,
                    text: 'Đóng',
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    borderRadius: 5,
                    function: (function != null)
                        ? function
                        : () {
                            Navigator.pop(context);
                          },
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            )
                // : Container(
                //     width: 300,
                //     height: 250,
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.symmetric(horizontal: 40),
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).cardColor,
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         const Spacer(),
                //         Text(
                //           msg,
                //           textAlign: TextAlign.center,
                //           style: const TextStyle(
                //             fontSize: 16,
                //           ),
                //         ),
                //         const Spacer(),
                //         ButtonWidget(
                //           width: 230,
                //           text: 'OK',
                //           textColor: DefaultTheme.WHITE,
                //           bgColor: DefaultTheme.GREEN,
                //           function: (function != null)
                //               ? function
                //               : () {
                //                   Navigator.pop(context);
                //                 },
                //         ),
                //         const Padding(padding: EdgeInsets.only(bottom: 20)),
                //       ],
                //     ),
                //   ),
                ),
          );
        });
  }

  openMsgQRInstallApp({VoidCallback? function, BuildContext? context}) {
    Widget _buildButton({
      required double width,
      required String text,
      required String assetImage,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: BoxLayout(
          width: width * 0.4,
          height: 28,
          padding: const EdgeInsets.all(0),
          bgColor: AppColor.BLACK,
          borderRadius: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: ImageUtils.instance.getImageNetWork(assetImage),
                width: 18,
                height: 18,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tải ứng dụng trên',
                    style: TextStyle(color: AppColor.WHITE, fontSize: 6),
                  ),
                  Text(
                    text,
                    style: const TextStyle(color: AppColor.WHITE, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
                child:
                    // (PlatformUtils.instance.isWeb())
                    //     ?
                    Container(
              width: 400,
              height: 460,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppColor.BLACK_BUTTON,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  QrImage(
                    data: 'https://onelink.to/q7zwpe',
                    size: 260,
                    embeddedImage: ImageUtils.instance
                        .getImageNetWork(AppImages.icVietQrLogin),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(30, 30),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      'Quét mã QR để tải ứng dụng',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                    ),
                  ),
                  const Text(
                    'Tải ứng dụng để trải nghiệm đủ tính năng',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  SizedBox(
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildButton(
                          width: 300,
                          text: 'App Store',
                          assetImage: AppImages.logoAppStore,
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(left: 14)),
                        _buildButton(
                          width: 300,
                          text: 'Google Play',
                          assetImage: AppImages.logoGooglePlay,
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer()
                ],
              ),
            )),
          );
        });
  }

  openMsgSuccessDialog(
      {required String title,
      String? msg,
      VoidCallback? onTapClose,
      BuildContext? context}) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
                child: Container(
              width: 300,
              height: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (msg != null) ...[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  ButtonWidget(
                    width: 250,
                    height: 35,
                    text: 'Đóng',
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    borderRadius: 5,
                    function: () {
                      Navigator.pop(context);
                      onTapClose;
                    },
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            )),
          );
        });
  }

  openPopup(
      {required Widget child,
      required double width,
      required double height,
      Color barrierColor = Colors.black54}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    return showDialog(
      barrierDismissible: false,
      barrierColor: barrierColor,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
              child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          )),
        );
      },
    );
  }

  openWidgetDialog(
      {required Widget child, double width = 800, double height = 600}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
              child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          )),
        );
      },
    );
  }

  openTransactionDialog(String address, String body) {
    final ScrollController _scrollContoller = ScrollController();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              width: 325,
              height: 450,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Giao dịch mới',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Từ: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Nội dung: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 250,
                          child: SingleChildScrollView(
                            controller: _scrollContoller,
                            child: Text(
                              body,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.GREEN,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: AppColor.WHITE,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future showModelBottomSheet(
      {BuildContext? context,
      required Widget widget,
      required double height}) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      useRootNavigator: true,
      context: context,
      backgroundColor: AppColor.TRANSPARENT,
      builder: (context) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: ClipRRect(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: keyboardHeight,
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: height + keyboardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                ),
                child: widget,
              ),
            ),
          ),
        );
      },
    );
  }

  openMsgDialogQuestion(
      {required String title,
      required String msg,
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
      BuildContext? context}) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
                child: Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: ImageUtils.instance
                        .getImageNetWork(AppImages.icWarning),
                    width: 80,
                    height: 80,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          width: 250,
                          height: 40,
                          text: 'Đóng',
                          textColor: AppColor.GREEN,
                          bgColor: AppColor.WHITE,
                          borderRadius: 5,
                          function: (onCancel != null)
                              ? onCancel
                              : () {
                                  Navigator.pop(context);
                                },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ButtonWidget(
                          width: 250,
                          height: 40,
                          text: 'Xác nhận',
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.GREEN,
                          borderRadius: 5,
                          function: (onConfirm != null)
                              ? onConfirm
                              : () {
                                  Navigator.pop(context);
                                },
                        ),
                      ),
                    ],
                  ),

                  // const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            )),
          );
        });
  }
}
