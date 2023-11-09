import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmActive extends StatelessWidget {
  final VoidCallback edit;
  const ConfirmActive({super.key, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveVhitekProvider>(builder: (context, provider, child) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: 28,
          ),
          Image(
            image: ImageUtils.instance
                .getImageNetWork(AppImages.iconPartnerVhitek),
            height: 120,
          ),
          const SizedBox(
            height: 8,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Xác nhận kích hoạt máy bán hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                _buildItemInfo('Mã vạch máy', provider.mid),
                DividerWidget(
                  width: double.infinity,
                  color: AppColor.BLACK_BUTTON.withOpacity(0.2),
                ),
                _buildItemInfo('Định danh máy', provider.midAddress),
                DividerWidget(
                  width: double.infinity,
                  color: AppColor.BLACK_BUTTON.withOpacity(0.2),
                ),
                _buildItemInfo('Email', provider.email),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
              onTap: (){
                edit();
                provider.changePage(1);
              },
              child: const Text(
                'Chỉnh sửa thông tin',
                style: TextStyle(
                    color: AppColor.BLUE_TEXT,
                    decoration: TextDecoration.underline),
              ))
        ],
      );
    });
  }

  Widget _buildItemInfo(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(title),
            const Spacer(),
            Text(
              content,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
