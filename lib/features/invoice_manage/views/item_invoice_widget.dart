import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../../../../commons/constants/configurations/theme.dart';

class ItemInvoiceWidget extends StatelessWidget {
  const ItemInvoiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                '1',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            // alignment:
            //     dto.vso.isNotEmpty ? Alignment.centerLeft : Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                'ansd',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                // StringUtils.formatNumberWithOutVND(dto.amount.toString()),
                '123123',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  // color: dto.status == 1
                  //     ? AppColor.GREEN
                  //     : AppColor.ORANGE_DARK),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                // dto.timePaid.toString() != '0' ? formattedDateTimePaid : '-',
                '1273812738',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            // alignment:
            //     dto.vso.isNotEmpty ? Alignment.centerLeft : Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                // dto.midName.isNotEmpty ? dto.midName : '-',
                'aasdasd',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                // dto.billNumber,
                '123123123sdasd',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 250,
            child: SelectionArea(
              child: Text(
                // dto.invoiceName,
                '123123123qeddsa',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                // dto.fullName.isNotEmpty ? dto.fullName : '-',
                'nguyenla',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // dto.bankAccount,
                    '1239012930123',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  ),
                  Text(
                    // dto.bankShortName,
                    'MB',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                // dto.phoneNo,
                '012930193012',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                // dto.email.isNotEmpty ? dto.email : '-',
                'nguyen@gmail.com',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                // dto.timeCreated.toString() != '0'
                //     ? formattedDateTimeCreated
                //     : '-',
                '182938192381293',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
