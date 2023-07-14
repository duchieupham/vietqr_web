import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingWidget extends StatelessWidget {
  const ThemeSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Spacer(),
        Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              width: width,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  _buildItem(
                    context: context,
                    isSelected: provider.getThemeIndex() == 0,
                    imageAsset: 'assets/images/ic-light-web.png',
                    text: 'Sáng',
                    width: 180,
                    function: () => provider.updateThemeByIndex(0),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  _buildItem(
                    context: context,
                    isSelected: provider.getThemeIndex() == 1,
                    imageAsset: 'assets/images/ic-dark-web.png',
                    text: 'Tối',
                    width: 180,
                    function: () => provider.updateThemeByIndex(1),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  _buildItem(
                    context: context,
                    isSelected: provider.getThemeIndex() == 2,
                    imageAsset: 'assets/images/ic-auto-theme-web.png',
                    text: 'Hệ thống',
                    width: 180,
                    function: () => provider.updateThemeByIndex(2),
                  ),
                ],
              ),
            );
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 40)),
        const Spacer(),
      ],
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required bool isSelected,
    required String imageAsset,
    required String text,
    required double width,
    required VoidCallback function,
  }) {
    return InkWell(
      onTap: function,
      child: BoxLayout(
        width: width,
        bgColor: (isSelected)
            ? Theme.of(context).canvasColor
            : DefaultTheme.TRANSPARENT,
        child: Column(
          children: [
            Image.asset(
              imageAsset,
              width: width,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Text(text),
            const Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
    );
  }
}
