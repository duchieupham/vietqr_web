import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/features/invoice_manage/bloc/invoice_bloc.dart';
import 'package:VietQR/features/invoice_manage/event/invoice_events.dart';
import 'package:VietQR/features/invoice_manage/state/invoice_states.dart';
import 'package:VietQR/features/invoice_manage/widgets/item_fee_package_invoice.dart';
import 'package:VietQR/features/invoice_manage/widgets/item_right_fee_package_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/popup_bank_select_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/title_invoice_recharge_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_pick_date.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/fee_package_invoice.dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InvoiceRechargeScreen extends StatelessWidget {
  const InvoiceRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (context) => InvoiceBloc(context),
      child: const _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  late InvoiceBloc _bloc;
  late InvoiceProvider _provider;

  final controller1 = ScrollController();
  final controller2 = ScrollController();

  int? type = 9;
  String? selectBankId = '';
  DateTime? selectDate;
  List<FeePackageInvoiceDTO> listInvoice = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<InvoiceProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData({bool isRefresh = false}) async {
    if (isRefresh) {}
    selectDate = getMonth();
    _provider.selectBankAccount(null);
    _bloc.add(GetListBankAccountEvent());
    _bloc.add(GetListPackageInvoiceFeeEvent(
        bankId: '',
        time: selectDate != null
            ? DateFormat('yyyy-MM').format(selectDate!)
            : DateFormat('yyyy-MM').format(getMonth())));
  }

  void onPopupBankSelect() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return PopupBankSelectWidget(
          onConfirm: (dto) {
            setState(() {
              selectBankId = dto.bankId;
            });
          },
        );
      },
    );
  }

  void _onPickMonth(DateTime dateTime) async {
    DateTime? result = await showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              dateTime: dateTime,
            ),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectDate = result;
      });
      // _bloc.add(GetInvoiceList(
      //     status: _provider.invoiceStatus.id,
      //     bankId: selectBankId ?? '',
      //     time: DateFormat('yyyy-MM').format(result),
      //     filterBy: 1,
      //     page: 1));
    }
  }

  DateTime getMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  DateTime getPreviousMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 1;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (context, state) {
        if (state.request == InvoiceType.GET_LIST_FEE &&
            state.status == BlocStatus.SUCCESS) {
          listInvoice = state.listFeePackageInvoice!;
        }
        if (state.request == InvoiceType.GET_LIST_FEE &&
            state.status == BlocStatus.NONE) {
          listInvoice = [];
        }
        if (state.request == InvoiceType.GET_BANKS &&
            state.status == BlocStatus.SUCCESS) {
          _provider.setListBank(state.listBank!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.BLUE_BGR,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerWidget(),
                const Divider(
                  color: AppColor.GREY_DADADA,
                ),
                _buildFilter(),
                _buildListInvoice(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          const Text(
            "Tìm kiếm thông tin hoá đơn ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          _filterItem(),
          const SizedBox(height: 20),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          const SizedBox(height: 20),
          const Text(
            "Danh sách hoá đơn",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildListInvoice(InvoiceStates state) {
    switch (state.status) {
      case BlocStatus.LOADING:
        return Expanded(
            child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: const Center(
            child: Text('Đang tải...'),
          ),
        ));
      case BlocStatus.NONE:
        return Expanded(
            child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: const Center(
            child: Text('Trống...'),
          ),
        ));
      case BlocStatus.SUCCESS:
        return Expanded(
          child: listInvoice.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 220,
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Scrollbar(
                            controller: controller1,
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: SingleChildScrollView(
                                controller: controller1,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: 1590,
                                  child: Column(
                                    children: [
                                      const TitleItemInvoiceRechargeWidget(),
                                      // if (listInvoice.isNotEmpty)
                                      ...listInvoice
                                          .asMap()
                                          .map(
                                            (index, x) {
                                              return MapEntry(
                                                  index,
                                                  ItemFeePackage(
                                                    index: index + 1,
                                                    dto: x,
                                                  ));
                                            },
                                          )
                                          .values
                                          .toList()

                                      // if (state.request == InvoiceType.GET_INVOICE_LIST &&
                                      //     state.status == BlocStatus.NONE)
                                      //   const Expanded(
                                      //       child: Center(child: Text('Trống..')))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 1590,
                            child: Row(
                              children: [
                                const Expanded(child: SizedBox()),
                                SingleChildScrollView(
                                  controller: controller2,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.GREY_BORDER
                                                  .withOpacity(0.8),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 0)),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: AppColor.BLUE_TEXT
                                                    .withOpacity(0.3)),
                                            child: Row(
                                              children: [
                                                Container(
                                                    height: 50,
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColor
                                                                .GREY_TEXT
                                                                .withOpacity(
                                                                    0.3))),
                                                    child: const Text(
                                                      'Tổng phí GD (VND)',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColor.BLACK,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Container(
                                                    height: 50,
                                                    width: 80,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColor
                                                                .GREY_TEXT
                                                                .withOpacity(
                                                                    0.3))),
                                                    child: const Text(
                                                      'Thao tác',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColor.BLACK,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          // if (listInvoice.isNotEmpty)
                                          ...listInvoice
                                              .map(
                                                (e) =>
                                                    ItemRightFeePackageWidget(
                                                  dto: e,
                                                  onShowExcel: () {},
                                                ),
                                              )
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: const Center(
                    child: Text('Trống...'),
                  ),
                ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _filterItem() {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tìm kiếm theo",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  width: type == 9 ? 180 : 450,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: type,
                          underline: const SizedBox.shrink(),
                          icon: const RotatedBox(
                            quarterTurns: 5,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem<int>(
                                value: 9,
                                child: Text(
                                  "Tất cả TK",
                                )),
                            DropdownMenuItem<int>(
                                value: 2,
                                child: Text(
                                  "TK ngân hàng",
                                )),
                          ],
                          onChanged: (value) {
                            if (value == 9) {
                              selectBankId = '';
                            }
                            type = value;
                            updateState();
                          },
                        ),
                      ),
                      if (type == 2)
                        Expanded(
                          child: InkWell(
                            onTap: onPopupBankSelect,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                const SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: AppColor.GREY_DADADA,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  provider.selectBank != null
                                      ? '${provider.selectBank!.bankShortName} - ${provider.selectBank!.bankAccount}'
                                      : 'Chọn tài khoản ngân hàng',
                                  style: const TextStyle(fontSize: 15),
                                )),
                                const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thời gian",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 60,
                        child: Center(
                          child: Text('Tháng'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          thickness: 1,
                          color: AppColor.GREY_DADADA,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _onPickMonth(getMonth());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (selectDate == null
                                      ? 'Tất cả'
                                      : '${selectDate?.month}/${selectDate?.year}'),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const Icon(Icons.calendar_month_outlined)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thời gian",
                  style: TextStyle(fontSize: 15, color: AppColor.WHITE),
                ),
                const SizedBox(height: 10),
                InkWell(
                  // onTap: () {
                  // _bloc.add(GetInvoiceList(
                  //     status: _provider.invoiceStatus.id,
                  //     bankId: selectBankId ?? '',
                  //     time: selectDate != null
                  //         ? DateFormat('yyyy-MM').format(selectDate!)
                  //         : '',
                  //     filterBy: 1,
                  //     page: 1));
                  // },
                  onTap: () {
                    _bloc.add(GetListPackageInvoiceFeeEvent(
                      bankId: selectBankId ?? '',
                      time: selectDate != null
                          ? DateFormat('yyyy-MM').format(selectDate!)
                          : '',
                    ));
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 15,
                          color: AppColor.WHITE,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Tìm kiếm",
                          style: TextStyle(color: AppColor.WHITE, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      // width: MediaQuery.of(context).size.width,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "   /   ",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Thu phí dịch vụ",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  void updateState() {
    setState(() {});
  }
}
