import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/header/pop_up_menu_web_widget.dart';
import 'package:VietQR/features/notification/blocs/notification_bloc.dart';
import 'package:VietQR/features/notification/events/notification_event.dart';
import 'package:VietQR/features/notification/states/notification_state.dart';
import 'package:VietQR/features/notification/views/notification_view.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of(context);
    String userId = UserInformationHelper.instance.getUserId();
    _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
    Session.instance.registerEventListener(EventTypes.updateCountNotification,
        () {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _notificationBloc.add(NotificationGetCounterEvent(userId: userId));
      });
    });
    // listenNewNotification(userId);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String imgId =
        UserInformationHelper.instance.getAccountInformation().imgId;
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 14, right: 20),
      height: 60,
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
                          width: 35,
                          height: 35,
                          borderRadius: 35,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                          child: Icon(
                            (provider.showMenu)
                                ? Icons.close_rounded
                                : Icons.menu_rounded,
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const Padding(padding: EdgeInsets.only(right: 10)),
          //logo
          Tooltip(
            message: 'Trang chủ',
            child: InkWell(
              onTap: () {
                if (widget.isSubHeader != null && widget.isSubHeader!) {
                  context.go('/');
                } else {
                  Provider.of<MenuProvider>(context, listen: false)
                      .selectMenu(MenuHomeType.HOME);
                }
              },
              child: Image.asset(
                'assets/images/logo-vietqr-vn.png',
                height: 40,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // _buildTitle('Trang chủ'),
          //time
          const SizedBox(
            width: 12,
          ),
          ButtonIconWidget(
            title: 'Thêm TK ngân hàng',
            function: () {},
            height: 32,
            textSize: 11,
            bgColor: AppColor.WHITE.withOpacity(0.7),
            textColor: AppColor.BLUE_TEXT,
          ),
          const Spacer(),
          ButtonIconWidget(
            title: 'Quét QR',
            function: () {},
            height: 32,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            icon: Icons.qr_code_outlined,
            textSize: 11,
            bgColor: AppColor.WHITE.withOpacity(0.7),
            textColor: AppColor.BLUE_TEXT,
          ),
          const SizedBox(
            width: 8,
          ),
          Tooltip(
            message: 'Thông báo',
            child: InkWell(
              onTap: () {
                DialogWidget.instance.openNotificationDialog(
                    child: NotificationView(
                      notificationBloc: _notificationBloc,
                    ),
                    height: 800,
                    onTapBarrier: () {
                      _notificationBloc.add(
                        NotificationUpdateStatusEvent(
                          userId: UserInformationHelper.instance.getUserId(),
                        ),
                      );
                    });
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
                        borderRadius: 35,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        bgColor: Theme.of(context).cardColor.withOpacity(0.3),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (imgId.trim().isNotEmpty)
                ? ImageUtils.instance.getImageNetWork(imgId)
                : Image.asset('assets/images/ic-avatar.png').image,
          ),
        ),
      ),
    );
  }
}
