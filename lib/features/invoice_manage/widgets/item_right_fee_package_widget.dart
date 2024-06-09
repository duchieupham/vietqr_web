import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/fee_package_invoice.dto.dart';
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class ItemRightFeePackageWidget extends StatelessWidget {
  final FeePackageInvoiceDTO dto;
  final Function() onShowExcel;

  const ItemRightFeePackageWidget(
      {super.key, required this.dto, required this.onShowExcel});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                border: Border(
                    left:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    bottom:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    right: BorderSide(
                        color: AppColor.GREY_TEXT.withOpacity(0.3)))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.totalAfterVat.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
                    left:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    bottom:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    right: BorderSide(
                        color: AppColor.GREY_TEXT.withOpacity(0.3)))),
            height: 50,
            width: 80,
            child: SelectionArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: 'Xuất Excel',
                    child: InkWell(
                      onTap: () {
                        String link =
                            'https://api.vietqr.org/vqr/api/invoice/export-excel?invoiceItemId=${dto.invoiceItemId}';
                        html.window.open(link, 'new tab');
                      },
                      // onTap: () {
                      // onShowPopupExcel();
                      // DialogWidget.instance.openMsgDialog(
                      //     title: 'Bảo trì',
                      //     msg:
                      //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                      // },
                      child: BoxLayout(
                        width: 30,
                        height: 30,
                        borderRadius: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        child: const Icon(
                          Icons.list,
                          size: 12,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
