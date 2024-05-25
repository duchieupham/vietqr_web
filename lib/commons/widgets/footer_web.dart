import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/features/bank/blocs/bank_type_bloc.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/bank/events/bank_type_event.dart';
import '../../features/bank/states/bank_type_state.dart';

class FooterWeb extends StatefulWidget {
  final Color? bgColor;
  final bool showListBank;
  const FooterWeb({super.key, this.bgColor, this.showListBank = false});

  @override
  State<FooterWeb> createState() => _FooterWebState();
}

class _FooterWebState extends State<FooterWeb> {
  late BankTypeBloc bankTypeBloc;
  @override
  void initState() {
    super.initState();
    bankTypeBloc = BlocProvider.of(context);
    if (widget.showListBank) {
      bankTypeBloc.add(const BankTypeEventGetListUnauthenticated());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (widget.showListBank) {
      return _buildFooterWidthListBank(width);
    }

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 750) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          color: widget.bgColor ?? AppColor.BLUE_TEXT.withOpacity(0.2),
          child: Column(
            children: [
              BlocBuilder<BankTypeBloc, BankTypeState>(
                  builder: (context, state) {
                if (state is BankTypeGetListSuccessfulState) {
                  return SizedBox(
                    height: 70,
                    width: width,
                    child: CarouselSlider(
                      items: state.list.map(
                        (e) {
                          return Image(
                            image:
                                ImageUtils.instance.getImageNetWork(e.imageId),
                            height: 40,
                          );
                        },
                      ).toList(),
                      options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 0.3,
                          pageSnapping: false,
                          autoPlayCurve: Curves.linear,
                          autoPlayInterval: const Duration(seconds: 2),
                          autoPlayAnimationDuration:
                              const Duration(seconds: 2)),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Liên hệ:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Hotline:   ',
                              style: TextStyle(
                                fontSize: 12,
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
                                '1900.6234',
                                style: TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text('  -  '),
                            InkWell(
                              onTap: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: '0922333636',
                                );
                                await launchUrl(launchUri);
                              },
                              child: const Text(
                                '09.2233.3636',
                                style: TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Email:     ',
                              style: TextStyle(
                                fontSize: 12,
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
                                  color: AppColor.BLUE_TEXT,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildButton(
                          width: 260,
                          text: 'App Store',
                          assetImage: AppImages.logoAppStore,
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildButton(
                          width: 260,
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
                ],
              ),
            ],
          ),
        );
      }
      return Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        color: widget.bgColor ?? AppColor.BLUE_TEXT.withOpacity(0.2),
        child: Row(
          children: [
            const Text(
              'Thông tin liên hệ: ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Text(
              'Email:   ',
              style: TextStyle(
                fontSize: 12,
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
                  color: AppColor.BLUE_TEXT,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 12)),
            const Text(
              'Hotline:   ',
              style: TextStyle(
                fontSize: 12,
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
                '1900.6234',
                style: TextStyle(
                  color: AppColor.BLUE_TEXT,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text('  -  '),
            InkWell(
              onTap: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '0922333636',
                );
                await launchUrl(launchUri);
              },
              child: const Text(
                '09.2233.3636',
                style: TextStyle(
                  color: AppColor.BLUE_TEXT,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Tải ứng dụng trên cửa hàng:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            _buildButton(
              width: 260,
              text: 'App Store',
              assetImage: AppImages.logoAppStore,
              onTap: () async {
                await launchUrl(Uri.parse(
                    'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
              },
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            _buildButton(
              width: 260,
              text: 'Google Play',
              assetImage: AppImages.logoGooglePlay,
              onTap: () async {
                await launchUrl(Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
              },
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildButtonInstallApp() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            width: 260,
            text: 'App Store',
            assetImage: AppImages.logoAppStore,
            onTap: () async {
              await launchUrl(Uri.parse(
                  'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          _buildButton(
            width: 260,
            text: 'Google Play',
            assetImage: AppImages.logoGooglePlay,
            onTap: () async {
              await launchUrl(Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUrlSystem({bool isVertical = false}) {
    if (!isVertical) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hệ thống VietQR VN:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Padding(padding: EdgeInsets.only(top: 25)),
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildItemTitle('vietqr.vn'),
                const SizedBox(
                    height: 12,
                    child: VerticalDivider(
                      color: AppColor.GREY_LIGHT,
                    )),
                _buildItemTitle('vietqr.com'),
                const SizedBox(
                    height: 12,
                    child: VerticalDivider(
                      color: AppColor.GREY_LIGHT,
                    )),
                _buildItemTitle('vietqr.org'),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hệ thống VietQR VN:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 25)),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItemTitle('vietqr.vn'),
              const SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    color: AppColor.GREY_LIGHT,
                  )),
              _buildItemTitle('vietqr.com'),
              const SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    color: AppColor.GREY_LIGHT,
                  )),
              _buildItemTitle('vietqr.org'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemTitle(String text) {
    return GestureDetector(
      onTap: () async {
        await launchUrl(Uri.parse('https://$text'));
      },
      child: Text(
        text,
        style: const TextStyle(
            decoration: TextDecoration.underline, color: AppColor.BLUE_TEXT),
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
        height: 28,
        padding: const EdgeInsets.all(0),
        bgColor: AppColor.BLACK,
        borderRadius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: ImageUtils.instance.getImageNetWork(assetImage),
              width: 18,
              height: 18,
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
                  style: TextStyle(color: AppColor.WHITE, fontSize: 6),
                ),
                Text(
                  text,
                  style: const TextStyle(color: AppColor.WHITE, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFooterWidthListBank(double width) {
    return Container(
      color: AppColor.WHITE,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<BankTypeBloc, BankTypeState>(builder: (context, state) {
            if (state is BankTypeGetListSuccessfulState) {
              return SizedBox(
                height: 44,
                width: width,
                child: CarouselSlider(
                  items: state.list.map(
                    (e) {
                      return Image(
                        image: ImageUtils.instance.getImageNetWork(e.imageId),
                        height: 44,
                      );
                    },
                  ).toList(),
                  options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 0.1,
                      pageSnapping: false,
                      autoPlayCurve: Curves.linear,
                      autoPlayInterval: const Duration(seconds: 2),
                      autoPlayAnimationDuration: const Duration(seconds: 2)),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  const Text(
                    'Thông tin liên hệ: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  const Text(
                    'Email:   ',
                    style: TextStyle(
                      fontSize: 12,
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
                        color: AppColor.BLUE_TEXT,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 12)),
                  const Text(
                    'Hotline:   ',
                    style: TextStyle(
                      fontSize: 12,
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
                      '1900.6234',
                      style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text('  -  '),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '0922333636',
                      );
                      await launchUrl(launchUri);
                    },
                    child: const Text(
                      '09.2233.3636',
                      style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Tải ứng dụng trên cửa hàng:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  _buildButton(
                    width: 280,
                    text: 'App Store',
                    assetImage: AppImages.logoAppStore,
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://apps.apple.com/vn/app/vietqr-vn/id6447118484'));
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  _buildButton(
                    width: 280,
                    text: 'Google Play',
                    assetImage: AppImages.logoGooglePlay,
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.vietqr.product&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26anid%3Dadmob'));
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
