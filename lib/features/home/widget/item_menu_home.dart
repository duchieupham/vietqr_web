import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:flutter/material.dart';

class ItemMenuHome extends StatefulWidget {
  final String iconId;
  final String title;
  final Function onTap;
  final bool isSelect, isLogout, enableDropDownList, enableMenuCard;
  final String? pathImage;
  final List<Widget> listItemDrop;
  final bool isDropDownItem;
  final double titleSize;
  final bool isOnlyIcon;
  final EdgeInsets paddingIcon;
  const ItemMenuHome(
      {Key? key,
      required this.title,
      required this.onTap,
      this.iconId = '',
      this.pathImage,
      this.isSelect = false,
      this.isLogout = false,
      this.enableDropDownList = false,
      this.listItemDrop = const [],
      this.isDropDownItem = false,
      this.titleSize = 13,
      this.enableMenuCard = false,
      this.isOnlyIcon = false,
      this.paddingIcon = EdgeInsets.zero})
      : super(key: key);

  @override
  State<ItemMenuHome> createState() => _ItemMenuHomeState();
}

class _ItemMenuHomeState extends State<ItemMenuHome> {
  double heightItem = 45;
  bool openListDropDown = false;
  bool amIHovering = false;
  bool openMenuCard = true;
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
      return AppColor.BLUE_TEXT.withOpacity(0.30);
    } else if (amIHovering) {
      return AppColor.GREY_BUTTON;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnlyIcon) {
      if (widget.pathImage != null && widget.pathImage != '') {
        return Tooltip(
          message: widget.title,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            color: widget.isSelect
                ? AppColor.BLUE_TEXT.withOpacity(0.3)
                : Colors.transparent,
            width: 40,
            height: 40,
            child: Image.asset(
              widget.pathImage!,
              height: 15,
              width: 25,
            ),
          ),
        );
      }

      if (widget.iconId.isNotEmpty) {
        return InkWell(
          onTap: () {
            widget.onTap();
          },
          child: Tooltip(
            message: widget.title,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: widget.paddingIcon,
              color: widget.isSelect
                  ? AppColor.ITEM_MENU_SELECTED
                  : Colors.transparent,
              width: 40,
              height: 40,
              child: Image(
                image: ImageUtils.instance.getImageNetWork(widget.iconId),
                color: widget.isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK,
                height: 40,
              ),
            ),
          ),
        );
      }
    }
    return MouseRegion(
      onEnter: (PointerEvent details) => setState(() => amIHovering = true),
      onExit: (PointerEvent details) => setState(() {
        amIHovering = false;
        exitFrom = details.localPosition;
      }),
      child: InkWell(
        onTap: () {
          widget.onTap();
          if (widget.enableMenuCard) {
            setState(() {
              openMenuCard = !openMenuCard;
            });
          }
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
                  if (widget.isLogout)
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.titleSize, color: AppColor.RED_TEXT),
                    )
                  else
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.titleSize,
                          color: widget.isSelect
                              ? AppColor.BLUE_TEXT
                              : AppColor.BLACK),
                    ),
                  const Spacer(),
                  if (widget.enableMenuCard)
                    Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColor.CARD_CODE_BG,
                          borderRadius: BorderRadius.circular(15)),
                      child: Transform.rotate(
                        angle: !openMenuCard ? -math.pi / 2 : math.pi / 2,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 15,
                        ),
                      ),
                    )
                  else if (widget.enableDropDownList)
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: AppColor.CARD_CODE_BG,
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
      margin: const EdgeInsets.only(left: 20),
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
