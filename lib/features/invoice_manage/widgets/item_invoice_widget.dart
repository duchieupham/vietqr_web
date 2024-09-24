import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../../commons/constants/configurations/theme.dart';

class ItemInvoiceWidget extends StatelessWidget {
  final int index;
  final InvoiceFeeDTO dto;
  final Function(bool) onSelect;
  const ItemInvoiceWidget({
    super.key,
    required this.index,
    required this.dto,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDateTimePaid = dto.timePaid != 0 &&
            dto.timePaid.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timePaid * 1000))
        : '-';
    Color color = AppColor.WHITE;
    switch (dto.status) {
      case 0:
        color = AppColor.ORANGE_DARK;
        break;
      case 1:
        color = AppColor.GREEN;
        break;
      case 3:
        color = AppColor.GREEN_2D9D92;
        break;
      default:
        break;
    }
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          if (dto.status == 0)
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              height: 50,
              width: 90,
              child: Checkbox(
                value: dto.status == 1 ? true : dto.isSelect,
                onChanged: (value) {
                  if (value != null && dto.status != 1) {
                    onSelect(value);
                  }
                },
              ),
            ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 250,
            child: SelectionArea(
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.invoiceName,
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.invoiceName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
              ),
              // child: Text(
              //   dto.invoiceName!,
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   textAlign: TextAlign.left,
              //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              // ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    StringUtils.formatMoney(dto.totalAmount.toString()),
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  StringUtils.formatMoney(dto.totalAmount.toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                    // color: dto.status == 1
                    //     ? AppColor.GREEN
                    //     : AppColor.ORANGE_DARK),
                  ),
                ),
              ),
              // child: Text(
              //   StringUtils.formatMoney(dto.totalAmount.toString()),
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.bold,
              //     color: color,
              //     // color: dto.status == 1
              //     //     ? AppColor.GREEN
              //     //     : AppColor.ORANGE_DARK),
              //   ),
              // ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.invoiceNumber!.isNotEmpty ? dto.invoiceNumber! : '-',
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.invoiceNumber!.isNotEmpty ? dto.invoiceNumber! : '-',
                  // 'aasdasd',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
              ),
              // child: Text(
              //   dto.invoiceNumber!.isNotEmpty ? dto.invoiceNumber! : '-',
              //   // 'aasdasd',
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              // ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: dto.midName!.isNotEmpty
                ? Alignment.centerLeft
                : Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.midName!.isNotEmpty ? dto.midName! : '-',
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.midName!.isNotEmpty ? dto.midName! : '-',
                  // 'aasdasd',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
              ),
              // child: Text(
              //   dto.midName!.isNotEmpty ? dto.midName! : '-',
              //   // 'aasdasd',
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              // ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment:
                dto.vso!.isNotEmpty ? Alignment.centerLeft : Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.vso!.isNotEmpty ? dto.vso! : '-',
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.vso!.isNotEmpty ? dto.vso! : '-',
                  // 'aasdasd',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
              ),
              // child: Text(
              //   dto.vso!.isNotEmpty ? dto.vso! : '-',
              //   // 'aasdasd',
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              // ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: TextButton(
                  onPressed: () async {
                    await FlutterClipboard.copy(
                            '${dto.bankAccount} - ${dto.bankShortName}')
                        .then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColor.WHITE,
                        textColor: AppColor.BLACK,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255)',
                        webPosition: 'center',
                      ),
                    );
                  },
                  child: Text(
                    '${dto.bankAccount}\n${dto.bankShortName}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  )),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       // dto.bankAccount,
              //       dto.bankAccount!.isNotEmpty ? dto.bankAccount! : '-',
              //       textAlign: TextAlign.center,
              //       style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              //     ),
              //     Text(
              //       // dto.bankShortName,
              //       dto.bankShortName!.isNotEmpty ? dto.bankShortName! : '-',
              //       textAlign: TextAlign.center,
              //       style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              //     ),
              //   ],
              // ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 200,
            child: SelectionArea(
              // child: Text(
              //   dto.userBankName!.isNotEmpty ? dto.userBankName! : '-',
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              // ),
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.userBankName!.isNotEmpty ? dto.userBankName! : '-',
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.userBankName!.isNotEmpty ? dto.userBankName! : '-',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              // child: Text(
              //   dto.timePaid.toString() != '0' ? formattedDateTimePaid : '-',
              //   // '182938192381293',
              //   textAlign: TextAlign.end,
              //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              // ),
              child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.timePaid.toString() != '0'
                        ? formattedDateTimePaid
                        : '-',
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.timePaid.toString() != '0' ? formattedDateTimePaid : '-',
                  // '182938192381293',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
