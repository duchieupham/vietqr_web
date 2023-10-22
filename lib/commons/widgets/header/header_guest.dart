import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dialog_open_bank_account.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/header/pop_up_menu_web_widget.dart';
import 'package:VietQR/features/notification/blocs/notification_bloc.dart';
import 'package:VietQR/features/notification/events/notification_event.dart';
import 'package:VietQR/features/notification/states/notification_state.dart';
import 'package:VietQR/features/notification/views/notification_view.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HeaderGuest extends StatelessWidget {
  const HeaderGuest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String imgId =
        UserInformationHelper.instance.getAccountInformation().imgId;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Row(
        children: [
          Tooltip(
            message: 'Trang chủ',
            child: InkWell(
              onTap: () {
                context.go('/');
              },
              child: Image.asset(
                'assets/images/logo-vietqr-vn.png',
                height: 50,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // _buildTitle('Trang chủ'),
          //time
          const Spacer(),
          InkWell(
            onTap: () {
              DialogWidget.instance.openPopup(
                child: const DialogOpenBankAccount(),
                width: 500,
                height: 650,
              );
            },
            child: const Text(
              'Mở tài khoản MB Bank',
              style: TextStyle(
                color: AppColor.MB_BLUE,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
