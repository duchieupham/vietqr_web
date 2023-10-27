import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/features/logout/blocs/log_out_bloc.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/logout/events/log_out_event.dart';
import 'package:VietQR/features/logout/states/log_out_state.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/features/setting/widgets/popup_setting.dart';
import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/features/information_user/widget/popup_share_code.dart';

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
            width = 50;
          }
          print('------------------- $width');
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
                    child: _buildListItem(provider, logoutBloc, context),
                  )
                else
                  Expanded(
                      child: _buildListIconItem(provider, logoutBloc, context))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(
      MenuProvider provider, LogoutBloc logoutBloc, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenuHome(
                title: 'Trang chủ',
                iconId: AppImages.icMenuHome,
                isSelect: currentType == MenuHomeType.HOME,
                onTap: () {
                  context.go('/home');
                },
              ),
              ItemMenuHome(
                title: 'Giao dịch',
                iconId: AppImages.icMenuTransaction,
                isSelect: currentType == MenuHomeType.TRANSACTION,
                onTap: () {
                  context.go('/transaction');
                },
              ),
              if (provider.isAccountIsMerchant)
                ItemMenuHome(
                  title: 'Đại lý',
                  iconId: AppImages.icMenuBank,
                  isSelect: currentType == MenuHomeType.MERCHANT,
                  onTap: () {
                    context.go('/merchant');
                  },
                ),
              ItemMenuHome(
                title: 'TK ngân hàng',
                iconId: AppImages.icMenuContact,
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
                iconId: AppImages.icVietQrSmall,
                isSelect: currentType == MenuHomeType.CREATE_QR,
                onTap: () {
                  context.go('/create-qr');
                },
              ),
              ItemMenuHome(
                title: 'Ví QR',
                isSelect: currentType == MenuHomeType.WALLET_QR,
                onTap: () {
                  context.go('/qr-wallet');
                },
              ),
              ItemMenuHome(
                title: 'Chia sẻ BĐSD',
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
          iconId: AppImages.icMenuSetting,
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
          isSelect: currentType == MenuHomeType.LOGOUT,
          iconId: AppImages.icMenuLogout,
          onTap: () {
            logoutBloc.add(const LogoutEventSubmit());
          },
        ),
      ],
    );
  }

  Widget _buildListIconItem(
      MenuProvider provider, LogoutBloc logoutBloc, BuildContext context) {
    return SizedBox(
      width: 50,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ItemMenuHome(
                  title: 'Trang chủ',
                  isOnlyIcon: true,
                  paddingIcon: const EdgeInsets.all(4),
                  iconId: AppImages.icMenuHome,
                  isSelect: currentType == MenuHomeType.HOME,
                  onTap: () {
                    context.go('/home');
                    provider.updateShowMenu(true);
                  },
                ),
                ItemMenuHome(
                  title: 'Giao dịch',
                  paddingIcon: const EdgeInsets.all(4),
                  iconId: AppImages.icMenuTransaction,
                  isOnlyIcon: true,
                  isSelect: currentType == MenuHomeType.TRANSACTION,
                  onTap: () {
                    context.go('/transaction');
                    provider.updateShowMenu(true);
                  },
                ),
                if (provider.isAccountIsMerchant)
                  ItemMenuHome(
                    title: 'Đại lý',
                    paddingIcon: const EdgeInsets.all(4),
                    iconId: AppImages.icMenuBank,
                    isOnlyIcon: true,
                    isSelect: currentType == MenuHomeType.MERCHANT,
                    onTap: () {
                      context.go('/merchant');
                      provider.updateShowMenu(true);
                    },
                  ),
                ItemMenuHome(
                  title: 'TK ngân hàng',
                  paddingIcon: const EdgeInsets.all(4),
                  iconId: AppImages.icMenuContact,
                  isOnlyIcon: true,
                  isSelect: currentType == MenuHomeType.BANK_ACCOUNT,
                  onTap: () {
                    provider.updateShowMenu(true);
                    DialogWidget.instance.openMsgDialog(
                      title: 'Tính năng đang bảo trì',
                      msg: 'Vui lòng thử lại sau',
                    );
                  },
                ),
                ItemMenuHome(
                  title: 'Tạo mã VietQR',
                  paddingIcon: const EdgeInsets.all(4),
                  iconId: AppImages.icMenuQR,
                  isOnlyIcon: true,
                  isSelect: currentType == MenuHomeType.CREATE_QR,
                  onTap: () {
                    provider.updateShowMenu(true);
                    context.go('/create-qr');
                  },
                ),
                ItemMenuHome(
                  title: 'Ví QR',
                  iconId: AppImages.icMenuWallet,
                  paddingIcon: const EdgeInsets.all(4),
                  isOnlyIcon: true,
                  isSelect: currentType == MenuHomeType.WALLET_QR,
                  onTap: () {
                    provider.updateShowMenu(true);
                    context.go('/qr-wallet');
                  },
                ),
                ItemMenuHome(
                  title: 'Chia sẻ BĐSD',
                  paddingIcon: const EdgeInsets.all(4),
                  iconId: AppImages.icMenuShareBDSD,
                  isOnlyIcon: true,
                  isSelect: currentType == MenuHomeType.BUSINESS,
                  onTap: () {
                    // onTab(MenuHomeType.BUSINESS);
                    provider.updateShowMenu(true);
                    context.go('/business');
                  },
                ),
                ItemMenuHome(
                  title: 'Giới thiệu VietQR VN',
                  iconId: AppImages.icVietQrSmall,
                  paddingIcon: const EdgeInsets.all(4),
                  isOnlyIcon: true,
                  isSelect: currentType == MenuHomeType.INTRO_VIET_QR,
                  onTap: () {
                    provider.updateShowMenu(true);
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
          const Spacer(),
        ],
      ),
    );
  }
}
