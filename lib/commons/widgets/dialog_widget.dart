import 'dart:async';
import 'dart:ui';
import 'package:VietQR/commons/constants/configurations/numeral.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/pin_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          color: DefaultTheme.TRANSPARENT,
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
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
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
                                color: DefaultTheme.RED_TEXT,
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

  openNotificationDialog({
    required Widget child,
    required double height,
    double? marginRight,
  }) {
    return showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        barrierColor: DefaultTheme.TRANSPARENT,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.topRight,
            child: UnconstrainedBox(
              child: BoxLayout(
                width: 300,
                height: height * 0.7,
                borderRadius: 5,
                enableShadow: true,
                margin: EdgeInsets.only(
                  right: (marginRight != null) ? marginRight : 120,
                  top: 60,
                ),
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
          );
        });
  }

  openBoxWebConfirm({
    required String title,
    required String confirmText,
    required String imageAsset,
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
            color: DefaultTheme.TRANSPARENT,
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
                    Image.asset(
                      imageAsset,
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
                      textColor: DefaultTheme.WHITE,
                      bgColor: (confirmColor != null)
                          ? confirmColor
                          : DefaultTheme.BLUE_TEXT,
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
            color: DefaultTheme.TRANSPARENT,
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
        backgroundColor: DefaultTheme.TRANSPARENT,
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
        backgroundColor: DefaultTheme.TRANSPARENT,
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

  Future openDateTimePickerDialog(
      String title, Function(DateTime) onChanged) async {
    double width = MediaQuery.of(NavigationService.navigatorKey.currentContext!)
        .size
        .width;
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: CupertinoDatePicker(
                            initialDateTime: DateTime.now(),
                            maximumDate: DateTime.now(),
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: onChanged,
                          ),
                        ),
                        ButtonWidget(
                          width: width,
                          text: 'OK',
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          function: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void openLoadingDialog() async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: NavigationService.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: DefaultTheme.TRANSPARENT,
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
                          children: const [
                            CircularProgressIndicator(
                              color: DefaultTheme.GREEN,
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Text(
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
                          color: DefaultTheme.GREEN,
                        ),
                      ),
              ),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  openMsgDialog(
      {required String title, required String msg, VoidCallback? function}) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
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
                  Image.asset(
                    'assets/images/ic-warning.png',
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
                  ButtonWidget(
                    width: 250,
                    height: 40,
                    text: 'Đóng',
                    textColor: DefaultTheme.WHITE,
                    bgColor: DefaultTheme.GREEN,
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

  openPopup(
      {required Widget child, required double width, required double height}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
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

  openWidgetDialog({required Widget child}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
              child: Container(
            width: 800,
            height: 600,
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
          color: DefaultTheme.TRANSPARENT,
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
                              color: DefaultTheme.GREY_TEXT,
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
                              color: DefaultTheme.GREY_TEXT,
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
                        color: DefaultTheme.GREEN,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: DefaultTheme.WHITE,
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
}
