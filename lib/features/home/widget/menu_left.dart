import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuLeft extends StatelessWidget {
  final Function(MenuHomeType) onTab;
  const MenuLeft({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    provider.updateShowMenu(!provider.showMenu);
                  },
                  child: Container(
                    width: 75,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: DefaultTheme.CARD_CODE_BG),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 12,
                        ),
                        Text(
                          'Thu gọn',
                          style: TextStyle(fontSize: 11),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 4)),
          Expanded(
              child: _buildListItem(provider, () {
            provider.updateShowMenu(!provider.showMenu);
            Provider.of<MenuCardProvider>(context, listen: false)
                .updateShowMenu(false);
          })),
        ],
      );
    });
  }

  Widget _buildListItem(MenuProvider provider, Function closeMenu) {
    return Column(
      children: [
        ItemMenuHome(
          title: 'Home',
          pathIcon: AppImages.icMenuHome,
          isSelect: provider.menuHomeType == MenuHomeType.HOME,
          onTap: () {
            onTab(MenuHomeType.HOME);
            provider.selectMenu(MenuHomeType.HOME);
            closeMenu();
          },
        ),
        ItemMenuHome(
          title: 'Danh sách tài khoản',
          pathIcon: AppImages.icMenuBank,
          isSelect: provider.menuHomeType == MenuHomeType.BANKLIST,
          onTap: () {
            onTab(MenuHomeType.BANKLIST);
            provider.selectMenu(MenuHomeType.BANKLIST);
            // closeMenu();
          },
        ),
        ItemMenuHome(
          title: 'Danh bạ',
          pathIcon: AppImages.icMenuContact,
          isSelect: provider.menuHomeType == MenuHomeType.CONTACT,
          onTap: () {
            onTab(MenuHomeType.CONTACT);
            provider.selectMenu(MenuHomeType.CONTACT);
            closeMenu();
          },
        ),
        ItemMenuHome(
          title: 'Liên kết',
          pathIcon: AppImages.icMenuLinked,
          enableDropDownList: true,
          isSelect: provider.menuHomeType == MenuHomeType.LINK,
          onTap: () {
            provider.selectMenu(MenuHomeType.LINK);
          },
          listItemDrop: [
            ItemMenuHome(
              title: 'Thêm TK ngân hàng',
              pathIcon: AppImages.icMenuAddBank,
              isDropDownItem: true,
              isSelect:
                  provider.menuHomeType == MenuHomeType.ADD_LINK_BANK_ACCOUNT,
              onTap: () {
                onTab(MenuHomeType.ADD_LINK_BANK_ACCOUNT);
                provider.selectMenu(MenuHomeType.ADD_LINK_BANK_ACCOUNT);
                closeMenu();
              },
            ),
            ItemMenuHome(
              title: 'Liên kết TK MB Bank',
              pathIcon: AppImages.icMenuLinked,
              isDropDownItem: true,
              isSelect: provider.menuHomeType == MenuHomeType.ADD_LINK_BANK_MB,
              onTap: () {
                onTab(MenuHomeType.ADD_LINK_BANK_MB);
                provider.selectMenu(MenuHomeType.ADD_LINK_BANK_MB);
                closeMenu();
              },
            ),
            ItemMenuHome(
              title: 'Mở TK MB Bank',
              pathImage: AppImages.icMenuNewMB,
              isDropDownItem: true,
              isSelect:
                  provider.menuHomeType == MenuHomeType.OPEN_BANK_MB_ACCOUNT,
              onTap: () {
                onTab(MenuHomeType.OPEN_BANK_MB_ACCOUNT);
                provider.selectMenu(MenuHomeType.OPEN_BANK_MB_ACCOUNT);
                closeMenu();
              },
            ),
          ],
        ),
        ItemMenuHome(
          title: 'Quét QR',
          pathIcon: AppImages.icMenuQR,
          enableDropDownList: true,
          isSelect: provider.menuHomeType == MenuHomeType.SCAN_QR,
          onTap: () {
            provider.selectMenu(MenuHomeType.SCAN_QR);
          },
          listItemDrop: [
            ItemMenuHome(
              title: 'Cập nhật thông tin qua CCCD',
              pathIcon: AppImages.icMenuScanCCCD,
              isDropDownItem: true,
              isSelect: provider.menuHomeType == MenuHomeType.SCAN_CCCD,
              onTap: () {
                onTab(MenuHomeType.SCAN_CCCD);
                provider.selectMenu(MenuHomeType.SCAN_CCCD);
                closeMenu();
              },
            ),
            ItemMenuHome(
              title: 'Thêm/Liên kết TK ngân hàng',
              pathIcon: AppImages.icMenuScanBank,
              isDropDownItem: true,
              isSelect: provider.menuHomeType == MenuHomeType.SCAN_BANK,
              onTap: () {
                onTab(MenuHomeType.SCAN_BANK);
                provider.selectMenu(MenuHomeType.SCAN_BANK);
                closeMenu();
              },
            ),
          ],
        ),
        ItemMenuHome(
          title: 'Doanh nghiệp',
          pathIcon: AppImages.icMenuBusiness,
          isSelect: provider.menuHomeType == MenuHomeType.BUSINESS,
          onTap: () {
            onTab(MenuHomeType.BUSINESS);
            provider.selectMenu(MenuHomeType.BUSINESS);
            closeMenu();
          },
        ),
        ItemMenuHome(
          title: 'Giới thiệu VietQR VN',
          pathImage: AppImages.icMenuIntroVietQrVN,
          isSelect: provider.menuHomeType == MenuHomeType.INTRO_VIET_QR,
          onTap: () {
            onTab(MenuHomeType.INTRO_VIET_QR);
            provider.selectMenu(MenuHomeType.INTRO_VIET_QR);
            closeMenu();
          },
        ),
        const Spacer(),
        ItemMenuHome(
          title: 'Cài đặt',
          pathIcon: AppImages.icMenuSetting,
          isSelect: provider.menuHomeType == MenuHomeType.SETTING,
          onTap: () {
            onTab(MenuHomeType.SETTING);
            provider.selectMenu(MenuHomeType.OTHER);
            closeMenu();
          },
        ),
        ItemMenuHome(
          title: 'Đăng xuất',
          isLogout: true,
          isSelect: provider.menuHomeType == MenuHomeType.LOGOUT,
          pathIcon: AppImages.icMenuLogout,
          onTap: () {
            onTab(MenuHomeType.LOGOUT);
            provider.selectMenu(MenuHomeType.OTHER);
          },
        ),
      ],
    );
  }
}