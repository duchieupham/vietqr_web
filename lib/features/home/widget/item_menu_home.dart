import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ItemMenuHome extends StatefulWidget {
  final String pathIcon;
  final String title;
  final Function onTap;
  final bool isSelect, isLogout, enableDropDownList;
  final String? pathImage;
  final List<Widget> listItemDrop;
  final bool isDropDownItem;
  final double titleSize;
  const ItemMenuHome({
    Key? key,
    required this.title,
    required this.onTap,
    this.pathIcon = '',
    this.pathImage,
    this.isSelect = false,
    this.isLogout = false,
    this.enableDropDownList = false,
    this.listItemDrop = const [],
    this.isDropDownItem = false,
    this.titleSize = 13,
  }) : super(key: key);

  @override
  State<ItemMenuHome> createState() => _ItemMenuHomeState();
}

class _ItemMenuHomeState extends State<ItemMenuHome> {
  double heightItem = 40;
  bool openListDropDown = false;
  bool amIHovering = false;

  Offset exitFrom = const Offset(0, 0);

  onOpenDropDownList() {
    if (openListDropDown) {
      setState(() {
        openListDropDown = !openListDropDown;
      });
    } else {
      setState(() {
        openListDropDown = true;
      });
    }
  }

  double getHeightDropDownList() {
    if (openListDropDown) {
      return widget.listItemDrop.length * heightItem;
    }
    return 0;
  }

  getBgItem() {
    if (widget.isSelect) {
      return DefaultTheme.ITEM_MENU_SELECTED;
    } else if (amIHovering) {
      return DefaultTheme.GREY_BUTTON;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent details) => setState(() => amIHovering = true),
      onExit: (PointerEvent details) => setState(() {
        amIHovering = false;

        exitFrom = details.localPosition;
      }),
      child: InkWell(
        onTap: () {
          widget.onTap();
          if (widget.enableDropDownList) {
            onOpenDropDownList();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: heightItem,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: getBgItem(),
              child: Row(
                children: [
                  if (widget.pathImage != null && widget.pathImage != '') ...[
                    Image.asset(
                      widget.pathImage!,
                      height: 15,
                      fit: BoxFit.fitHeight,
                    ),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                  if (widget.pathIcon.isNotEmpty) ...[
                    Image.asset(
                      widget.pathIcon,
                      height: 30,
                    ),
                    SizedBox(
                      width: widget.isDropDownItem ? 8 : 16,
                    )
                  ],
                  if (widget.isLogout)
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.titleSize,
                          color: DefaultTheme.RED_TEXT),
                    )
                  else
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: widget.titleSize),
                    ),
                  const Spacer(),
                  if (widget.enableDropDownList)
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: DefaultTheme.CARD_CODE_BG,
                          borderRadius: BorderRadius.circular(15)),
                      child: Transform.rotate(
                        angle: openListDropDown ? math.pi : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 15,
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (widget.enableDropDownList) _dropDownList(),
          ],
        ),
      ),
    );
  }

  Widget _dropDownList() {
    return AnimatedContainer(
      margin: const EdgeInsets.only(left: 40),
      height: getHeightDropDownList(),
      width: double.infinity,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: ListView(
        children: widget.listItemDrop,
      ),
    );
  }
}
