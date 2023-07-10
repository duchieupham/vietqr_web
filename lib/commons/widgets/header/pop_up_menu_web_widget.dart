import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/information_user/widget/popup_share_code.dart';
import 'package:VietQR/features/logout/blocs/log_out_bloc.dart';
import 'package:VietQR/features/logout/events/log_out_event.dart';
import 'package:VietQR/features/logout/states/log_out_state.dart';
import 'package:VietQR/features/setting/widgets/card_number_setting_widget.dart';
import 'package:VietQR/features/setting/widgets/theme_setting_widget.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PopupMenuWebWidget {
  const PopupMenuWebWidget._privateConsrtructor();

  static const PopupMenuWebWidget _instance =
      PopupMenuWebWidget._privateConsrtructor();
  static PopupMenuWebWidget get instance => _instance;

  Future<void> showPopupMenu(BuildContext context, String imgId) async {
    final RelativeRect position = _buttonMenuPosition(context);
    final LogoutBloc logoutBloc = BlocProvider.of(context);
    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (imgId.trim().isNotEmpty)
                        ? ImageUtils.instance.getImageNetWork(imgId)
                        : Image.asset('assets/images/ic-avatar.png').image,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserInformationHelper.instance.getUserFullname(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    _buildPoint()
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 0,
          height: 10,
          child: SizedBox(),
        ),
        PopupMenuItem<int>(
          value: 1,
          height: 40,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              context.go('/user_information');
            },
            child: Row(
              children: const [
                Icon(
                  Icons.account_circle_outlined,
                  size: 15,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  'Thông tin cá nhân',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          height: 40,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              DialogWidget.instance.openPopup(
                width: 500,
                height: 500,
                child: CardNumberSettingWidget(),
              );
            },
            child: Row(
              children: const [
                Icon(
                  Icons.wifi_tethering_sharp,
                  size: 15,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  'Cài đặt VietQR ID Card',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<int>(
            value: 2,
            height: 40,
            child: BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is LogoutSuccessfulState) {
                  Navigator.pop(context);
                  if (Session.instance.userECOMId.trim().isNotEmpty) {
                    Session.instance.updateUserECOMId('');
                    context.push('/ecom');
                  } else {
                    context.push('/login');
                  }
                }
                if (state is LogoutFailedState) {
                  Navigator.pop(context);
                  DialogWidget.instance.openMsgDialog(
                    title: 'Không thể đăng xuất',
                    msg: 'Vui lòng thử lại sau.',
                  );
                }
              },
              child: InkWell(
                onTap: () {
                  logoutBloc.add(const LogoutEventSubmit());
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: DefaultTheme.RED_CALENDAR,
                      size: 15,
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      'Đăng xuất',
                      style: TextStyle(
                        fontSize: 13,
                        color: DefaultTheme.RED_CALENDAR,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
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

  Widget _buildPoint() {
    return Row(
      children: [
        Text(
          Session.instance.wallet.point ?? '',
          style: const TextStyle(fontSize: 12),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Image.asset(
            'assets/images/ic-point.png',
            width: 20,
          ),
        )
      ],
    );
  }
}
