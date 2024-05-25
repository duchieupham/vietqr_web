import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/pop_up_menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_dropdown.dart';
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

import '../../../commons/widgets/header/pop_up_menu_web_widget.dart';

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
            width = 80;
          }

          return Container(
            width: width,
            color: AppColor.BLUE_BGR,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: provider.showMenu
                  ? [
                      const SizedBox(height: 40),
                      Expanded(
                        child: _buildListItem(provider, logoutBloc, context),
                      )
                    ]
                  : [
                      const SizedBox(height: 40),
                      Expanded(
                          child:
                              _buildListIconItem(provider, logoutBloc, context))
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
                  context.go('/transactions/list');
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
                  context.go('/create-vietqr');
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
                iconId: AppImages.icMenuContactBlack,
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
      width: 80,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ItemMenuHome(
            title: 'Quản lý giao dịch',
            iconId: AppImages.icMenuTransaction,
            isSelect: currentType == MenuHomeType.TRANSACTION,
            isOnlyIcon: true,
            onTap: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero);
              final double buttonWidth = button.size.width;
              // provider.selectType('');
              showPopup(
                context,
                [
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Quản lý GD thanh toán',
                      isSelect: provider.type == '0' ? true : false,
                      onTap: () {
                        provider.selectType('0');
                        context.go('/transactions/list');
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Quản lý GD chờ xác nhận',
                      isSelect: provider.type == '1' ? true : false,
                      onTap: () {
                        provider.selectType('1');
                        context.go('/transactions/uncategorized');
                      },
                    ),
                  )
                ],
                RelativeRect.fromLTRB(
                  buttonPosition.dx + buttonWidth,
                  buttonPosition.dy * 1.7,
                  buttonPosition.dx + buttonWidth * 2,
                  buttonPosition.dy + button.size.height,
                ),
              );
              // isVisible = true;
              // context.go('/transactions/list');
            },
          ),

          ItemMenuHome(
            title: 'Quản lý TT Kinh Doanh',
            iconId: AppImages.icMenuMerchant,
            isOnlyIcon: true,
            isSelect: currentType == MenuHomeType.ENTERPRISE,
            onTap: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero);
              final double buttonWidth = button.size.width;
              // provider.selectType('');
              showPopup(
                context,
                [
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Cửa hàng',
                      isSelect: provider.type == '2' ? true : false,
                      onTap: () {
                        provider.selectType('2');

                        context.go('/enterprise/store');
                      },
                    ),
                  ),
                ],
                RelativeRect.fromLTRB(
                  buttonPosition.dx + buttonWidth,
                  buttonPosition.dy * 2.6,
                  buttonPosition.dx + buttonWidth * 2,
                  buttonPosition.dy + button.size.height,
                ),
              );
            },
          ),
          ItemMenuHome(
            title: 'Quản lý nhân viên',
            iconId: AppImages.icMenuEmployeeBlack,
            isOnlyIcon: true,
            isSelect: currentType == MenuHomeType.MEMBER,
            onTap: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero);
              final double buttonWidth = button.size.width;
              showPopup(
                context,
                [
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Danh sách nhân viên',
                      isSelect: provider.type == '3' ? true : false,
                      onTap: () {
                        provider.selectType('3');
                        context.go('/member/list');
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Thêm mới nhân viên',
                      isSelect: provider.type == '4' ? true : false,
                      onTap: () {
                        provider.selectType('4');
                        context.go('/member/add-member');
                      },
                    ),
                  )
                ],
                RelativeRect.fromLTRB(
                  buttonPosition.dx + buttonWidth,
                  buttonPosition.dy * 3.6,
                  buttonPosition.dx + buttonWidth * 2,
                  buttonPosition.dy + button.size.height,
                ),
              );
            },
          ),

          ItemMenuHome(
            title: 'Tiện ích QR',
            iconId: AppImages.icMenuQrBlack,
            isSelect: currentType == MenuHomeType.CREATE_QR,
            isOnlyIcon: true,
            bold: true,
            onTap: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero);
              final double buttonWidth = button.size.width;
              showPopup(
                context,
                [
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Tạo mã VietQR',
                      isSelect: provider.type == '5' ? true : false,
                      onTap: () {
                        provider.selectType('5');
                        context.go('/create-vietqr');
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'Ví QR',
                      isSelect: provider.type == '6' ? true : false,
                      onTap: () {
                        provider.selectType('6');
                        context.go('/qr-wallet');
                      },
                    ),
                  )
                ],
                RelativeRect.fromLTRB(
                  buttonPosition.dx + buttonWidth,
                  buttonPosition.dy * 4.4,
                  buttonPosition.dx + buttonWidth * 2,
                  buttonPosition.dy + button.size.height,
                ),
              );
            },
          ),
          if (provider.isAccountIsMerchant)
            ItemMenuHome(
              title: 'Đại lý',
              iconId: AppImages.icMenuContactBlack,
              isOnlyIcon: true,
              isSelect: currentType == MenuHomeType.MERCHANT,
              bold: true,
              onTap: () {
                // DialogWidget.instance.openMsgDialog(
                //     title: 'Bảo trì',
                //     msg:
                //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                // context.go('/merchant/report');
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final Offset buttonPosition = button.localToGlobal(Offset.zero);
                final double buttonWidth = button.size.width;
                showPopup(
                  context,
                  [
                    PopupMenuItem(
                      child: ItemDropDownMenu(
                        title: 'Đại lý',
                        isSelect: provider.type == '7' ? true : false,
                        onTap: () {
                          provider.selectType('7');
                          context.go('/merchant/report');
                        },
                      ),
                    ),
                  ],
                  RelativeRect.fromLTRB(
                    buttonPosition.dx + buttonWidth,
                    buttonPosition.dy * 5.2,
                    buttonPosition.dx + buttonWidth * 2,
                    buttonPosition.dy + button.size.height,
                  ),
                );
              },
            ),
          ItemMenuHome(
            title: 'Tích hợp và kết nối',
            iconId: AppImages.icMenuIntergrated,
            isOnlyIcon: true,
            isSelect: currentType == MenuHomeType.MERCHANT_REQUEST,
            bold: true,
            onTap: () {
              // context.go('/merchant/request');
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero);
              final double buttonWidth = button.size.width;
              showPopup(
                context,
                [
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'API SERVICE',
                      isSelect: provider.type == '8' ? true : false,
                      onTap: () {
                        provider.selectType('8');
                        context.go('/merchant/request');
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'ECOMMERCE',
                      isSelect: provider.type == '9' ? true : false,
                      onTap: () {
                        provider.selectType('9');
                        context.go('/merchant/request/ecommerce');
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ItemDropDownMenu(
                      title: 'MÁY BÁN HÀNG',
                      isSelect: provider.type == '10' ? true : false,
                      onTap: () {
                        provider.selectType('10');
                        context.go('/merchant/request/mbh');
                      },
                    ),
                  )
                ],
                RelativeRect.fromLTRB(
                  buttonPosition.dx + buttonWidth,
                  buttonPosition.dy * 5.2,
                  buttonPosition.dx + buttonWidth * 2,
                  buttonPosition.dy + button.size.height,
                ),
              );
            },
          ),
          ItemMenuHome(
            title: 'Giới thiệu VietQR VN',
            iconId: AppImages.icMenuContactBlack,
            isSelect: currentType == MenuHomeType.INTRO_VIET_QR,
            isOnlyIcon: true,
            bold: true,
            onTap: () {
              DialogWidget.instance.openPopup(
                width: 500,
                height: 300,
                child: const PopupShareCode(),
              );
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
          // ItemMenuHome(
          //   title: 'Giới thiệu VietQR VN',
          //   pathImage: 'assets/images/logo-small-round.png',
          //   isOnlyIcon: true,
          //   isSelect: currentType == MenuHomeType.INTRO_VIET_QR,
          //   isDefaultColor: true,
          //   onTap: () {
          //     provider.updateShowMenu(true);
          //     DialogWidget.instance.openPopup(
          //       width: 500,
          //       height: 300,
          //       child: const PopupShareCode(),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
