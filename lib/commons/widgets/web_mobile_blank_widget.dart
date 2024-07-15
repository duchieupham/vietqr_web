import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/logout/blocs/log_out_bloc.dart';
import 'package:VietQR/features/logout/events/log_out_event.dart';
import 'package:VietQR/features/logout/states/log_out_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class WebMobileBlankWidget extends StatelessWidget {
  static late LogoutBloc logoutBloc;

  const WebMobileBlankWidget({super.key});

  void initialServices(BuildContext context) {
    logoutBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    _redirectIfWeb();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: ImageUtils.instance
                                .getImageNetWork(AppImages.logoVietqrVn),
                            width: 150,
                          ),
                          const Spacer(),
                          if (UserInformationHelper.instance
                              .getUserId()
                              .isNotEmpty)
                            BlocListener<LogoutBloc, LogoutState>(
                              listener: (context, state) {
                                if (state is LogoutLoadingState) {
                                  DialogWidget.instance.openLoadingDialog();
                                }
                                if (state is LogoutSuccessfulState) {
                                  Navigator.pop(context);
                                  context.push('/login');
                                }
                                if (state is LogoutFailedState) {
                                  Navigator.pop(context);
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể đăng xuất',
                                    msg: 'Vui lòng thử lại sau.',
                                  );
                                }
                              },
                              child: ButtonIconWidget(
                                width: 120,
                                height: 35,
                                icon: Icons.logout_rounded,
                                title: 'Đăng xuất',
                                function: () {
                                  logoutBloc.add(const LogoutEventSubmit());
                                },
                                bgColor: Theme.of(context).cardColor,
                                textColor: AppColor.RED_TEXT,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text(
                      'Quét mã QR để tải ứng dụng VietQR VN',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    BoxLayout(
                      width: width * 0.45,
                      height: width * 0.45,
                      padding: const EdgeInsets.all(0),
                      bgColor: AppColor.WHITE,
                      enableShadow: true,
                      child: UnconstrainedBox(
                        child: QrImageView(
                          data: 'https://onelink.to/q7zwpe',
                          size: width * 0.4,
                          embeddedImage: ImageUtils.instance
                              .getImageNetWork(AppImages.icVietQrSmall),
                          embeddedImageStyle: const QrEmbeddedImageStyle(
                            size: Size(30, 30),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 50)),
                    const Text(
                      'Tải ứng dụng trên cửa hàng',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            width: width,
                            text: 'App Store',
                            assetImage: AppImages.logoAppStore,
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          _buildButton(
                            width: width,
                            text: 'Google Play',
                            assetImage: AppImages.logoGooglePlay,
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text(
                      'VietQR chỉ hỗ trợ trình duyệt web cho PC.',
                      style: TextStyle(
                        color: AppColor.GREY_TEXT,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          // BottomWeb(
          //   bgColor: Theme.of(context).cardColor,
          // ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required double width,
    required String text,
    required String assetImage,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: BoxLayout(
        width: width * 0.4,
        height: 45,
        padding: const EdgeInsets.all(0),
        bgColor: AppColor.BLACK,
        borderRadius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: ImageUtils.instance.getImageNetWork(assetImage),
              width: 30,
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tải ứng dụng trên',
                  style: TextStyle(color: AppColor.WHITE, fontSize: 8),
                ),
                Text(
                  text,
                  style: const TextStyle(color: AppColor.WHITE, fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _redirectIfWeb() {
    // Chỉ chạy khi nền tảng là Web
    if (identical(0, 0.0)) {
      html.window.location.href = 'https://api.vietqr.vn';
    }
  }
}
