import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/widgets/%20button_vietqr_widget.dart';
import 'package:flutter/cupertino.dart';

class BottomPaymentWidget extends StatelessWidget {
  final int amount;
  final bool isDisable;
  final int selected;
  final Widget pagingWidget;
  final Function() onTap;
  const BottomPaymentWidget(
      {super.key,
      required this.amount,
      required this.isDisable,
      required this.pagingWidget,
      required this.onTap,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(color: AppColor.WHITE, boxShadow: [
        BoxShadow(
          color: AppColor.BLACK.withOpacity(0.1),
          blurRadius: 4,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              pagingWidget,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Đang chọn: $selected'),
                  const SizedBox(height: 4),
                  RichText(
                      text: TextSpan(
                          text: 'Tổng tiền (VND): ',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.BLACK),
                          children: [
                        TextSpan(
                          text: CurrencyUtils.instance
                              .getCurrencyFormatted(amount.toString()),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.ORANGE_DARK),
                        ),
                      ])),
                ],
              ),
            ],
          ),
          VietQRButton.gradient(
              borderRadius: 100,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: () => onTap(),
              isDisabled: isDisable,
              child: Center(
                  child: Text(
                'Thanh toán hóa đơn',
                style: TextStyle(
                    color: isDisable ? AppColor.BLACK : AppColor.WHITE),
              )))
        ],
      ),
    );
  }
}
