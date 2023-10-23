import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '(Ví) VietQR',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        BoxLayout(
          bgColor: AppColor.BLUE_CARD,
          borderRadius: 8,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              const SizedBox(
                height: 16,
              ),
              _buildInfoWallet()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Image(
          image: ImageUtils.instance.getImageNetWork(AppImages.icVietQrSmall),
          width: 35,
          height: 35,
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VietQR',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColor.WHITE),
            ),
            Text(
              UserInformationHelper.instance.getUserFullname(),
              style: const TextStyle(fontSize: 12, color: AppColor.WHITE),
            )
          ],
        ),
        const Spacer()
      ],
    );
  }

  Widget _buildInfoWallet() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: 'Số dư: ',
                style: const TextStyle(fontSize: 13, color: AppColor.WHITE),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          '${CurrencyUtils.instance.getCurrencyFormatted(Session.instance.wallet.amount)} VQR',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                const Text('Điểm thưởng:  ',
                    style: TextStyle(fontSize: 13, color: AppColor.WHITE)),
                Text(Session.instance.wallet.point,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.WHITE)),
                Image(
                  image: ImageUtils.instance.getImageNetWork(AppImages.icPoint),
                  width: 25,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {},
          child: BoxLayout(
              borderRadius: 8,
              bgColor: AppColor.CARD_MY_QR,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icMenuQR,
                    height: 25,
                    color: AppColor.WHITE,
                  ),
                  const Text(
                    'My QR',
                    style: TextStyle(fontSize: 9, color: AppColor.WHITE),
                  ),
                  const SizedBox(
                    width: 2,
                  )
                ],
              )),
        )
      ],
    );
  }
}
