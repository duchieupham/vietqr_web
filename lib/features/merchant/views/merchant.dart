import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/page/list_transaction.dart';
import 'package:VietQR/features/merchant/page/sale_report.dart';
import 'package:VietQR/features/merchant/provider/merchant_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    Map<String, dynamic> param = {};
    param['merchantId'] = Session.instance.accountIsMerchantDTO.customerSyncId;
    param['type'] = 9;
    param['value'] = '';
    param['from'] = '0';
    param['to'] = '0';
    param['offset'] = 0;
    merchantBloc = MerchantBloc()
      ..add(
          GetListTransactionByMerchantEvent(param: param, isLoadingPage: true));
    super.initState();
  }

  changePage(SubMenuType type) {
    setState(() {
      currentType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      child: ChangeNotifierProvider<MerchantProvider>(
        create: (context) => MerchantProvider(),
        child: BlocProvider<MerchantBloc>(
          create: (context) => merchantBloc,
          child: SizedBox(
            width: width,
            height: height - 60,
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: height - 6,
                  decoration: BoxDecoration(
                    color: DefaultTheme.BLUE_TEXT.withOpacity(0.2),
                  ),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ItemMenuHome(
                        title: 'Danh sách giao dịch',
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
                      ItemMenuHome(
                        title: 'Báo cáo doanh thu',
                        isSelect: currentType == SubMenuType.SALE_REPORT,
                        onTap: () {
                          changePage(SubMenuType.SALE_REPORT);
                          nowMonth =
                              TimeUtils.instance.getFormatMonth(DateTime.now());
                          merchantBloc.add(GetMerchantFeeEvent(
                              customerSyncId: Session
                                  .instance.accountIsMerchantDTO.customerSyncId,
                              month: nowMonth,
                              isLoadingPage: true));
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: [
                  ListTransaction(
                    merchantBloc: merchantBloc,
                  ),
                  SaleReport(
                    merchantBloc: merchantBloc,
                  )
                ][currentType == SubMenuType.LIST_TRANSACTION ? 0 : 1])
              ],
            ),
          ),
        ),
      ),
    );
  }
}