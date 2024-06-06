import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:flutter/material.dart';

class ItemRightWidget extends StatelessWidget {
  final InvoiceFeeDTO dto;
  final Function() onShowQR;
  final Function() onShowDetail;
  final Function() onShowExcel;

  const ItemRightWidget(
      {super.key,
      required this.dto,
      required this.onShowQR,
      required this.onShowDetail,
      required this.onShowExcel});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    left:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    bottom:
                        BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    right: BorderSide(
                        color: AppColor.GREY_TEXT.withOpacity(0.3)))),
            height: 50,
            width: 120,
            child: SelectionArea(
                child: Text(
              dto.status == 0
                  ? 'Chờ thanh toán'
                  : dto.status == 1
                      ? 'Đã thanh toán'
                      : 'Chưa TT hết',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: dto.status == 0
                    ? AppColor.ORANGE_DARK
                    : dto.status == 1
                        ? AppColor.GREEN
                        : AppColor.GREEN_STATUS,
              ),
            )),
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
            width: 140,
            child: SelectionArea(
              child: Row(
                mainAxisAlignment: dto.status == 1
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (dto.status == 0 || dto.status == 3)
                    Tooltip(
                      message: 'Mã QR',
                      child: InkWell(
                        onTap: onShowQR,
                        child: BoxLayout(
                          width: 30,
                          height: 30,
                          borderRadius: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(0),
                          bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                          child: const Icon(
                            Icons.qr_code,
                            size: 12,
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ),
                    ),
                  Tooltip(
                    message: 'Thông tin hoá đơn',
                    child: InkWell(
                      onTap: onShowDetail,
                      child: BoxLayout(
                        width: 30,
                        height: 30,
                        borderRadius: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        child: const Icon(
                          Icons.info,
                          size: 12,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ),
                  ),
                  if (dto.status == 1) const SizedBox(width: 10),
                  Tooltip(
                    message: 'Xuất Excel',
                    child: InkWell(
                      onTap: onShowExcel,
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
