import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/commons/widgets/m_button_widget.dart';
import 'package:VietQR/commons/widgets/repaint_boundary_widget.dart';
import 'package:VietQR/models/unpaid_invoice_detail_qr_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PopupUnpaidQrWidget extends StatefulWidget {
  final UnpaidInvoiceDetailQrDTO dto;
  const PopupUnpaidQrWidget({super.key, required this.dto});

  @override
  State<PopupUnpaidQrWidget> createState() => _PopupUnpaidQrWidgetState();
}

class _PopupUnpaidQrWidgetState extends State<PopupUnpaidQrWidget> {
  final globalKey = GlobalKey();

  void onSaveImage(BuildContext context, String bankAccount) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance
            .saveImageToGallery(globalKey, bankAccount)
            .then(
          (value) {
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
              webBgColor: 'rgba(255, 255, 255)',
              webPosition: 'center',
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          color: AppColor.WHITE,
          width: 1200,
          height: 750,
          child: Column(
            children: [
              Container(
                width: 1200,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mã VietQR hoá đơn thanh toán',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 500,
                    height: 690,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 50),
                    decoration: const BoxDecoration(
                        color: AppColor.WHITE,
                        border: Border(
                            right: BorderSide(
                                color: AppColor.GREY_DADADA, width: 1))),
                    child: Column(
                      children: [
                        RepaintBoundaryWidget(
                            globalKey: globalKey,
                            builder: (key) {
                              return Container(
                                width: 400,
                                height: 400,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bg-qr-vqr.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 320,
                                    height: 320,
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 20, 30, 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 240,
                                          height: 240,
                                          // color: AppColor.GREY_DADADA,
                                          child: QrImageView(
                                            data: widget.dto.qrCode ?? '',
                                            size: 220,
                                            version: QrVersions.auto,
                                            embeddedImage: const AssetImage(
                                                'assets/images/ic-viet-qr-small.png'),
                                            embeddedImageStyle:
                                                const QrEmbeddedImageStyle(
                                              size: Size(30, 30),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Image.asset(
                                                  "assets/images/ic-viet-qr.png",
                                                  height: 20,
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/images/ic-napas247.png",
                                                height: 30,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'SỬ DỤNG APP NGÂN HÀNG HOẶC VÍ ĐIỆN TỬ QUÉT MÃ QR ĐỂ THANH TOÁN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        InkWell(
                          onTap: () {
                            onSaveImage(context, widget.dto.bankAccount);
                          },
                          child: MButtonWidget(
                            title: 'Lưu ảnh QR',
                            isEnable: true,
                            margin: EdgeInsets.zero,
                            width: 400,
                            colorEnableBgr: AppColor.WHITE,
                            colorEnableText: AppColor.BLUE_TEXT,
                            border: Border.all(color: AppColor.BLUE_TEXT),
                            radius: 100,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 660,
                    height: 690,
                    color: AppColor.WHITE,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.dto.invoiceName,
                          widget.dto.invoiceName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Text(
                            StringUtils.formatNumber(
                                widget.dto.totalAmountAfterVat),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: AppColor.ORANGE),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        _buildItem('Mã hoá đơn', widget.dto.invoiceNumber),
                        if (widget.dto.vso.isNotEmpty &&
                            widget.dto.midName.isNotEmpty)
                          _buildItem('Khách hàng thanh toán',
                              '${widget.dto.vso} - ${widget.dto.midName}')
                        else
                          _buildItem('Tài khoản ngân hàng',
                              '${widget.dto.bankShortName} - ${widget.dto.bankAccount} - ${widget.dto.userBankName}'),
                        _buildItem('Tổng tiền',
                            StringUtils.formatNumber(widget.dto.totalAmount)),
                        _buildItem('Tiền thuế GTGT (VAT)',
                            '${widget.dto.vat}% - ${StringUtils.formatNumber(widget.dto.vatAmount)}'),
                        _buildItem(
                            'Tổng tiền thanh toán',
                            StringUtils.formatNumber(
                                widget.dto.totalAmountAfterVat)),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String leftText, String rightText) {
    TextStyle defaultStyle = const TextStyle(fontSize: 15);
    TextStyle boldStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return SizedBox(
      width: 660,
      height: 60,
      child: Column(
        children: [
          SizedBox(
            width: 660,
            height: 59,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftText,
                  style: defaultStyle,
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      rightText,
                      style: leftText == 'Tổng tiền thanh toán'
                          ? boldStyle
                          : defaultStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
        ],
      ),
    );
  }
}
