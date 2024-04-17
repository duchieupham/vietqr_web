import 'package:flutter/material.dart';

Future<void> showPopup(
    BuildContext context, List<PopupMenuEntry<int>> items) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final Offset buttonPosition = button.localToGlobal(Offset.zero);
  final double buttonWidth = button.size.width;
  await showMenu(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    context: context,
    position: RelativeRect.fromLTRB(
      buttonPosition.dx + buttonWidth,
      buttonPosition.dy,
      buttonPosition.dx + buttonWidth * 2,
      buttonPosition.dy + button.size.height,
    ),
    items: items,
  );
}
