import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/header/pop_up_menu_web_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
// import 'package:VietQR/services/providers/clock_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HeaderFullWidget extends StatelessWidget {
  final bool? isSubHeader;
  //providers
  // ClockProvider clockProvider = ClockProvider('');

  const HeaderFullWidget({
    super.key,
    this.isSubHeader,
  });

  // void _initialServices(BuildContext context) {
  //   clockProvider.getRealTime();
  // }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String imgId =
        UserInformationHelper.instance.getAccountInformation().imgId;
    // _initialServices(context);
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Row(
        children: [
          (isSubHeader != null && isSubHeader!)
              ? const SizedBox()
              : Tooltip(
                  message: 'Menu',
                  child: Consumer<MenuCardProvider>(
                    builder: (context, provider, child) {
                      return InkWell(
                        onTap: () {
                          provider.updateShowMenu(!provider.showMenu);
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
                if (isSubHeader != null && isSubHeader!) {
                  context.go('/');
                }
              },
              child: BoxLayout(
                width: 100,
                height: 35,
                padding: const EdgeInsets.all(5),
                bgColor: DefaultTheme.TRANSPARENT,
                borderRadius: 10,
                child: Image.asset(
                  'assets/images/ic-viet-qr.png',
                  width: 80,
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // _buildTitle('Trang chủ'),
          //time
          const Spacer(),
          if (isSubHeader == null || !isSubHeader!) ...[
            Tooltip(
              message: 'Sao chép mã QR',
              child: InkWell(
                onTap: () {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Tính năng đang bảo trì',
                    msg: 'Vui lòng thử lại sau',
                  );
                },
                child: BoxLayout(
                  width: 35,
                  height: 35,
                  borderRadius: 35,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                  child: Icon(
                    Icons.qr_code_rounded,
                    size: 20,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Tooltip(
              message: 'Thêm TK ngân hàng',
              child: InkWell(
                onTap: () {
                  String userId = UserInformationHelper.instance.getUserId();
                  context.go('/bank/create/$userId');
                },
                child: BoxLayout(
                  width: 35,
                  height: 35,
                  borderRadius: 35,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                  child: Icon(
                    Icons.credit_card_rounded,
                    size: 20,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 30)),
          ],
          Tooltip(
            message: 'Thông báo',
            child: InkWell(
              onTap: () {
                DialogWidget.instance.openMsgDialog(
                  title: 'Tính năng đang bảo trì',
                  msg: 'Vui lòng thử lại sau',
                );
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
                  ],
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
          //shortcut
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
