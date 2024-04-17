import 'package:flutter/material.dart';

Future<void> showPopup(BuildContext context, List<PopupMenuEntry<int>> items,
    RelativeRect rect) async {
  await showMenu(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    context: context,
    position: rect,
    // position: RelativeRect.fromLTRB(
    //   buttonPosition.dx + buttonWidth,
    //   buttonPosition.dy,
    //   buttonPosition.dx + buttonWidth * 2,
    //   buttonPosition.dy + button.size.height,
    // ),
    items: items,
  );
}
