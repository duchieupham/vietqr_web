import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';

class TitleItemInvoiceWidget extends StatelessWidget {
  const TitleItemInvoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.3)),
      child: Row(
        children: [
          _buildItemTitle('Thanh toán',
              height: 45,
              width: 90,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          // Container(
          //   width: 50,
          //   height: 45,
          //   alignment: Alignment.center,
          //   decoration: const BoxDecoration(
          //       border: Border(
          //           left: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
          //                child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Text(
          //         'Thanh toán\ntất cả',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             fontSize: 12,
          //             color: AppColor.BLACK,
          //             fontWeight: FontWeight.bold),
          //       ),
          //       const SizedBox(width: 8),
          //       Checkbox(
          //         value: true,
          //         onChanged: (value) {},
          //       ),
          //     ],
          //   ),
          // ),
          _buildItemTitle('STT',
              height: 45,
              width: 50,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Hoá đơn',
              height: 45,
              width: 250,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tổng tiền (VND)',
              height: 45,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Mã hoá đơn',
              height: 45,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Đại lý',
              height: 45,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Mã đại lý',
              height: 45,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('TK ngân hàng ',
              height: 45,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Chủ TK',
              height: 45,
              width: 200,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời gian TT',
              height: 45,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemTitle(String title,
      {TextAlign? textAlign,
      EdgeInsets? padding,
      double? width,
      double? height,
      Alignment? alignment}) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(
            fontSize: 12, color: AppColor.BLACK, fontWeight: FontWeight.bold),
      ),
    );
  }
}
