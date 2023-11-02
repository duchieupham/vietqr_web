import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/page/list_transaction.dart';
import 'package:VietQR/features/merchant/page/sale_report.dart';
import 'package:VietQR/features/merchant/page/synthesis_repor.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../frame/merchant_frame.dart';

class MerchantView extends StatefulWidget {
  const MerchantView({super.key});

  @override
  State<MerchantView> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantView> {
  late MerchantBloc merchantBloc;

  final ScrollController scrollController = ScrollController();

  int offset = 0;
  SubMenuType currentType = SubMenuType.LIST_TRANSACTION;
  bool isEnded = false;
  String nowMonth = '';
  @override
  void initState() {
    merchantBloc = MerchantBloc();

    super.initState();
  }

  changePage(SubMenuType type) {
    setState(() {
      currentType = type;
    });
  }

  int getPage(SubMenuType currentType) {
    switch (currentType) {
      case SubMenuType.LIST_TRANSACTION:
        return 0;
      case SubMenuType.SYNTHESIS_REPORT:
        return 1;
      case SubMenuType.SERVICE_FEE:
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return MerchantFrame(
      menu: const MenuLeft(
        currentType: MenuHomeType.MERCHANT,
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
                      onTap: () {
                        changePage(SubMenuType.LIST_TRANSACTION);
                        Map<String, dynamic> param = {};
                        param['merchantId'] = Session
                            .instance.accountIsMerchantDTO.customerSyncId;
                        param['type'] = 9;
                        param['value'] = '';
                        param['from'] = '0';
                        param['to'] = '0';
                        param['offset'] = 0;
                        merchantBloc.add(GetListTransactionByMerchantEvent(
                            param: param, isLoadingPage: true));
                      },
                    ),
                    ItemMenuTop(
                      title: 'Báo cáo tổng hợp',
                      isSelect: currentType == SubMenuType.SYNTHESIS_REPORT,
                      onTap: () {
                        changePage(SubMenuType.SYNTHESIS_REPORT);
                        merchantBloc.add(GetSynthesisReportEvent(
                            customerSyncId: Session
                                .instance.accountIsMerchantDTO.customerSyncId,
                            type: 0,
                            time: DateTime.now().year.toString(),
                            isLoadingPage: true));
                      },
                    ),
                    ItemMenuTop(
                      title: 'Phí dịch vụ',
                      isSelect: currentType == SubMenuType.SERVICE_FEE,
                      onTap: () {
                        changePage(SubMenuType.SERVICE_FEE);
                        if (currentType == SubMenuType.SERVICE_FEE) {
                          nowMonth =
                              TimeUtils.instance.getFormatMonth(DateTime.now());
                          merchantBloc.add(GetMerchantFeeEvent(
                              customerSyncId: Session
                                  .instance.accountIsMerchantDTO.customerSyncId,
                              month: nowMonth,
                              isLoadingPage: true));
                        }
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
              Expanded(
                  child: [
                ListTransaction(
                  merchantBloc: merchantBloc,
                ),
                SynthesisReport(
                  merchantBloc: merchantBloc,
                ),
                ServiceFee(
                  merchantBloc: merchantBloc,
                ),
              ][getPage(currentType)])
            ],
          ),
        ),
      ),
    );
  }
}
