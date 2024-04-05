import 'package:VietQR/layouts/dashedline/vertical_dashed_line.dart';
import 'package:flutter/material.dart';

import '../../commons/constants/configurations/app_image.dart';
import '../../commons/constants/configurations/theme.dart';
import '../../commons/utils/image_utils.dart';
import '../../commons/widgets/dot_dash_widget.dart';
import '../box_layout.dart';

class PopUpMenuWidget extends StatefulWidget {
  const PopUpMenuWidget({super.key});

  @override
  State<PopUpMenuWidget> createState() => _PopUpMenuWidgetState();
}

class _PopUpMenuWidgetState extends State<PopUpMenuWidget> {
  bool _isObscure = false;
  int accountBalance = 0;
  int pointStar = 0;
  String title = 'Quản lý TT kinh doanh';
  String toggleEye = AppImages.icToggleEyeOpenBlue;
  String toggleEyeMessage = 'Hiện thị VQR';
  List<String> itemsName = [
    'Nạp tiền\nđiện thoại',
    'VietQR\nKiot',
    'Kích hoạt\nmáy bán hàng',
    'Mở TK\nngân hàng',
    'Chia sẻ\nBĐSD Telegram',
    'Chia sẻ\nBĐSD Lark'
  ];
  List<String> itemsLogo = [
    AppImages.logoMobileMoney3D, // nap tien dien thoai
    AppImages.icVietQRKiotDash, // vietqrkiot
    AppImages.iconActiveMBH, // kich hoat may ban hang
    AppImages.logoBankPurple, // mo tai khoan ngan hang
    AppImages.logoTelegramDash, // telegram
    AppImages.logoLarkDash, // lark
  ];

  void _toggleObscureText() {
    setState(() {
      _isObscure = !_isObscure;
      if (_isObscure) {
        toggleEye = AppImages.icToggleEyeCloseBlue;
        toggleEyeMessage = 'Che VQR';
      } else {
        toggleEye = AppImages.icToggleEyeOpenBlue;
        toggleEyeMessage = 'Hiện thị VQR';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 680,
      width: 400,
      decoration: const BoxDecoration(color: AppColor.WHITE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: toggleEyeMessage,
                      child: InkWell(
                        onTap: () => _toggleObscureText(),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: BoxLayout(
                                  width: 30,
                                  height: 30,
                                  // borderRadius: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(0),
                                  bgColor: AppColor.BLUE_DARK.withOpacity(0.3),
                                  border: Border.all(
                                      color: AppColor.BLACK, width: 0.5),
                                  child: Image(
                                    image: ImageUtils.instance
                                        .getImageNetWork(toggleEye),
                                    width: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'Số dư tài khoản',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isObscure)
                      Text(
                        accountBalance.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    if (!_isObscure)
                      const Text(
                        '*****',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'VQR',
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      pointStar.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Image(
                      image: ImageUtils.instance
                          .getImageNetWork(AppImages.icPoint),
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              MySeparator(color: Colors.grey),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 80,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 134, 241, 255),
                  Color.fromARGB(255, 101, 175, 255),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 9,
                    bottom: 9,
                  ),
                  child: SizedBox(
                    height: 53,
                    width: 249,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Liên kết tài khoản ngân hàng',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Liên kết tài khoản ngân hàng để nhận BĐSD\nvà quản lý các thông tin giao dịch của bạn.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.BLACK,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 62,
                  height: 62,
                  child: Image(
                    image: ImageUtils.instance
                        .getImageNetWork(AppImages.iconLinkedBankAccount),
                    width: 110,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 80,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 233, 183, 29),
                  Color.fromARGB(255, 255, 231, 159),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 9,
                    bottom: 9,
                  ),
                  child: SizedBox(
                    width: 62,
                    height: 62,
                    child: Image(
                      image: ImageUtils.instance
                          .getImageNetWork(AppImages.iconQRBox),
                      width: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 53,
                  width: 226,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Đăng ký sử dụng QR Box ngay!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Hiển thị mã VietQR cửa hàng và nhận\nthông báo thanh toán ngay trên thiết bị.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.BLACK,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 322,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: AppColor.BLUE_BGR,
            ),
            child: GridView.count(
              // mainAxisSpacing: 10,
              // crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: _buildGridContent(itemsName, itemsLogo),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItems({required itemName, required itemImage}) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Image(
                    image: ImageUtils.instance.getImageNetWork(itemImage),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.BLACK,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _buildGridContent(
      List<String> itemsName, List<String> itemsLogo) {
    List<Widget> listWidget = [];
    itemsName.asMap().forEach((index, value) {
      listWidget.add(_buildItems(itemName: value, itemImage: itemsLogo[index]));
    });

    return listWidget;
  }
}
