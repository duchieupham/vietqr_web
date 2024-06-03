import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/commons/widgets/m_button_widget.dart';
import 'package:VietQR/features/invoice_manage/bloc/invoice_bloc.dart';
import 'package:VietQR/features/invoice_manage/event/invoice_events.dart';
import 'package:VietQR/features/invoice_manage/state/invoice_states.dart';
import 'package:VietQR/features/invoice_manage/widgets/bank_account_item.dart';
import 'package:VietQR/features/invoice_manage/widgets/item_title_widget.dart';
import 'package:VietQR/features/invoice_manage/widgets/popup_qr_widget.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:VietQR/models/invoice_detail_qr_dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final InvoiceBloc bloc;
  // final String invoiceId;
  final Function() callback;

  const InvoiceDetailScreen({
    super.key,
    required this.bloc,
    required this.callback,
  });

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final controller1 = ScrollController();
  final controller2 = ScrollController();
  final controller3 = ScrollController();
  final controller4 = ScrollController();

  late InvoiceProvider _provider;

  InvoiceDetailDTO? _invoiceDetailDTO;
  List<PaymentRequestDTO> listPaymentBank = [];

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<InvoiceProvider>(context, listen: false);

    // widget.bloc.add(GetInvoiceDetail(widget.invoiceId, false));
  }

  void onShowQRPopup(InvoiceDetailQrDTO dto) async {
    await showDialog(
      context: context,
      // builder: (context) => PopupQrCodeInvoice(invoiceId: dto.invoiceId),
      builder: (context) => PopupQrCodeInvoice(
        dto: dto,
        showButton: false,
        onPop: (id) {
          Navigator.of(context).pop();
          widget.bloc.add(GetInvoiceDetail(id, false));
          // _model.getInvoiceDetail(id);
        },
        invoiceId: dto.invoiceId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceStates>(
      listener: (context, state) {
        if (state.request == InvoiceType.INVOICE_DETAIL &&
            state.status == BlocStatus.SUCCESS) {
          _invoiceDetailDTO = state.invoiceDetailDTO;
          _provider.setListSelectItem(_invoiceDetailDTO!.invoiceItemDetailDTOS);
        }

        if (state.request == InvoiceType.REQUEST_PAYMENT &&
            state.status == BlocStatus.SUCCESS) {
          onShowQRPopup(state.invoiceDetailQrDTO!);
        }
      },
      builder: (context, state) {
        if (state.request == InvoiceType.INVOICE_DETAIL &&
            state.status == BlocStatus.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }

        return Consumer<InvoiceProvider>(
          builder: (context, provider, child) {
            bool isEnable = false;
            if (provider.listSelectInvoice.isNotEmpty) {
              isEnable =
                  provider.listSelectInvoice.any((x) => x.isSelect == true) &&
                      state.invoiceDetailDTO!.paymentRequestDTOS.any(
                        (x) => x.isChecked,
                      );
            }
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: widget.callback,
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 30),
                            const Text(
                              'Chi tiết hoá đơn',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (_invoiceDetailDTO != null)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 500,
                                    height: 60,
                                    margin: const EdgeInsets.only(top: 30),
                                    child: Text(
                                      state.invoiceDetailDTO!.invoiceName,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  state.invoiceDetailDTO!.invoiceDescription
                                          .isNotEmpty
                                      ? Text(
                                          state.invoiceDetailDTO!
                                              .invoiceDescription,
                                          style: const TextStyle(fontSize: 15),
                                        )
                                      : const SizedBox.shrink(),
                                  if (state.invoiceDetailDTO!.customerDetailDTOS
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 29),
                                    const MySeparator(
                                      color: AppColor.GREY_DADADA,
                                    ),
                                    const SizedBox(height: 30),
                                    const SizedBox(
                                      width: double.infinity,
                                      height: 20,
                                      child: Text(
                                        'Thông tin khách hàng thanh toán',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: 1300,
                                      child: Scrollbar(
                                        controller: controller1,
                                        child: SingleChildScrollView(
                                          controller: controller1,
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Column(
                                              children: [
                                                _itemTitlePaymentInfo(),
                                                ...state.invoiceDetailDTO!
                                                    .customerDetailDTOS
                                                    .asMap()
                                                    .map(
                                                      (index, e) => MapEntry(
                                                        index,
                                                        _buildItemPaymentInfo(
                                                            e, index + 1),
                                                      ),
                                                    )
                                                    .values
                                                    .toList()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const MySeparator(
                                      color: AppColor.GREY_DADADA,
                                    ),
                                  ],
                                  if (state.invoiceDetailDTO!
                                      .feePackageDetailDTOS.isNotEmpty) ...[
                                    const SizedBox(height: 30),
                                    const SizedBox(
                                      width: double.infinity,
                                      height: 20,
                                      child: Text(
                                        'Thông tin gói dịch vụ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: 920,
                                      child: Scrollbar(
                                        controller: controller2,
                                        child: SingleChildScrollView(
                                          controller: controller2,
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Column(
                                              children: [
                                                _itemTitleServiceInfo(),
                                                ...state.invoiceDetailDTO!
                                                    .feePackageDetailDTOS
                                                    .asMap()
                                                    .map(
                                                      (index, e) => MapEntry(
                                                        index,
                                                        _buildItemServiceInfo(
                                                            e, index + 1),
                                                      ),
                                                    )
                                                    .values
                                                    .toList()
                                                // _buildItemServiceInfo(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 20),
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 20,
                                    child: Text(
                                      'Danh mục hàng hoá / dịch vụ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    // width: statusNum == 0 ? 1360 : 1270,
                                    width: state.invoiceDetailDTO!.status == 0
                                        ? 1360
                                        : 1270,
                                    // width: 1270,
                                    child: Scrollbar(
                                      controller: controller3,
                                      child: SingleChildScrollView(
                                        controller: controller3,
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            children: [
                                              _itemTitleListService(),
                                              // _buildItemListService(),
                                              if (state.status ==
                                                      BlocStatus.LOADING &&
                                                  state.request ==
                                                      InvoiceType
                                                          .INVOICE_DETAIL)
                                                const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              else
                                                ...provider.listSelectInvoice
                                                    .asMap()
                                                    .map(
                                                      (index, e) {
                                                        bool isAlreadyPay = state
                                                                .invoiceDetailDTO!
                                                                .invoiceItemDetailDTOS[
                                                                    index]
                                                                .status ==
                                                            1;
                                                        if (isAlreadyPay) {
                                                          provider
                                                              .appliedInvoiceItem(
                                                                  isAlreadyPay,
                                                                  index);
                                                        }
                                                        return MapEntry(
                                                          index,
                                                          _buildItemListService(
                                                              e,
                                                              index + 1,
                                                              isAlreadyPay,
                                                              provider),
                                                        );
                                                      },
                                                    )
                                                    .values
                                                    .toList()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const MySeparator(
                                      color: AppColor.GREY_DADADA),
                                  const SizedBox(height: 30),
                                  // const SizedBox(
                                  //   width: double.infinity,
                                  //   height: 20,
                                  //   child: Text(
                                  //     'Tài khoản nhận tiền',
                                  //     style: TextStyle(
                                  //         fontSize: 15,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 30),
                                  // if (state.invoiceDetailDTO!.paymentRequestDTOS
                                  //     .isNotEmpty)
                                  //   SizedBox(
                                  //     height: 70,
                                  //     child: ListView.separated(
                                  //         scrollDirection: Axis.horizontal,
                                  //         itemBuilder: (context, index) {
                                  //           listPaymentBank = state
                                  //               .invoiceDetailDTO!
                                  //               .paymentRequestDTOS;

                                  //           return SelectBankRecieveItem(
                                  //             dto: listPaymentBank[index],
                                  //             onChange: (value) {
                                  //               for (var e in listPaymentBank) {
                                  //                 e.isChecked = false;
                                  //               }
                                  //               listPaymentBank[index]
                                  //                   .isChecked = true;
                                  //               setState(() {});
                                  //               // model.selectPayment(index);
                                  //             },
                                  //           );
                                  //         },
                                  //         separatorBuilder: (context, index) =>
                                  //             const SizedBox(width: 20),
                                  //         itemCount: state.invoiceDetailDTO!
                                  //             .paymentRequestDTOS.length),
                                  //   ),
                                  const SizedBox(height: 200),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _invoiceDetailDTO != null
                          ? _bottomData(state.invoiceDetailDTO!, isEnable)
                          : const SizedBox.shrink())
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemListService(SelectInvoiceItem dto, int index,
      bool isAlreadyPay, InvoiceProvider provider) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          isAlreadyPay == false
              ? Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 50,
                  child: Checkbox(
                    activeColor: AppColor.BLUE_TEXT,
                    value: dto.isSelect,
                    onChanged: (value) {
                      provider.appliedInvoiceItem(value!, index - 1);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            color: AppColor.GREY_TEXT.withOpacity(0.3))),
                  ),
                )
              : Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 50,
                  child: Checkbox(
                    activeColor: AppColor.ITEM_MENU_SELECTED,
                    checkColor: AppColor.BLUE_TEXT,
                    value: true,
                    onChanged: (value) {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            color: AppColor.GREY_TEXT.withOpacity(0.3))),
                  ),
                ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 250,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.invoiceItemName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.unit.isEmpty ? '-' : dto.invoiceItem.unit,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.quantity.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatMoney(dto.invoiceItem.amount.toString()),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatMoney(dto.invoiceItem.totalAmount.toString()),

                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.vat.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                StringUtils.formatMoney(dto.invoiceItem.vatAmount.toString()),

                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatMoney(
                    dto.invoiceItem.totalAmountAfterVat.toString()),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.status == 0
                    ? 'Chưa thanh toán'
                    : dto.invoiceItem.status == 1
                        ? 'Đã thanh toán'
                        : 'Chưa thanh toán hết',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: dto.invoiceItem.status == 0
                      ? AppColor.ORANGE
                      : dto.invoiceItem.status == 1
                          ? AppColor.GREEN
                          : AppColor.GREEN_STATUS,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleListService() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 100,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Consumer<InvoiceProvider>(
                  builder: (context, provider, child) {
                    bool isAllApplied = provider.listSelectInvoice
                        .every((element) => element.isSelect == true);
                    return Checkbox(
                      activeColor: AppColor.BLUE_TEXT,
                      value: isAllApplied,
                      onChanged: (value) {
                        provider.appliedAllItem(value!);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: AppColor.GREY_TEXT.withOpacity(0.3))),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tất cả',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          const BuildItemlTitle(
              title: 'Nội dung hoá đơn thanh toán',
              height: 50,
              width: 250,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'Đơn vị tính',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'Số lượng',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'Đơn giá (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'Thành tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: '% VAT',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'VAT (VND)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'Tổng tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          const BuildItemlTitle(
              title: 'Trạng thái',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemServiceInfo(FeePackageDetailDTO dto, index) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.feePackage,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatMoney(dto.annualFee.toString()),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatMoney(dto.fixFee.toString()),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                (dto.percentFee.toString()),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.vat.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.recordType == 0 ? 'Chỉ GD đối soát' : 'Tất cả GD',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleServiceInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Gói dịch vụ',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí duy trì (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí giao dịch (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí giao dịch (%)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VAT(%)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Ghi nhận GD',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _itemTitlePaymentInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'VSO',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đại lý',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Nền tảng',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'TK ngân hàng',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Chủ TK',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Luồng kết nối',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tài khoản VietQR',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Email',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemPaymentInfo(CustomerDetailDTO dto, int index) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.vso.isNotEmpty ? dto.vso : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.merchantName.isNotEmpty ? dto.merchantName : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.platform.isNotEmpty ? dto.platform : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                '${dto.bankAccount}\n${dto.bankShortName}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.userBankName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.connectionType,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.phoneNo,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.email.isNotEmpty ? dto.email : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomData(InvoiceDetailDTO dto, bool isEnable) {
    String status = '';
    Color color = AppColor.WHITE;
    switch (dto.status) {
      case 0:
        status = 'Chưa thanh toán';
        color = AppColor.ORANGE_DARK;
        break;
      case 1:
        status = 'Đã thanh toán';
        color = AppColor.GREEN;
        break;
      case 3:
        status = 'Chưa TT hết';
        color = AppColor.GREEN_2D9D92;
        break;
      default:
    }
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      width: double.infinity,
      // width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
          // border: Border(
          //   top: BorderSide(color: AppColor.GREY_DADADA, width: 1),
          // ),
          boxShadow: [
            BoxShadow(
              color: AppColor.BLACK.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(2, -1),
            ),
          ],
          color: AppColor.WHITE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Scrollbar(
              controller: controller4,
              child: SingleChildScrollView(
                controller: controller4,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tổng tiền hàng',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          StringUtils.formatNumber(dto.totalAmount),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(width: 90),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'VAT',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          StringUtils.formatNumber(dto.vatAmount),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(width: 90),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa TT (bao gồm VAT)',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          StringUtils.formatNumber(dto.totalUnpaid),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.ORANGE_DARK,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Đã TT (bao gồm VAT)',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          StringUtils.formatNumber(dto.totalPaid),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.GREEN,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8),
            // decoration: BoxDecoration(
            //   border: Border(
            //       left: BorderSide(color: AppColor.GREY_DADADA, width: 0.5)),
            // ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Trạng thái',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 12),
                MButtonWidget(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  colorDisableBgr: AppColor.GREY_DADADA,
                  width: 250,
                  height: 50,
                  title: 'Yêu cầu thanh toán',
                  radius: 5,
                  isEnable: isEnable,
                  onTap: isEnable
                      ? () async {
                          widget.bloc.add(RequestPaymentInvoiceItemEvent(
                              dto.invoiceId,
                              List<String>.from(_provider.listSelectInvoice
                                  .where((e) =>
                                      e.isSelect == true &&
                                      e.invoiceItem.status == 0)
                                  .toList()
                                  .map(
                                    (x) => x.invoiceItem.invoiceItemId,
                                  )),
                              false));
                          // Navigator.of(context).pop();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
