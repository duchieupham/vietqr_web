import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class PopupMenuWebWidget {
  const PopupMenuWebWidget._privateConsrtructor();

  static const PopupMenuWebWidget _instance =
      PopupMenuWebWidget._privateConsrtructor();
  static PopupMenuWebWidget get instance => _instance;

  Future<void> showPopupMenu(BuildContext context, String imgId) async {
    final RelativeRect position = _buttonMenuPosition(context);
    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (imgId.trim().isNotEmpty)
                        ? ImageUtils.instance.getImageNetWork(imgId)
                        : Image.asset('assets/images/ic-avatar.png').image,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserInformationHelper.instance.getUserFullname(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        'Chi tiết',
                        style: TextStyle(
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          color: DefaultTheme.GREEN,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: const [
              Icon(
                Icons.layers_outlined,
                size: 15,
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                'Giao diện',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: const [
              Icon(
                Icons.logout_rounded,
                color: DefaultTheme.RED_CALENDAR,
                size: 15,
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 13,
                  color: DefaultTheme.RED_CALENDAR,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  RelativeRect _buttonMenuPosition(BuildContext context) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    const Offset offset = Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
      ),
      offset & overlay.size,
    );
    return position;
  }

  // Future<void> resetAll(BuildContext context) async {
  //   Provider.of<CreateQRProvider>(context, listen: false).reset();
  //   Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
  //   Provider.of<BankAccountProvider>(context, listen: false).reset();
  //   Provider.of<UserEditProvider>(context, listen: false).reset();
  //   Provider.of<RegisterProvider>(context, listen: false).reset();
  //   await EventBlocHelper.instance.initialEventBlocHelper();
  //   await UserInformationHelper.instance.initialUserInformationHelper();
  // }
}
