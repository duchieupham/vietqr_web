import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:VietQR/features/information_user/widget/popup_share_code.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuTop extends StatelessWidget {
  final MenuHomeType currentType;
  const MenuTop({super.key, required this.currentType});

  @override
  Widget build(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).checkAccountIsMerchant();
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        double height = 0;
        if (provider.showMenu) {
          height = 50;
        } else {
          height = 0;
        }
        return Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          color: AppColor.BLUE_TEXT.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemMenuTop(
                title: 'Trang chủ',
                isSelect: currentType == MenuHomeType.HOME,
                onTap: () {
                  context.go('/home');
                },
              ),

              ItemMenuTop(
                title: 'Giao dịch',
                isSelect: currentType == MenuHomeType.TRANSACTION,
                onTap: () {
                  context.go('/transaction');
                },
              ),
              if (provider.isAccountIsMerchant)
                ItemMenuTop(
                  title: 'Đại lý',
                  isSelect: currentType == MenuHomeType.MERCHANT,
                  onTap: () {
                    context.go('/merchant');
                  },
                ),
              ItemMenuTop(
                title: 'TK ngân hàng',
                isSelect: currentType == MenuHomeType.BANK_ACCOUNT,
                onTap: () {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Tính năng đang bảo trì',
                    msg: 'Vui lòng thử lại sau',
                  );
                },
              ),
              ItemMenuTop(
                title: 'Tạo mã VietQR',
                isSelect: currentType == MenuHomeType.CREATE_QR,
                onTap: () {
                  context.go('/create-qr');
                },
              ),
              ItemMenuTop(
                title: 'Ví QR',
                isSelect: currentType == MenuHomeType.WALLET_QR,
                onTap: () {
                  context.go('/qr-wallet');
                },
              ),
              // ItemMenuTop(
              //   title: 'Chia sẻ BĐSD',
              //   isSelect: currentType == MenuHomeType.BUSINESS,
              //   onTap: () {
              //     // onTab(MenuHomeType.BUSINESS);
              //
              //     context.go('/business');
              //   },
              // ),
              ItemMenuTop(
                title: 'Giới thiệu',
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
        );
      },
    );
  }
}
