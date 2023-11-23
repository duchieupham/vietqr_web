import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/page/bill.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../frame/merchant_frame.dart';

class MerchantBill extends StatefulWidget {
  const MerchantBill({super.key});

  @override
  State<MerchantBill> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantBill> {
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
    merchantBloc.add(GetMerchantFeeEvent(
        customerSyncId: Session.instance.accountIsMerchantDTO.customerSyncId,
        year: DateTime.now().year.toString(),
        status: 0,
        isLoadingPage: true));
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return MerchantFrame(
      menu: MenuLeft(
        currentType: MenuHomeType.MERCHANT,
        subMenuMerchant: [
          ItemMenuHome(
            title: 'Thống kê giao dịch',
            isSelect: false,
            onTap: () {
              context.go('/merchant/transaction');
            },
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
            isSelect: true,
            onTap: () {},
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
                      isSelect: false,
                      onTap: () {
                        context.go('/merchant/transaction');
                      },
                    ),
                    ItemMenuTop(
                      title: 'Báo cáo tổng hợp',
                      isSelect: false,
                      onTap: () {
                        context.go('/merchant/report');
                      },
                    ),
                    ItemMenuTop(
                      title: 'Phí dịch vụ',
                      isSelect: false,
                      onTap: () {
                        context.go('/merchant/fee');
                      },
                    ),
                    ItemMenuTop(
                      title: 'Hóa đơn',
                      isSelect: true,
                      onTap: () {},
                    ),
                    ItemMenuTop(
                      title: 'Bảng giá',
                      isSelect: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const Expanded(child: Bill())
            ],
          ),
        ),
      ),
    );
  }
}
