import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';

class TransHeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final BankAccountDTO? dto;
  final GestureTapCallback? onTap;

  const TransHeaderWidget(
      {super.key,
      required this.title,
      required this.child,
      required this.dto,
      this.onTap});

  TextStyle get styles =>
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Text('Giao dịch', style: styles),
                  const SizedBox(width: 8),
                  Text('/', style: styles),
                  const SizedBox(width: 8),
                  Text(title, style: styles),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTap,
                    child: Row(
                      children: [
                        if (dto?.imgId != null) ...[
                          Image(
                              image: ImageUtils.instance
                                  .getImageNetWork(dto?.imgId ?? ''),
                              width: 36),
                          Text(
                            dto?.bankAccount ?? '',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                        Image(
                          image: ImageUtils.instance
                              .getImageNetWork(AppImages.icChooseBank),
                          width: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1.5, color: AppColor.GREY_BORDER),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kết quả bán hàng hôm nay',
                    style: TextStyle(
                        color: AppColor.BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildInfoPayment(
                        title: 'Tất cả GD',
                        totalTrans: '0',
                        amount: '0',
                        des: 'Doanh thu',
                      ),
                      _buildInfoPayment(
                        title: 'Giao dịch đã hạch toán',
                        totalTrans: '0',
                        amount: '0',
                        amountColor: AppColor.GREEN,
                        des: 'Doanh thu',
                      ),
                      _buildInfoPayment(
                        title: 'Giao dịch chờ hạch toán',
                        totalTrans: '0',
                        amount: '0',
                        des: 'Doanh thu',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPayment(
      {String title = '',
      String totalTrans = '',
      String amount = '',
      String des = '',
      Color? amountColor}) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.GREY_TEXT,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          Text(
            '$totalTrans giao dịch đến',
            style: const TextStyle(
              color: AppColor.BLACK,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          Row(
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: amountColor ?? AppColor.BLUE_TEXT,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const Text(
                ' VND',
                style: TextStyle(
                  color: AppColor.GREY_TEXT,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
          Text(
            des,
            style: const TextStyle(
              color: AppColor.GREY_TEXT,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
