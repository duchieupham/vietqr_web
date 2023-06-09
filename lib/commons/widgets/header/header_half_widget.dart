import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/header/pop_up_menu_web_widget.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderHalfWidget extends StatelessWidget {
  final bool? isSubHeader;

  const HeaderHalfWidget({
    super.key,
    this.isSubHeader,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String imgId =
        UserInformationHelper.instance.getAccountInformation().imgId;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.only(right: 10)),
          //logo
          Tooltip(
            message: 'Trang chủ',
            child: InkWell(
              onTap: () {
                if (isSubHeader != null && isSubHeader!) {
                  context.go('/ecom');
                }
              },
              child: Image.asset(
                'assets/images/logo-vietqr-vn.png',
                height: 50,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // _buildTitle('Trang chủ'),
          //time
          const Spacer(),
          _buildAvatar(context, imgId, 35),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String imgId, double size) {
    return InkWell(
      onTap: () {
        PopupMenuWebWidget.instance.showPopupMenu(context, imgId);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (imgId.trim().isNotEmpty)
                ? ImageUtils.instance.getImageNetWork(imgId)
                : Image.asset('assets/images/ic-avatar.png').image,
          ),
        ),
      ),
    );
  }
}
