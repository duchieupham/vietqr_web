import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/count_down_minus_second.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/repaint_boundary_widget.dart';
import 'package:VietQR/features/mobile_recharge/frame/mobile_recharge_frame.dart';
import 'package:VietQR/features/mobile_recharge/provider/mobile_recharge_provider.dart';
import 'package:VietQR/models/respone_top_up_dto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRMobileRechargeScreen extends StatefulWidget {
  final ResponseTopUpDTO dto;
  final String phoneNo;
  final String nwProviders;
  const QRMobileRechargeScreen(
      {super.key,
      required this.dto,
      required this.phoneNo,
      required this.nwProviders});

  @override
  State<QRMobileRechargeScreen> createState() => _QRMobileRechargeScreenState();
}

class _QRMobileRechargeScreenState extends State<QRMobileRechargeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey globalKey = GlobalKey();
  int timer = 1800;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> share({required String name}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        textSharing: 'VietId of $name',
        key: globalKey,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                timer) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        DialogWidget.instance.openMsgDialog(
            title: 'Mã giao dịch hết hạn',
            msg: 'Vui lòng tạo lại giao dịch mới',
            function: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MobileRechargeFrame(
      widget1: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 48,
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 0, left: 30, right: 30),
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: QrImage(
                                data: widget.dto.qrCode,
                                version: QrVersions.auto,
                                embeddedImage: ImageUtils.instance
                                    .getImageNetWork(AppImages.icVietQrLogin),
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                  size: const Size(30, 30),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Image(
                                    image: ImageUtils.instance.getImageNetWork(
                                        AppImages.logoVietqrVn),
                                    height: 28,
                                  ),
                                  const Spacer(),
                                  Image(
                                    image: ImageUtils.instance
                                        .getImageNetWork(AppImages.icNapas247),
                                    height: 28,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                const Text(
                  'Thanh toán qua ứng dụng Ngân hàng/ Ví điện tử',
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonIconWidget(
            height: 40,
            pathIcon: AppImages.icEditAvatarSetting,
            textColor: AppColor.BLUE_TEXT,
            iconPathColor: AppColor.BLUE_TEXT,
            iconSize: 22,
            title: 'Lưu ảnh',
            textSize: 12,
            bgColor: AppColor.WHITE,
            borderRadius: 5,
            function: () async {
              await Future.delayed(const Duration(milliseconds: 300), () async {
                await ShareUtils.instance
                    .saveImageToGallery(globalKey)
                    .then((value) {
                  Fluttertoast.showToast(
                    msg: 'Đã lưu ảnh',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                  );
                  // Navigator.pop(context);
                });
              });
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: ButtonIconWidget(
          //           height: 40,
          //           pathIcon: AppImages.icEditAvatarSetting,
          //           textColor: AppColor.BLUE_TEXT,
          //           iconPathColor: AppColor.BLUE_TEXT,
          //           iconSize: 22,
          //           title: 'Lưu ảnh',
          //           textSize: 12,
          //           bgColor: AppColor.WHITE,
          //           borderRadius: 5,
          //           function: () async {
          //             await Future.delayed(const Duration(milliseconds: 300),
          //                 () async {
          //               await ShareUtils.instance
          //                   .saveImageToGallery(globalKey)
          //                   .then((value) {
          //                 Fluttertoast.showToast(
          //                   msg: 'Đã lưu ảnh',
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.CENTER,
          //                   backgroundColor: Theme.of(context).cardColor,
          //                   textColor: Theme.of(context).hintColor,
          //                   fontSize: 15,
          //                 );
          //                 // Navigator.pop(context);
          //               });
          //             });
          //           },
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 12,
          //       ),
          //       Expanded(
          //         child: ButtonIconWidget(
          //           title: 'Chia sẻ',
          //           height: 40,
          //           pathIcon: 'assets/images/ic-share-blue.png',
          //           textColor: AppColor.BLUE_TEXT,
          //           bgColor: AppColor.WHITE,
          //           iconPathColor: AppColor.BLUE_TEXT,
          //           iconSize: 22,
          //           borderRadius: 5,
          //           textSize: 12,
          //           function: () async {
          //             share(name: "QR thanh toán");
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
      widget2: ChangeNotifierProvider<MobileRechargeProvider>(
        create: (context) => MobileRechargeProvider(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Chi tiết giao dịch',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildInfoBill(),
                    const SizedBox(height: 30),
                    _buildSuggest(),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBill() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Số tiền cần thanh toán',
                style: TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Text(
                ' ${StringUtils.formatNumber(int.parse(widget.dto.amount.replaceAll(',', '')))} VND',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColor.ORANGE_DARK),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Text(
                'Dịch vụ',
                style: TextStyle(fontSize: 12),
              ),
              Spacer(),
              Text(
                'Nạp tiền điện thoại',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Nạp cho tài khoản',
                style: TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Text(
                widget.phoneNo,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Nhà mạng',
                style: TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Text(
                widget.nwProviders,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Thanh toán đơn hàng ',
                style: TextStyle(color: AppColor.BLACK),
              ),
              const Spacer(),
              Text(
                widget.dto.content,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Nhà cung cấp',
                style: TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
                height: 18,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Ngân hàng thụ hưởng', style: TextStyle(fontSize: 12)),
              const Spacer(),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.icNapas247),
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCountDown(),
        ],
      ),
    );
  }

  Widget _buildCountDown() {
    return Row(
      children: [
        const Text(
          'Giao dịch hết hạn sau',
          style: TextStyle(fontSize: 12),
        ),
        const Spacer(),
        CountDown(
          animation: StepTween(
            begin: timer, // THIS IS A USER ENTERED NUMBER
            end: 0,
          ).animate(_controller),
        ),
      ],
    );
  }

  Widget _buildSuggest() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.BLUE_TEXT.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: AppColor.BLUE_TEXT),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Lưu ý về Nạp tiền tiền điện thoại:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLUE_TEXT,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '- ',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.BLACK,
                  height: 1.4,
                ),
              ),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    text: 'Vui lòng không chỉnh sửa ',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'số tiền ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'và '),
                      TextSpan(
                          text: 'nội dung ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'chuyển khoản, điều này có thể ảnh hưởng tới hệ thống nạp tiền.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
