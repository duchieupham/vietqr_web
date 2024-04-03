import 'dart:async';
import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:flutter/material.dart';

import '../../../layouts/sldie_fade_animation.dart';

class ItemMenuHome extends StatefulWidget {
  final String iconId;
  final String title;
  final Function onTap;
  final bool isSelect, isLogout, enableDropDownList, enableMenuCard, isFirst;
  final String? pathImage;
  final List<Widget> listItemDrop;
  final bool isDropDownItem;
  final double titleSize;
  final bool isOnlyIcon, isDefaultColor;
  final EdgeInsets paddingIcon;
  final bool bold;

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
      this.isDefaultColor = false,
      this.isFirst = false,
      this.bold = false,
      this.paddingIcon = EdgeInsets.zero})
      : super(key: key);

  @override
  State<ItemMenuHome> createState() => _ItemMenuHomeState();
}

class _ItemMenuHomeState extends State<ItemMenuHome> {
  double heightItem = 45;
  bool openListDropDown = true;
  bool amIHovering = false;
  bool openMenuCard = true;
  Offset exitFrom = const Offset(0, 0);
  double _currentHeight = 0.0;

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
      return AppColor.BLUE_BGR;
    } else if (amIHovering) {
      return AppColor.GREY_BUTTON;
    }
    return Colors.transparent;
  }

  void _startAnimation() {
    Timer.periodic(const Duration(microseconds: 20), (timer) {
      setState(() {
        _currentHeight += 15;
        if (_currentHeight >= getHeightDropDownList()) {
          _currentHeight = getHeightDropDownList();
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnlyIcon) {
      if (widget.pathImage != null && widget.pathImage != '') {
        return Tooltip(
          message: widget.title,
          textStyle:
              TextStyle(fontWeight: widget.bold ? FontWeight.bold : null),
          child: Image.asset(
            widget.pathImage!,
            height: 35,
            width: 35,
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
            textStyle:
                TextStyle(fontWeight: widget.bold ? FontWeight.bold : null),
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
                color: widget.isDefaultColor
                    ? null
                    : widget.isSelect
                        ? AppColor.BLUE_TEXT
                        : AppColor.BLACK,
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

          // if (widget.enableDropDownList) {
          //   onOpenDropDownList();
          // }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: heightItem,
              width: double.infinity,
              // alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColor.BLUE_BGR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image:
                            ImageUtils.instance.getImageNetWork(widget.iconId),
                        color: AppColor.BLACK,
                        height: 30,
                      ),
                      const SizedBox(width: 19),
                      // const Spacer(),
                      if (widget.isLogout)
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: widget.titleSize,
                            color: AppColor.RED_TEXT,
                            fontWeight: widget.bold ? FontWeight.bold : null,
                          ),
                        )
                      else
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: widget.titleSize,
                            fontWeight: widget.bold ? FontWeight.bold : null,
                            // color: widget.isSelect
                            //     ? AppColor.BLUE_TEXT
                            //     : AppColor.BLACK,
                            color: AppColor.BLACK,
                          ),
                        ),
                    ],
                  ),

                  // const Spacer(),
                  if (widget.enableMenuCard)
                    Expanded(
                      child: Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                            color: AppColor.BLUE_BGR,
                            borderRadius: BorderRadius.circular(15)),
                        child: Transform.rotate(
                          angle: !openMenuCard ? -math.pi / 2 : math.pi / 2,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  else if (widget.enableDropDownList)
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: AppColor.BLUE_BGR,
                            borderRadius: BorderRadius.circular(15)),
                        child: Transform.rotate(
                          angle: !openListDropDown ? math.pi : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
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
      duration: const Duration(microseconds: 20),
      padding: const EdgeInsets.only(left: 40, right: 40),
      // margin: const EdgeInsets.only(left: 20),
      curve: Curves.easeInOut,
      height: _currentHeight,
      width: double.infinity,
      child: ListView(
        children: widget.listItemDrop,
      ),
    );
  }

  // Widget _dropDownList() {
  //   return SlideFadeTransition(
  //     offset: -0.2,
  //     delayStart: const Duration(microseconds: 10),
  //     animationDuration: const Duration(milliseconds: 400),
  //     direction: Direction.vertical,
  //     child: Container(
  //       padding: const EdgeInsets.only(left: 40, right: 40),
  //       // margin: const EdgeInsets.only(left: 20),
  //       height: getHeightDropDownList(),
  //       width: double.infinity,
  //       child: ListView(
  //         children: widget.listItemDrop,
  //       ),
  //     ),
  //   );
  // }
}
