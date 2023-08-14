import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/features/setting/views/add_hook_view.dart';
import 'package:VietQR/features/setting/views/get_key_view.dart';
import 'package:VietQR/features/setting/views/setting_bdsd_screen.dart';
import 'package:VietQR/features/setting/widgets/theme_setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/setting_bloc.dart';

class PopupSetting extends StatefulWidget {
  const PopupSetting({Key? key}) : super(key: key);

  @override
  State<PopupSetting> createState() => _PopupSettingState();
}

class _PopupSettingState extends State<PopupSetting> {
  int indexPage = 0;

  changePage(int page) {
    setState(() {
      indexPage = page;
    });
  }

  List<Widget> pages = [
    const ThemeSettingWidget(),
    const SettingBDSD(),
    GetKeyView(),
    AddHookView()
  ];
  String getTitle() {
    if (indexPage == 0) {
      return 'Giao diện';
    } else if (indexPage == 1) {
      return 'Cài đặt nhận biến động số dư';
    } else if (indexPage == 2) {
      return 'Get key';
    }
    return 'Thêm hook';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            Expanded(child: _buildTitle()),
            Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Stack(
                    children: [
                      pages[indexPage],
                      Positioned(
                        top: 16,
                        right: 0,
                        left: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTitle(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.3),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Cài đặt',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        _buildItemTitle(AppImages.icThemeBlue, 'Giao diện', () {
          changePage(0);
        }, isSelected: indexPage == 0),
        _buildItemTitle(AppImages.icKeyBlue, 'Setting BĐSD', () {
          changePage(1);
        }, isSelected: indexPage == 1),
        _buildItemTitle(AppImages.icKeyBlue, 'Get key', () {
          changePage(2);
        }, isSelected: indexPage == 2),
        _buildItemTitle(AppImages.icHookBlue, 'Thêm hook', () {
          changePage(3);
        }, isSelected: indexPage == 3),
      ],
    );
  }

  Widget _buildItemTitle(String pathIcon, String title, VoidCallback onTab,
      {bool isSelected = false}) {
    return InkWell(
      onTap: onTab,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          color:
              isSelected ? DefaultTheme.ITEM_MENU_SELECTED : Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Image.asset(
                pathIcon,
                height: 30,
                width: 45,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              )
            ],
          )),
    );
  }
}
