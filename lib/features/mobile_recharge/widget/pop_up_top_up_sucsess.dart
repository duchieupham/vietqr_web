import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/models/top_up_sucsess_dto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/utils/time_utils.dart';
import '../../../commons/widgets/divider_widget.dart';

class PopupTopUpSuccess extends StatelessWidget {
  final TopUpSuccessDTO dto;

  const PopupTopUpSuccess({Key? key, required this.dto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              const SizedBox(
                width: 32,
              ),
              Text(
                dto.paymentType == '0'
                    ? 'Dịch vụ VietQR'
                    : 'Nạp tiền điện thoại',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  context.go('/home');
                },
                icon: const Icon(
                  Icons.clear,
                  size: 18,
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Align(
            alignment: Alignment.center,
            child: Text(
              '+ ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} ${dto.paymentType == '0' ? 'VQR' : 'VND'}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: AppColor.BLUE_TEXT,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Nạp tiền thành công',
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 44)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Dịch vụ',
              ),
              const Spacer(),
              Text(
                dto.paymentType == '0'
                    ? 'Nạp tiền dịch vụ VietQR'
                    : 'Nạp tiền điện thoại',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DividerWidget(
              width: width,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dto.paymentType == '0'
                    ? 'Nạp tiền cho tài khoản'
                    : 'Nạp tiền cho số điện thoại',
              ),
              const Spacer(),
              Text(
                dto.phoneNo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DividerWidget(
              width: width,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mã giao dịch',
              ),
              const Spacer(),
              Text(
                dto.billNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DividerWidget(
              width: width,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Thời gian:',
              ),
              const Spacer(),
              Text(
                TimeUtils.instance.formatTimeDateFromInt(int.parse(dto.time)),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          ButtonWidget(
              text: 'Đóng',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              borderRadius: 5,
              height: 40,
              function: () {
                context.go('/home');
              })
        ],
      ),
    );
  }
}
