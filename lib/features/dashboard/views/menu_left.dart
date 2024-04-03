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
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuLeft extends StatelessWidget {
  final MenuHomeType currentType;
  final List<Widget> subMenuMerchant;
  final List<Widget> subMenuTransactionUser;
  final List<Widget> subMenuMerchantRequest;
  final List<Widget> subMenuEnterprise;
  final List<Widget> subMenuTransaction;
  final List<Widget> subMenuMember;
  final List<Widget> subMenuQr;

  final Function(int)? onSelectMenu;

  const MenuLeft(
      {super.key,
      required this.currentType,
      this.onSelectMenu,
      this.subMenuTransactionUser = const [],
      this.subMenuMerchantRequest = const [],
      this.subMenuEnterprise = const [],
      this.subMenuTransaction = const [],
      this.subMenuMember = const [],
      this.subMenuQr = const [],
      this.subMenuMerchant = const []});

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
            width = 250;
          } else {
            width = 50;
          }

          return Container(
            width: width,
            color: AppColor.BLUE_BGR,
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
                          color: AppColor.BLUE_BGR),
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
    bool isVisible = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenuHome(
                title: 'Quản lý giao dịch',
                iconId: AppImages.icMenuTransaction,
                enableDropDownList: true,
                listItemDrop: subMenuTransaction,
                isSelect: currentType == MenuHomeType.TRANSACTION,
                bold: true,
                onTap: () {
                  isVisible = true;
                  context.go('/transactions', extra: {'type': '0'});
                },
              ),
              ItemMenuHome(
                title: 'Quản lý TT Kinh Doanh',
                iconId: AppImages.icMenuMerchant,
                enableDropDownList: true,
                listItemDrop: subMenuEnterprise,
                isSelect: currentType == MenuHomeType.ENTERPRISE,
                bold: true,
                onTap: () {
                  context.go('/enterprise/store');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý nhân viên',
                iconId: AppImages.icMenuEmployeeBlack,
                enableDropDownList: true,
                listItemDrop: subMenuMember,
                isSelect: currentType == MenuHomeType.MEMBER,
                bold: true,
                onTap: () {
                  context.go('/member/list');
                },
              ),
              ItemMenuHome(
                title: 'Tiện ích QR',
                iconId: AppImages.icMenuQrBlack,
                isSelect: currentType == MenuHomeType.CREATE_QR,
                enableDropDownList: true,
                listItemDrop: subMenuQr,
                bold: true,
                onTap: () {
                  context.go('/create-qr');
                },
              ),
              // ItemMenuHome(
              //   title: 'Trang chủ',
              //   iconId: AppImages.icMenuQrBlack,
              //   isSelect: currentType == MenuHomeType.HOME,
              //   bold: true,
              //   onTap: () {
              //     context.go('/home');
              //   },
              // ),

              if (UserInformationHelper.instance.getAccountIsMerchant())
                ItemMenuHome(
                  title: 'Đại lý',
                  iconId: AppImages.icMenuContactBlack,
                  enableDropDownList: true,
                  listItemDrop: subMenuMerchant,
                  isSelect: currentType == MenuHomeType.MERCHANT,
                  bold: true,
                  onTap: () {
                    // DialogWidget.instance.openMsgDialog(
                    //     title: 'Bảo trì',
                    //     msg:
                    //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                    context.go('/merchant/report');
                  },
                ),
              ItemMenuHome(
                title: 'Tích hợp và kết nối',
                iconId: AppImages.icMenuIntergrated,
                enableDropDownList: true,
                listItemDrop: subMenuMerchantRequest,
                isSelect: currentType == MenuHomeType.MERCHANT_REQUEST,
                bold: true,
                onTap: () {
                  context.go('/merchant/request');
                },
              ),
              // ItemMenuHome(
              //   title: 'Kết nối máy bán hàng',
              //   iconId: AppImages.icMenuBank,
              //   isSelect: currentType == MenuHomeType.MBH,
              //   onTap: () {
              //     context.go('/merchant/request/mbh');
              //   },
              // ),
              // ItemMenuHome(
              //   title: 'TK ngân hàng',
              //   iconId: AppImages.icMenuContact,
              //   isSelect: currentType == MenuHomeType.BANK_ACCOUNT,
              //   onTap: () {
              //     DialogWidget.instance.openMsgQRInstallApp();
              //   },
              // ),

              // ItemMenuHome(
              //   title: 'Ví QR',
              //   isSelect: currentType == MenuHomeType.WALLET_QR,
              //   bold: true,
              //   onTap: () {
              //     context.go('/qr-wallet');
              //   },
              // ),
              // ItemMenuHome(
              //   title: 'Chia sẻ BĐSD',
              //   isSelect: currentType == MenuHomeType.BUSINESS,
              //   onTap: () {
              //     // onTab(MenuHomeType.BUSINESS);
              //
              //     context.go('/business');
              //   },
              // ),
              ItemMenuHome(
                title: 'Giới thiệu VietQR VN',
                pathImage: AppImages.icMenuContactBlack,
                isSelect: currentType == MenuHomeType.INTRO_VIET_QR,
                bold: true,
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
        // ItemMenuHome(
        //   title: 'Cài đặt',
        //   iconId: AppImages.icMenuSetting,
        //   isSelect: currentType == MenuHomeType.SETTING,
        //   onTap: () {
        //     DialogWidget.instance.openPopup(
        //       width: 800,
        //       height: 650,
        //       child: const PopupSetting(),
        //     );
        //   },
        // ),
        // ItemMenuHome(
        //   title: 'Đăng xuất',
        //   isSelect: currentType == MenuHomeType.LOGOUT,
        //   isLogout: true,
        //   iconId: AppImages.icMenuLogout,
        //   onTap: () {
        //     logoutBloc.add(const LogoutEventSubmit());
        //   },
        // ),
      ],
    );
  }

  Widget _buildListIconItem(
      MenuProvider provider, LogoutBloc logoutBloc, BuildContext context) {
    return SizedBox(
      width: 50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ItemMenuHome(
            title: 'Giao dịch',
            paddingIcon: const EdgeInsets.all(4),
            iconId: AppImages.icMenuTransaction,
            isOnlyIcon: true,
            isSelect: currentType == MenuHomeType.TRANSACTION,
            onTap: () {
              DialogWidget.instance.openMsgDialog(
                  title: 'Bảo trì',
                  msg:
                      'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
              // context.go('/transaction');
              // provider.updateShowMenu(true);
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
            title: 'Doanh nghiệp',
            iconId: AppImages.icMenuHome,
            isSelect: currentType == MenuHomeType.ENTERPRISE,
            isOnlyIcon: true,
            onTap: () {
              context.go('/enterprise/store');
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
                DialogWidget.instance.openMsgDialog(
                    title: 'Bảo trì',
                    msg:
                        'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                // context.go('/merchant/report');
                // provider.updateShowMenu(true);
              },
            ),
          ItemMenuHome(
            title: 'Tích hợp và kết nối',
            paddingIcon: const EdgeInsets.all(4),
            iconId: AppImages.icMenuMerchantRequest,
            isOnlyIcon: true,
            isSelect: currentType == MenuHomeType.MERCHANT_REQUEST,
            onTap: () {
              context.go('/merchant/request');
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
          // ItemMenuHome(
          //   title: 'Chia sẻ BĐSD',
          //   paddingIcon: const EdgeInsets.all(4),
          //   iconId: AppImages.icMenuShareBDSD,
          //   isOnlyIcon: true,
          //   isSelect: currentType == MenuHomeType.BUSINESS,
          //   onTap: () {
          //     // onTab(MenuHomeType.BUSINESS);
          //     provider.updateShowMenu(true);
          //     context.go('/business');
          //   },
          // ),
          ItemMenuHome(
            title: 'Giới thiệu VietQR VN',
            pathImage: 'assets/images/logo-small-round.png',
            isOnlyIcon: true,
            isSelect: currentType == MenuHomeType.INTRO_VIET_QR,
            isDefaultColor: true,
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
    );
  }
}
