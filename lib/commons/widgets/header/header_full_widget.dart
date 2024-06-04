import 'dart:async';
import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/clocker_widget.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/commons/widgets/header/pop_up_menu_web_widget.dart';
import 'package:VietQR/features/home/provider/wallet_home_provider.dart';
import 'package:VietQR/features/notification/blocs/notification_bloc.dart';
import 'package:VietQR/features/notification/events/notification_event.dart';
import 'package:VietQR/features/notification/states/notification_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/noti_invoice_dto.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../../layouts/dialog/pop_up_menu_header_widget.dart';

class HeaderFullWidget extends StatefulWidget {
  final bool? isSubHeader;
  //providers
  // ClockProvider clockProvider = ClockProvider('');

  const HeaderFullWidget({
    super.key,
    this.isSubHeader,
  });

  @override
  State<HeaderFullWidget> createState() => _HeaderFullWidgetState();
}

class _HeaderFullWidgetState extends State<HeaderFullWidget> {
  late NotificationBloc _notificationBloc;
  int _notificationCount = 0;
  int _notiInvoice = 0;
  NotificationInvoiceDTO? notiDto;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of(context);
    String userId = UserInformationHelper.instance.getUserId();
    _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
    _notificationBloc.add(NotificationGetInvoiceEvent(userId: userId));
    Session.instance.registerEventListener(EventTypes.updateCountNotification,
        () {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
      });
    });
    // Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) {
    //     toastification.show(
    //       context: context,
    //       type: ToastificationType.success,
    //       style: ToastificationStyle.flat,
    //       title: const Text('Thanh toán thàng công số tiền'),
    //       description: Text(StringUtils.formatNumberAmount(3500000)),
    //       alignment: Alignment.topRight,
    //       autoCloseDuration: const Duration(seconds: 4),
    //       boxShadow: lowModeShadow,
    //     );
    //   },
    // );
    // listenNewNotification(userId);
  }

  RelativeRect position() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition =
        button.localToGlobal(Offset.zero); // Top left corner of the button
    final double buttonWidth = button.size.width;
    final double buttonHeight = button.size.height;

    return RelativeRect.fromLTRB(
      buttonPosition.dx + buttonWidth, // Left edge of the button
      buttonPosition.dy + buttonHeight, // Bottom edge of the button
      buttonPosition.dx + buttonWidth * 0.16, // Right edge of the button
      buttonPosition.dy + buttonHeight, // Bottom edge of the button
    );
  }

  String htmlString = """
            <div>
             <span style="font-size: 12;">Bạn có 1 hóa đơn<strong>450,000,000 VND</strong><br>cần thanh toán!</span>
            </div>
            """;

  @override
  Widget build(BuildContext context) {
    // final RenderBox button = context.findRenderObject() as RenderBox;
    // final RenderBox overlay =
    //     Overlay.of(context).context.findRenderObject() as RenderBox;
    // final RelativeRect position = RelativeRect.fromRect(
    //   Rect.fromPoints(
    //     button.localToGlobal(Offset.zero, ancestor: overlay),
    //     button.localToGlobal(button.size.bottomRight(Offset.zero),
    //         ancestor: overlay),
    //   ),
    //   Offset.zero & overlay.size,
    // );
    final double width = MediaQuery.of(context).size.width;
    final String imgId =
        UserInformationHelper.instance.getAccountInformation().imgId;
    return Container(
      width: width,
      color: AppColor.BLUE_BGR,
      padding: const EdgeInsets.only(left: 14, right: 20),
      height: 80,
      child: Row(
        children: [
          (widget.isSubHeader != null && widget.isSubHeader!)
              ? const SizedBox()
              : Tooltip(
                  message: 'Menu',
                  child: Consumer<MenuProvider>(
                    builder: (context, provider, child) {
                      return InkWell(
                        onTap: () {
                          Session.instance.fetchWallet();
                          provider.updateShowMenu(!provider.showMenu);
                          Provider.of<MenuCardProvider>(context, listen: false)
                              .updateShowMenu(false);
                        },
                        child: BoxLayout(
                          width: 40,
                          height: 40,
                          borderRadius: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          bgColor: AppColor.WHITE,
                          border: Border.all(color: AppColor.BLACK, width: 0.5),
                          child: Icon(
                            Icons.menu_rounded,
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const Padding(padding: EdgeInsets.only(right: 12)),
          //logo
          Tooltip(
            message: 'Trang chủ',
            child: InkWell(
              onTap: () {
                context.go('/');
              },
              child: Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
                height: 40,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const ClockWidget()),

          const Spacer(),
          BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationInvoiceSuccessState) {
                notiDto = state.noti;
              }
            },
            builder: (context, state) {
              if (notiDto == null || notiDto!.totalInvoice == 0) {
                return const SizedBox.shrink();
              }
              return Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   width: 30,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     color: AppColor.ORANGE_DARK.withOpacity(0.3),
                    //   ),
                    //   height: 30,
                    //   child: const Center(
                    //     child: Icon(
                    //       Icons.receipt_long_outlined,
                    //       color: AppColor.ORANGE_DARK,
                    //       size: 24,
                    //     ),
                    //   ),
                    // ),
                    Image.asset(
                      'assets/images/ic-noti-invoice.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${notiDto!.totalInvoice}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' hoá đơn chưa thanh toán!',
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.go('/invoice');
                      },
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.ORANGE_DARK.withOpacity(0.3),
                        ),
                        child: const Center(
                          child: Text(
                            'Truy cập',
                            style: TextStyle(
                              color: AppColor.ORANGE_DARK,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 30),
          Tooltip(
            message: 'Menu_popup',
            child: InkWell(
              key: _buttonKey,
              onTap: () {
                // _showPopup(context);
                showMenu(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  context: context,
                  constraints: const BoxConstraints(maxWidth: 400),
                  position: position(),
                  items: <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 0,
                      height: 600,
                      child: PopUpMenuWidget(),
                    ),
                  ],
                );
                //
                // showPopupMenu(context);
                //
                // showMenu(
                //     context: context,
                //     position: _buttonMenuPosition(context),
                //     items: const [PopupMenuItem(child: PopUpMenuWidget())]);

                //   showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       content: PopUpMenuWidget(), // Sử dụng PopUpMenuWidget ở đây
                //     );
                //   },
                // );
              },
              child: SizedBox(
                width: 40,
                height: 60,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: BoxLayout(
                        width: 35,
                        height: 35,
                        borderRadius: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        bgColor: AppColor.WHITE,
                        border: Border.all(color: AppColor.BLACK, width: 0.5),
                        child: Icon(
                          Icons.menu_outlined,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Tooltip(
            message: 'Thông báo',
            child: InkWell(
              onTap: () {
                DialogWidget.instance.openMsgDialog(
                    title: 'Bảo trì',
                    msg:
                        'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                // DialogWidget.instance.openNotificationDialog(
                //     child: NotificationView(
                //       notificationBloc: _notificationBloc,
                //     ),
                //     height: 800,
                //     onTapBarrier: () {
                //       _notificationBloc.add(
                //         NotificationUpdateStatusEvent(
                //           userId: UserInformationHelper.instance.getUserId(),
                //         ),
                //       );
                //     });
              },
              child: SizedBox(
                width: 40,
                height: 60,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: BoxLayout(
                        width: 35,
                        height: 35,
                        borderRadius: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        bgColor: AppColor.WHITE,
                        border: Border.all(color: AppColor.BLACK, width: 0.5),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    BlocConsumer<NotificationBloc, NotificationState>(
                      listener: (context, state) {
                        //
                      },
                      builder: (context, state) {
                        if (state is NotificationCountSuccessState) {
                          _notificationCount = state.count;
                        }
                        if (state is NotificationUpdateStatusSuccessState) {
                          _notificationCount = 0;
                        }
                        if (_notificationCount != 0) {
                          return Positioned(
                            top: 5,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColor.RED_CALENDAR,
                              ),
                              child: Text(
                                _notificationCount.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      (_notificationCount.toString().length >=
                                              3)
                                          ? 8
                                          : 10,
                                  color: AppColor.WHITE,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
          //shortcut
          Text(
            UserInformationHelper.instance.getUserFullname(),
            style: const TextStyle(color: AppColor.GREY_TEXT),
          ),
          const SizedBox(
            width: 8,
          ),
          _buildAvatar(context, imgId, 35),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String imgId, double size) {
    return InkWell(
      onTap: () {
        PopupMenuWebWidget.instance.showPopupMenu(context, imgId);
      },
      child: Container(
        width: size,
        height: size,
        padding: (imgId.trim().isNotEmpty)
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: AppColor.WHITE,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (imgId.trim().isNotEmpty)
                ? ImageUtils.instance.getImageNetWork(imgId)
                : ImageUtils.instance
                    .getImageNetWork(AppImages.personalRelation),
          ),
        ),
      ),
    );
  }

  RelativeRect _buttonMenuPosition(BuildContext context) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    const Offset offset = Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
      ),
      offset & overlay.size,
    );
    return position;
  }

  Future<void> showPopupMenu(BuildContext context) async {
    final RelativeRect position = _buttonMenuPosition(context);
    await showMenu(
      context: context,
      position: position,
      items: const [PopupMenuItem(child: PopUpMenuWidget())],
    );
  }

  Widget _buildInfoTelegram() {
    return InkWell(
      onTap: () {
        html.window.open('https://t.me/vietqrdev', 'new tab');
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE.withOpacity(0.5)),
        child: Row(
          children: [
            const Text(
              'My VietQR',
              style: TextStyle(
                  // fontWeight: FontWeight.w600,
                  color: AppColor.BLACK,
                  fontSize: 12),
            ),
            const SizedBox(
              width: 8,
            ),
            Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.logoTelegram),
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallet() {
    return Consumer<WalletHomeProvider>(builder: (context, provider, child) {
      return Container(
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE.withOpacity(0.5)),
        child: Row(
          children: [
            Text(
              provider.showAmount
                  ? '${CurrencyUtils.instance.getCurrencyFormatted(Session.instance.wallet.amount)} VQR'
                  : '********',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColor.BLACK,
                  fontSize: 12),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                provider.changeShowAmount();
              },
              child: provider.showAmount
                  ? const Icon(
                      Icons.visibility,
                      size: 14,
                    )
                  : const Icon(
                      Icons.visibility_off,
                      size: 14,
                    ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              Session.instance.wallet.point,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColor.BLACK,
                  fontSize: 12),
            ),
            const SizedBox(
              width: 4,
            ),
            Image(
              image: ImageUtils.instance.getImageNetWork(AppImages.icPoint),
              width: 16,
            ),
          ],
        ),
      );
    });
  }

  final GlobalKey _buttonKey = GlobalKey();

  void _showPopup(BuildContext context) {
    final RenderBox buttonRenderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);

    // Width and height of the button
    final double buttonWidth = buttonRenderBox.size.width;
    final double buttonHeight = buttonRenderBox.size.height;

    // Popup content
    const Widget popupContent = PopUpMenuWidget();

    // Display popup
    showOverlayPopup(
        context, buttonPosition, buttonWidth, buttonHeight, popupContent);
  }

  void showOverlayPopup(BuildContext context, Offset buttonPosition,
      double buttonWidth, double buttonHeight, Widget content) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: buttonPosition.dx - (buttonWidth / 2),
        top: buttonPosition.dy + buttonHeight,
        width: buttonWidth,
        child: Material(
          elevation: 4.0,
          child: content,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Close popup after 3 seconds
    // Future.delayed(Duration(seconds: 3), () {
    //   overlayEntry.remove();
    // });
  }
}
