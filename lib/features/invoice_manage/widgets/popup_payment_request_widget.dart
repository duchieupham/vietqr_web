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
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopupPaymentRequestWidget extends StatefulWidget {
  final InvoiceDetailDTO invoiceDetailDTO;
  final InvoiceBloc bloc;
  final InvoiceFeeDTO dto;
  const PopupPaymentRequestWidget({
    super.key,
    required this.invoiceDetailDTO,
    required this.bloc,
    required this.dto,
  });

  @override
  State<PopupPaymentRequestWidget> createState() =>
      _PopupPaymentRequestWidgetState();
}

class _PopupPaymentRequestWidgetState extends State<PopupPaymentRequestWidget> {
  late InvoiceProvider _provider;

  InvoiceDetailDTO? _invoiceDetailDTO;
  List<PaymentRequestDTO> listPaymentBank = [];

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<InvoiceProvider>(context, listen: false);
    _invoiceDetailDTO = widget.invoiceDetailDTO;
    listPaymentBank = _invoiceDetailDTO!.paymentRequestDTOS;
    // widget.bloc.add(GetInvoiceDetail(widget.invoiceId));
  }

  void onShowQRPopup(InvoiceDetailQrDTO dto) async {
    await showDialog(
      context: context,
      builder: (context) => PopupQrCodeInvoice(
        dto: dto,
        showButton: true,
        onPop: (id) {
          Navigator.of(context).pop();
          widget.bloc.add(GetInvoiceDetail(id, false));
        },
        invoiceId: dto.invoiceId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        bool isEnable = false;
        if (provider.listSelectInvoice.isNotEmpty) {
          isEnable =
              provider.listSelectInvoice.any((x) => x.isSelect == true) &&
                  _invoiceDetailDTO!.paymentRequestDTOS.any(
                    (x) => x.isChecked,
                  );
        }
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: Container(
              color: AppColor.WHITE,
              width: 1150,
              height: 750,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  if (_invoiceDetailDTO != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tạo mã VietQR để yêu cầu thanh toán',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Tạo mã VietQR để yêu cầu thanh toán',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        _buildInvoiceDetailWidget(_invoiceDetailDTO!),
                        const MySeparator(color: AppColor.GREY_DADADA),
                        const SizedBox(height: 30),
                        const Text(
                          'Danh mục hàng hoá / dịch vụ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        _buildInvoiceWidget(provider),
                        const SizedBox(height: 50),
                        if (_invoiceDetailDTO != null)
                          _buildReqPayment(
                              _invoiceDetailDTO!.paymentRequestDTOS, isEnable),
                      ],
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReqPayment(List<PaymentRequestDTO> listReq, bool isEnable) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tài khoản nhận tiền',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 56,
                width: 600,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SelectBankRecieveItem(
                        dto: listPaymentBank[index],
                        onChange: (value) {
                          // _model.selectPayment(index);
                          for (var e in listPaymentBank) {
                            e.isChecked = false;
                          }
                          listPaymentBank[index].isChecked = true;
                          setState(() {});
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 20),
                    itemCount: listReq.length),
              ),
            ],
          ),
        ),
        MButtonWidget(
          colorDisableBgr: AppColor.GREY_DADADA,
          width: 350,
          height: 50,
          title: 'Yêu cầu thanh toán',
          isEnable: isEnable,
          margin: EdgeInsets.zero,
          onTap: isEnable
              ? () async {
                  widget.bloc.add(RequestPaymentInvoiceItemEvent(
                      widget.invoiceDetailDTO.invoiceId,
                      List<String>.from(_provider.listSelectInvoice
                          .where((e) =>
                              e.isSelect == true && e.invoiceItem.status == 0)
                          .toList()
                          .map(
                            (x) => x.invoiceItem.invoiceItemId,
                          )),
                      listPaymentBank
                          .firstWhere((element) => element.isChecked == true)
                          .bankId,
                      true));
                  Navigator.of(context).pop();
                  // final result = await _model.requestPayment(
                  //     invoiceId: widget.dto.invoiceId);
                  // if (result != null) {
                  //   if (!mounted) return;
                  //   Navigator.of(context).pop();
                  //   await showDialog(
                  //     context: context,
                  //     builder: (context) => PopupQrCodeInvoice(
                  //       onPop: widget.onPop,
                  //       invoiceId: result.invoiceId,
                  //     ),
                  //   );
                  // }
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildInvoiceWidget(InvoiceProvider provider) {
    if (_invoiceDetailDTO == null ||
        _invoiceDetailDTO!.invoiceItemDetailDTOS.isEmpty) {
      return const SizedBox.shrink();
    }
    bool isAllApplied =
        provider.listSelectInvoice.every((element) => element.isSelect == true);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            width: 700,
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
                      Checkbox(
                        activeColor: AppColor.BLUE_TEXT,
                        value: isAllApplied,
                        onChanged: (value) {
                          provider.appliedAllItem(value!);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                                color: AppColor.GREY_TEXT.withOpacity(0.3))),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Tất cả',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
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
                    padding: EdgeInsets.only(right: 4),
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
          ),
          Expanded(
              child: SizedBox(
            width: 700,
            child: ListView.separated(
              separatorBuilder: (context, index) => Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColor.GREY_DADADA, width: 1)))),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                bool isAlreadyPay =
                    _invoiceDetailDTO!.invoiceItemDetailDTOS[index].status == 1;
                if (isAlreadyPay) {
                  provider.appliedInvoiceItem(isAlreadyPay, index);
                }
                return _invoiceItemWidget(
                  index: index,
                  dto: provider.listSelectInvoice[index],
                  isAlreadyPay: isAlreadyPay,
                  provider: provider,
                );
              },
              itemCount: provider.listSelectInvoice.length,
            ),
          )),
        ],
      ),
    );
  }

  Widget _invoiceItemWidget(
      {required int index,
      required SelectInvoiceItem dto,
      required bool isAlreadyPay,
      required InvoiceProvider provider}) {
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
                      provider.appliedInvoiceItem(value!, index);
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
                (index + 1).toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 250,
            padding: const EdgeInsets.only(right: 4),
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
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.invoiceItem.totalAmountAfterVat),
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
                    : 'Đã thanh toán',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dto.invoiceItem.status == 0
                        ? AppColor.ORANGE
                        : AppColor.GREEN),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailWidget(InvoiceDetailDTO dto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        _itemTitleWidget(),
        _invoiceDetailWidget(dto),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _invoiceDetailWidget(InvoiceDetailDTO dto) {
    Color color = AppColor.WHITE;
    String status = '';
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
        status;
        break;
    }
    return Container(
      color: AppColor.WHITE,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 260,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                dto.invoiceName,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                widget.dto.billNumber!,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberAmount(dto.totalAmountAfterVat),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GREEN_2D9D92,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                widget.dto.vso!.isNotEmpty ? widget.dto.vso! : '-',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberAmount(dto.totalUnpaid),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.ORANGE_DARK,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberAmount(dto.totalPaid),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GREEN,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                status,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'Hoá đơn',
              textAlign: TextAlign.center,
              width: 260,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Mã hoá đơn',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VSO',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Chưa TT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đã TT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Trạng thái',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
