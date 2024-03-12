// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/enterprise/page/views/store_detail_view.dart';
import 'package:VietQR/features/enterprise/page/views/store_view.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum StoreType { STORE, DETAIL, OVERVIEW }

class StoreScreen extends StatefulWidget {
  final StoreType type;
  final String terminalId;
  final String terminalName;

  const StoreScreen(
      {super.key,
      required this.type,
      this.terminalId = '',
      this.terminalName = ''});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  double get width => MediaQuery.of(context).size.width;

  bool get isMobile => (PlatformUtils.instance.resizeWhen(width, 850));

  @override
  Widget build(BuildContext context) {
    return Material(
      child: (!isMobile)
          ? const WebMobileBlankWidget()
          : Container(
              color: AppColor.GREY_BG,
              child: Column(
                children: [
                  const HeaderWidget(),
                  Expanded(
                    child: Row(
                      children: [
                        MenuLeft(
                          currentType: MenuHomeType.ENTERPRISE,
                          subMenuEnterprise: [
                            ItemMenuHome(
                              title: 'Cửa hàng',
                              isSelect: true,
                              onTap: () {
                                context.go('/enterprise/store');
                              },
                            ),
                          ],
                        ),
                        if (widget.type == StoreType.STORE)
                          const Expanded(child: StoreView()),
                        if (widget.type == StoreType.DETAIL)
                          Expanded(
                            child:
                                StoreDetailView(terminalId: widget.terminalId),
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
