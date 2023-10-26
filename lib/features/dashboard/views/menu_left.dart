import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/information_user/widget/popup_share_code.dart';
import 'package:VietQR/features/logout/blocs/log_out_bloc.dart';
import 'package:VietQR/features/logout/events/log_out_event.dart';
import 'package:VietQR/features/logout/states/log_out_state.dart';
import 'package:VietQR/features/setting/widgets/popup_setting.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuLeft extends StatelessWidget {
  final MenuHomeType currentType;
  final Function(int)? onSelectMenu;

  const MenuLeft({super.key, required this.currentType, this.onSelectMenu});

  @override
  Widget build(BuildContext context) {
    final LogoutBloc logoutBloc = BlocProvider.of(context);
    Provider.of<MenuProvider>(context, listen: false).checkAccountIsMerchant();
    return BlocListener<LogoutBloc, LogoutState>(
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
      child: Consumer<MenuProvider>(
        builder: (context, provider, child) {
          double width = 0;
          if (provider.showMenu) {
            width = 220;
          } else {
            width = 0;
          }
          return Container(
            width: width,
            color: AppColor.BLUE_TEXT.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (provider.showMenu)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                if (provider.showMenu)
                  Expanded(
                    child: _buildListItem(provider, () {
                      Provider.of<MenuCardProvider>(context, listen: false)
                          .updateShowMenu(false);
                    }, context, logoutBloc),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(MenuProvider provider, Function closeListCard,
      BuildContext context, LogoutBloc logoutBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenuHome(
                title: 'Trang chủ',
                pathIcon: AppImages.icMenuHome,
                isSelect: currentType == MenuHomeType.HOME,
                onTap: () {
                  context.go('/home');
                },
              ),
              if (provider.isAccountIsMerchant)
                ItemMenuHome(
                  title: 'Đại lý',
                  pathIcon: AppImages.icMenuHome,
                  isSelect: currentType == MenuHomeType.MERCHANT,
                  onTap: () {
                    context.go('/merchant');
                  },
                ),
              ItemMenuHome(
                title: 'Giao dịch',
                pathIcon: AppImages.icMenuBank,
                isSelect: currentType == MenuHomeType.TRANSACTION,
                onTap: () {
                  context.go('/transaction');
                },
              ),
              ItemMenuHome(
                title: 'TK ngân hàng',
                pathIcon: AppImages.icMenuContact,
                isSelect: currentType == MenuHomeType.BANK_ACCOUNT,
                onTap: () {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Tính năng đang bảo trì',
                    msg: 'Vui lòng thử lại sau',
                  );
                },
              ),
              ItemMenuHome(
                title: 'Tạo mã VietQR',
                pathIcon: AppImages.icVietQrSmall,
                isSelect: currentType == MenuHomeType.CREATE_QR,
                onTap: () {
                  context.go('/create-qr');
                },
              ),
              ItemMenuHome(
                title: 'Ví QR',
                pathIcon: AppImages.icMenuBusiness,
                isSelect: currentType == MenuHomeType.WALLET_QR,
                onTap: () {
                  context.go('/qr-wallet');
                },
              ),
              ItemMenuHome(
                title: 'Chia sẻ BĐSD',
                pathIcon: AppImages.icMenuBusiness,
                isSelect: currentType == MenuHomeType.BUSINESS,
                onTap: () {
                  // onTab(MenuHomeType.BUSINESS);

                  context.go('/business');
                },
              ),
              ItemMenuHome(
                title: 'Giới thiệu VietQR VN',
                pathImage: AppImages.icMenuIntroVietQrVN,
                isSelect: currentType == MenuHomeType.INTRO_VIET_QR,
                onTap: () {
                  DialogWidget.instance.openPopup(
                    width: 500,
                    height: 300,
                    child: const PopupShareCode(),
                  );
                },
              ),
            ],
          ),
        ),
        ItemMenuHome(
          title: 'Cài đặt',
          pathIcon: AppImages.icMenuSetting,
          isSelect: currentType == MenuHomeType.SETTING,
          onTap: () {
            DialogWidget.instance.openPopup(
              width: 800,
              height: 650,
              child: const PopupSetting(),
            );
          },
        ),
        ItemMenuHome(
          title: 'Đăng xuất',
          isLogout: true,
          isSelect: currentType == MenuHomeType.LOGOUT,
          pathIcon: AppImages.icMenuLogout,
          onTap: () {
            logoutBloc.add(const LogoutEventSubmit());
          },
        ),
      ],
    );
  }
}
