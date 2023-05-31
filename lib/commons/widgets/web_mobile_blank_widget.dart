import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/logout/blocs/log_out_bloc.dart';
import 'package:VietQR/features/logout/events/log_out_event.dart';
import 'package:VietQR/features/logout/states/log_out_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebMobileBlankWidget extends StatelessWidget {
  late final LogoutBloc logoutBloc;

  WebMobileBlankWidget({super.key});

  void initialServices(BuildContext context) {
    logoutBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
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
                          Image.asset(
                            'assets/images/logo-vietqr-vn.png',
                            width: 200,
                          ),
                          const Spacer(),
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
                              textColor: DefaultTheme.RED_TEXT,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    const Text(
                      'Quét mã QR để tải ứng dụng VietQR',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    BoxLayout(
                      width: width * 0.5,
                      height: width * 0.5,
                      padding: const EdgeInsets.all(0),
                      enableShadow: true,
                      child: UnconstrainedBox(
                        child: QrImage(
                          data: 'https://onelink.to/q7zwpe',
                          size: width * 0.45,
                          embeddedImage: const AssetImage(
                              'assets/images/ic-viet-qr-small.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(30, 30),
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
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            text: 'App Store',
                            assetImage: 'assets/images/logo-app-store.png',
                            onTap: () {
                              DialogWidget.instance.openMsgDialog(
                                title: 'Đang cập nhật',
                                msg:
                                    'Chúng tôi đang cập nhật ứng dụng VietQR trên iOS',
                              );
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          _buildButton(
                            text: 'Google Play',
                            assetImage: 'assets/images/logo-google-play.png',
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            width: width,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Thông tin liên hệ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Email: ',
                              style: TextStyle(color: DefaultTheme.GREY_TEXT),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'mailto',
                                path: 'sales@vietqr.vn',
                              );
                              await launchUrl(launchUri);
                            },
                            child: const Text(
                              'sales@vietqr.vn',
                              style: TextStyle(
                                color: DefaultTheme.BLUE_TEXT,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Hotline: ',
                              style: TextStyle(color: DefaultTheme.GREY_TEXT),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '19006234',
                              );
                              await launchUrl(launchUri);
                            },
                            child: const Text(
                              '19006234',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/logo-vietqr-vn.png',
                  width: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required String assetImage,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: BoxLayout(
        width: 180,
        height: 45,
        padding: const EdgeInsets.all(0),
        bgColor: DefaultTheme.BLACK,
        borderRadius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetImage,
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
                  style: TextStyle(color: DefaultTheme.WHITE, fontSize: 8),
                ),
                Text(
                  text,
                  style:
                      const TextStyle(color: DefaultTheme.WHITE, fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
