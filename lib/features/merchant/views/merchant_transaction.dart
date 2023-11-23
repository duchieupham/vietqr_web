import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/page/list_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../frame/merchant_frame.dart';

class MerchantTransaction extends StatefulWidget {
  const MerchantTransaction({super.key});

  @override
  State<MerchantTransaction> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantTransaction> {
  final ScrollController scrollController = ScrollController();

  int offset = 0;
  SubMenuType currentType = SubMenuType.LIST_TRANSACTION;
  bool isEnded = false;
  String nowMonth = '';

  late MerchantBloc merchantBloc;

  @override
  void initState() {
    super.initState();
    merchantBloc = MerchantBloc();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return MerchantFrame(
      menu: MenuLeft(
        currentType: MenuHomeType.MERCHANT,
        subMenuMerchant: [
          ItemMenuHome(
            title: 'Thống kê giao dịch',
            isSelect: true,
            onTap: () {},
          ),
          ItemMenuHome(
            title: 'Báo cáo tổng hợp',
            isSelect: false,
            onTap: () {
              context.go('/merchant/report');
            },
          ),
          ItemMenuHome(
            title: 'Phí dịch vụ',
            isSelect: false,
            onTap: () {
              context.go('/merchant/fee');
            },
          ),
          ItemMenuHome(
            title: 'Hóa đơn',
            isSelect: false,
            onTap: () {
              context.go('/merchant/bill');
            },
          ),
          ItemMenuHome(
            title: 'Bảng giá',
            isSelect: false,
            onTap: () {},
          ),
        ],
      ),
      table: BlocProvider<MerchantBloc>(
        create: (context) => merchantBloc,
        child: SizedBox(
          width: width,
          height: height - 60,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT.withOpacity(0.1),
                ),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ItemMenuTop(
                      title: 'Thống kê giao dịch',
                      isSelect: currentType == SubMenuType.LIST_TRANSACTION,
                      onTap: () {},
                    ),
                    ItemMenuTop(
                      title: 'Báo cáo tổng hợp',
                      isSelect: currentType == SubMenuType.SYNTHESIS_REPORT,
                      onTap: () {
                        context.go('/merchant/report');
                      },
                    ),
                    ItemMenuTop(
                      title: 'Phí dịch vụ',
                      isSelect: currentType == SubMenuType.SERVICE_FEE,
                      onTap: () {
                        context.go('/merchant/fee');
                      },
                    ),
                    ItemMenuTop(
                      title: 'Hóa đơn',
                      isSelect: currentType == SubMenuType.BILL,
                      onTap: () {
                        context.go('/merchant/bill');
                      },
                    ),
                    ItemMenuTop(
                      title: 'Bảng giá',
                      isSelect: currentType == SubMenuType.OTHER,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const Expanded(child: ListTransaction())
            ],
          ),
        ),
      ),
    );
  }
}
