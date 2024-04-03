import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/store_detail_dto.dart';
import 'package:flutter/material.dart';

class FormInfoStoreWidget extends StatelessWidget {
  final StoreDetailDTO dto;

  const FormInfoStoreWidget({super.key, required this.dto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              _buildItemInfo(title: 'Tên cửa hàng', content: dto.name),
              _buildItemInfo(title: 'Mã điểm bán', content: dto.code),
              _buildItemInfo(title: 'Địa chỉ', content: dto.address),
              _buildItemInfo(
                title: 'Tài khoản cửa hàng',
                content: '${dto.bank.bankAccount}\n${dto.bank.bankName}',
                isAccountStore: true,
                imgId: dto.bank.imgId,
              ),
            ],
            ...[
              const SizedBox(height: 10),
              const Text(
                'Kết quả bán hàng hôm nay:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSaleResult(
                imgId: '',
                title: '${dto.totalTrans} giao dịch',
                totalTrans: dto.amount,
                subTitle: 'Doanh thu',
              ),
              _buildSaleResult(
                imgId: '',
                percent: '${dto.revGrowthPrevDate}%',
                subTitle: 'So với hôm qua',
              ),
              _buildSaleResult(
                imgId: '',
                percent: '${dto.revGrowthPrevMonth}%',
                subTitle: 'So với cùng kỳ tháng trước',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaleResult({
    required String imgId,
    String title = '',
    String totalTrans = '',
    String percent = '',
    required String subTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              if (totalTrans.isNotEmpty)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: totalTrans,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLUE_TEXT),
                      ),
                      const TextSpan(
                        text: ' VND',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              if (percent.isNotEmpty)
                Text(
                  percent,
                  style: const TextStyle(fontSize: 10, color: AppColor.GREEN),
                ),
              Text(
                subTitle,
                style: const TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo({
    required String title,
    required String content,
    String imgId = '',
    bool isAccountStore = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
                color: AppColor.GREY_TEXT,
                fontSize: 13,
                height: 1.6,
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 2),
          if (!isAccountStore)
            Text(
              content,
              maxLines: 2,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.5, color: AppColor.GREY_TEXT),
                    color: AppColor.WHITE,
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(imgId),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  content,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
