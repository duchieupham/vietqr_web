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
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Text(
                'Giao diện',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
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
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                SizedBox(
                  width: width,
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      _buildItem(
                        context: context,
                        isSelected: provider.getThemeIndex() == 0,
                        imageAsset: 'assets/images/ic-light-web.png',
                        text: 'Sáng',
                        width: 200 - 20,
                        function: () => provider.updateThemeByIndex(0),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      _buildItem(
                        context: context,
                        isSelected: provider.getThemeIndex() == 1,
                        imageAsset: 'assets/images/ic-dark-web.png',
                        text: 'Tối',
                        width: 200 - 20,
                        function: () => provider.updateThemeByIndex(1),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      _buildItem(
                        context: context,
                        isSelected: provider.getThemeIndex() == 2,
                        imageAsset: 'assets/images/ic-auto-theme-web.png',
                        text: 'Hệ thống',
                        width: 200 - 20,
                        function: () => provider.updateThemeByIndex(2),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 20)),
                    ],
                  ),
                )
              ],
            );
          },
        ),
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
