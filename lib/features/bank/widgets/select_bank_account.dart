import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectBankAccountWidget extends StatelessWidget {
  final ActiveVhitekProvider provider;
  const SelectBankAccountWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Text(
                'Chọn ngân hàng',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        if (provider.isLoadingGetListBank)
          SizedBox(
            width: width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColor.BLUE_TEXT,
              ),
            ),
          )
        else if (provider.bankAccounts.isNotEmpty)
          Expanded(
            child: Visibility(
              visible: provider.bankAccounts.isNotEmpty,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: provider.bankAccounts.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  return _buildBankTypeItem(
                      context, provider.bankAccounts[index], width);
                },
                separatorBuilder: (context, index) {
                  return DividerWidget(width: width);
                },
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () async {
              context.go('/add-bank/step1');
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: ImageUtils.instance
                            .getImageNetWork(AppImages.icCardBlue),
                        height: 28,
                        color: AppColor.WHITE,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 5)),
                      const Text(
                        'Thêm tài khoản ngân hàng',
                        style: TextStyle(
                          color: AppColor.WHITE,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        const Padding(padding: EdgeInsets.only(top: 10)),
      ],
    );
  }

  Widget _buildBankTypeItem(
      BuildContext context, BankAccountDTO dto, double width) {
    return InkWell(
      onTap: () {
        provider.updateBankAccountDTO(dto);
        Navigator.pop(context);
      },
      child: BoxLayout(
        width: width,
        borderRadius: 0,
        bgColor: AppColor.TRANSPARENT,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                image: DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(
                    dto.imgId,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                '${dto.bankCode} - ${dto.bankAccount}\n${dto.userBankName}',
                style: const TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
