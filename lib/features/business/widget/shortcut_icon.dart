import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';

class ShortcutIcon extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback function;
  final String description;
  const ShortcutIcon({
    super.key,
    required this.context,
    required this.function,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: BoxLayout(
        height: 70,
        padding: const EdgeInsets.all(10),
        bgColor: Theme.of(context).cardColor,
        borderRadius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.GREY_TEXT,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
