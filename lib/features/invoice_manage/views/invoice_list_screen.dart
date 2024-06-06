import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/features/invoice_manage/bloc/invoice_bloc.dart';
import 'package:VietQR/features/invoice_manage/event/invoice_events.dart';
import 'package:VietQR/features/invoice_manage/state/invoice_states.dart';
import 'package:VietQR/features/invoice_manage/widgets/item_right_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/popup_bank_select_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/popup_excel_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/popup_payment_request_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/popup_qr_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/title_invoice_widget.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:VietQR/models/invoice_detail_qr_dto.dart';
import 'package:VietQR/models/invoice_excel_dto.dart';
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:VietQR/models/metadata_dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:VietQR/services/shared_references/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/custom_scroll.dart';
import '../../../commons/widgets/dot_dash_widget.dart';
import '../../../layouts/box_layout.dart';
import '../../../main.dart';
import '../../transaction/widgets/dialog_pick_date.dart';
import '../widgets/item_invoice_widget.dart';
import 'invoice_detail_screen.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

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
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final controller1 = ScrollController();
  final controller2 = ScrollController();

  late InvoiceBloc _bloc;
  late InvoiceProvider _provider;

  // String? invoiceId;
  String? selectBankId;
  int? type = 9;
  DateTime? selectDate;
  bool isFirstSelected = true;

  List<InvoiceFeeDTO> listInvoice = [];
  InvoiceFeeDTO? selectInvoiceFee;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<InvoiceProvider>(context, listen: false);
    // initData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData({bool isRefresh = false}) async {
    if (isRefresh) {}
    _provider.selectBankAccount(null);
    _bloc.add(GetListBankAccountEvent());
    _bloc.add(GetInvoiceList(
        status: _provider.invoiceStatus.id, bankId: '', filterBy: 1, page: 1));
  }

  void onShowPopup(
    InvoiceFeeDTO dto,
    InvoiceDetailDTO detail,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => PopupPaymentRequestWidget(
        invoiceDetailDTO: detail,
        bloc: _bloc,
        dto: dto,
      ),
    );
  }

  void onShowPopupExcel(
    InvoiceExcelDTO excel,
  ) async {
    if (excel != null) {
      await showDialog(
        context: context,
        builder: (context) => PopupExcelInvoice(
          bloc: _bloc,
          dto: excel,
        ),
      );
    }
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

  void onShowQRPopup(InvoiceDetailQrDTO dto) async {
    await setDialog(true).then(
      (value) async => await showDialog(
        context: context,
        builder: (context) => PopupQrCodeInvoice(
          dto: dto,
          showButton: true,
          onPop: (id) {
            _provider.onPageChange(PageInvoice.DETAIL,
                invoiceId: dto.invoiceId);
          },
          invoiceId: dto.invoiceId,
        ),
      ).then(
        (value) async {
          await setDialog(false);
          _provider.isCloseDialog();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (BuildContext context, InvoiceStates state) {
        if (state.request == InvoiceType.GET_BANKS &&
            state.status == BlocStatus.SUCCESS) {
          _provider.setListBank(state.listBank!);
        }

        if (state.request == InvoiceType.GET_INVOICE_LIST &&
            state.status == BlocStatus.SUCCESS) {
          listInvoice = state.listInvoice!;
        }

        if (state.request == InvoiceType.GET_INVOICE_LIST &&
            state.status == BlocStatus.NONE) {
          listInvoice = [];
        }

        if (state.request == InvoiceType.INVOICE_EXCEL &&
            state.status == BlocStatus.SUCCESS) {
          if (state.invoiceExcelDTO != null) {
            onShowPopupExcel(state.invoiceExcelDTO!);
          }
        }

        if (state.request == InvoiceType.INVOICE_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          if (state.isShow == true) {
            _provider.setListSelectItem(
                state.invoiceDetailDTO!.invoiceItemDetailDTOS);
            onShowPopup(
              selectInvoiceFee!,
              state.invoiceDetailDTO!,
            );
          }
        }
        if (state.request == InvoiceType.REQUEST_PAYMENT &&
            state.status == BlocStatus.SUCCESS) {
          if (state.isShow == true) {
            onShowQRPopup(state.invoiceDetailQrDTO!);
          }
        }
      },
      builder: (context, state) {
        return Consumer<InvoiceProvider>(
          builder: (context, provider, child) {
            if (provider.closeDialog) {
              Navigator.of(context).pop();
              // provider.makeReload(true);
            }
            if (provider.isReload) {
              _bloc.add(GetInvoiceList(
                  status: _provider.invoiceStatus.id,
                  bankId: selectBankId ?? '',
                  time: selectDate != null
                      ? DateFormat('yyyy-MM').format(selectDate!)
                      : '',
                  filterBy: 1,
                  page: 1));
              provider.makeReload(false);
            }

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
                    if (provider.pageInvoice == PageInvoice.LIST) ...[
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Tìm kiếm thông tin hoá đơn ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 30),

                                ...provider.statusList
                                    .map(
                                      (e) => _buildOption(e),
                                    )
                                    .toList(),

                                // _buildOption("Chưa thanh toán", isFirstSelected),
                                // const SizedBox(width: 20),
                                // _buildOption("Đã thanh toán", !isFirstSelected),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _filterWidget(),
                            const SizedBox(height: 20),
                            const MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Danh sách hoá đơn",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      _buildListInvoice(state),
                      const SizedBox(height: 10),
                      _pagingWidget(state),
                      const SizedBox(height: 10),
                    ] else if (provider.pageInvoice == PageInvoice.DETAIL)
                      Expanded(
                        child: InvoiceDetailScreen(
                          bloc: _bloc,
                          // invoiceId: invoiceId!,
                          callback: () {
                            provider.onPageChange(PageInvoice.LIST);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOption(InvoiceStatus status) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              provider.selectStatus(status);
              _bloc.add(GetInvoiceList(
                  status: _provider.invoiceStatus.id,
                  bankId: selectBankId ?? '',
                  time: selectDate != null
                      ? DateFormat('yyyy-MM').format(selectDate!)
                      : '',
                  filterBy: 1,
                  page: 1));
            },
            child: Container(
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                color: provider.invoiceStatus == status
                    ? AppColor.BLUE_TEXT.withOpacity(0.3)
                    : AppColor.WHITE,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                status.name,
                style: TextStyle(
                  color: provider.invoiceStatus == status
                      ? AppColor.BLUE_TEXT
                      : AppColor.BLACK,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListInvoice(InvoiceStates state) {
    if (state.request == InvoiceType.GET_INVOICE_LIST &&
        state.status == BlocStatus.LOADING) {
      return Expanded(
          child: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: const Center(
          child: Text('Đang tải...'),
        ),
      ));
    }

    if (listInvoice.isEmpty) {
      return Expanded(
          child: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: const Center(
          child: Text('Không có hóa đơn'),
        ),
      ));
    }

    return Expanded(
      child: Padding(
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
                          width: 1570,
                          child: Column(
                            children: [
                              const TitleItemInvoiceWidget(),
                              if (listInvoice!.isNotEmpty ||
                                  listInvoice != null)
                                ...listInvoice!
                                    .asMap()
                                    .map(
                                      (index, x) {
                                        return MapEntry(
                                            index,
                                            ItemInvoiceWidget(
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
                    width: 1570,
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
                                      color:
                                          AppColor.GREY_BORDER.withOpacity(0.8),
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
                                            width: 120,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3))),
                                            child: const Text(
                                              'Trạng thái',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.BLACK,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            height: 50,
                                            width: 140,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3))),
                                            child: const Text(
                                              'Thao tác',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.BLACK,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  if (listInvoice!.isNotEmpty ||
                                      listInvoice != null)
                                    ...listInvoice!
                                        .map(
                                          (e) => ItemRightWidget(
                                            dto: e,
                                            onShowExcel: () {
                                              setState(() {
                                                selectInvoiceFee = e;
                                              });
                                              _bloc.add(GetInvoiceExcel(
                                                  e.invoiceId!));
                                            },
                                            onShowQR: () {
                                              setState(() {
                                                selectInvoiceFee = e;
                                              });
                                              _bloc.add(GetInvoiceDetail(
                                                  e.invoiceId!, true));
                                            },
                                            onShowDetail: () {
                                              _provider.onPageChange(
                                                  PageInvoice.DETAIL,
                                                  invoiceId: e.invoiceId);
                                            },
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
          )),
    );
  }

  Widget _filterWidget() {
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
                  width: type == 9 ? 210 : 500,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 180,
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
                                  "Tất cả (mặc định)",
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
                            setState(() {});
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
                  onTap: () {
                    _bloc.add(GetInvoiceList(
                        status: _provider.invoiceStatus.id,
                        bankId: selectBankId ?? '',
                        time: selectDate != null
                            ? DateFormat('yyyy-MM').format(selectDate!)
                            : '',
                        filterBy: 1,
                        page: 1));
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
            "Danh sách hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
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
      _bloc.add(GetInvoiceList(
          status: _provider.invoiceStatus.id,
          bankId: selectBankId ?? '',
          time: DateFormat('yyyy-MM').format(result),
          filterBy: 1,
          page: 1));
    }
    // else {
    //   selectDate = _model.getMonth();
    // }
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

  Widget _pagingWidget(InvoiceStates state) {
    MetaDataDTO? paging;
    bool isPaging = false;

    if (state.status == BlocStatus.LOADING ||
        state.status == BlocStatus.NONE ||
        state.status == BlocStatus.ERROR) {
      return const SizedBox.shrink();
    }
    if (state.request == InvoiceType.GET_INVOICE_LIST &&
        state.status == BlocStatus.SUCCESS) {
      paging = state.metaDataDTO!;
      if (paging.page! != paging.totalPage!) {
        isPaging = true;
      }
    }
    if (paging == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: Text(
              "Trang ${paging.page}/${paging.totalPage}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(width: 30),
          InkWell(
            onTap: () async {
              if (paging!.page != 1) {
                // await model.filterListInvoice(
                //   time: selectDate!,
                //   page: paging.page! - 1,
                //   filter: textInput()!,
                // );
                _bloc.add(GetInvoiceList(
                    status: _provider.invoiceStatus.id,
                    bankId: selectBankId ?? '',
                    time: selectDate != null
                        ? DateFormat('yyyy-MM').format(selectDate!)
                        : '',
                    filterBy: 1,
                    page: paging.page! - 1));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: paging.page != 1
                          ? AppColor.BLACK
                          : AppColor.GREY_DADADA)),
              child: Center(
                child: Icon(
                  Icons.chevron_left_rounded,
                  color:
                      paging.page != 1 ? AppColor.BLACK : AppColor.GREY_DADADA,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          InkWell(
            onTap: () async {
              if (isPaging && paging != null) {
                // await model.filterListInvoice(
                //   time: selectDate!,
                //   page: paging.page! + 1,
                //   filter: textInput()!,
                // );
                _bloc.add(GetInvoiceList(
                    status: _provider.invoiceStatus.id,
                    bankId: selectBankId ?? '',
                    time: selectDate != null
                        ? DateFormat('yyyy-MM').format(selectDate!)
                        : '',
                    filterBy: 1,
                    page: paging.page! + 1));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: isPaging ? AppColor.BLACK : AppColor.GREY_DADADA)),
              child: Center(
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: isPaging ? AppColor.BLACK : AppColor.GREY_DADADA,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
