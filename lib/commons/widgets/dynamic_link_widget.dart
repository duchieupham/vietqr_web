import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/setting_account_sto.dart';
import '../../services/shared_references/session.dart';
import '../../services/shared_references/user_information_helper.dart';
import '../utils/image_utils.dart';
import '../utils/platform_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:html' as html;

class DynamicLinkWidget extends StatefulWidget {
  final String activeKey;
  const DynamicLinkWidget({super.key, required this.activeKey});

  @override
  State<DynamicLinkWidget> createState() => _DynamicLinkWidgetState();
}

class _DynamicLinkWidgetState extends State<DynamicLinkWidget> {
  SettingAccountDTO? accSetting;
  String logoId = 'cde29eed-6f5c-47b6-9f57-3e21b6cf1b96';
  String icPhone = '42634eae-db1f-4ea5-aa32-208fd308bcaf';
  String icMail = '2eb59f59-1cdf-4d69-b0f4-86155d4ce922';

  @override
  void initState() {
    super.initState();
    // getSetting();
  }

  void getSetting() async {
    await Session.instance.getGuideWeb();
    accSetting = UserInformationHelper.instance.getAccountSetting();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.BLUE_TEXT.withOpacity(0.2),
      body: (PlatformUtils.instance.resizeWhen(width, 700))
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Image(
                  image: ImageUtils.instance.getImageNetWork(logoId),
                  width: 100,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Image(
                    image: ImageUtils.instance.getImageNetWork(logoId),
                    width: 100,
                  ),
                  const SizedBox(height: 25),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Truy cập vào ứng dụng\nđể kích hoạt dịch vụ\nphần mềm VietQR',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () async {
                      //scheme vietqrmobile
                      html.window.open(
                          'vietqrmobile:vietqr.vn/service-active/?key=${widget.activeKey ?? ''}',
                          '_self');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.arrow_forward,
                              color: AppColor.BLUE_TEXT, size: 20),
                          Text('Truy cập vào ứng dụng VietQR VN',
                              style: TextStyle(
                                  fontSize: 13, color: AppColor.WHITE)),
                          Icon(Icons.arrow_forward,
                              color: AppColor.WHITE, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 155,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Thông tin liên hệ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Image(
                                image:
                                    ImageUtils.instance.getImageNetWork(icMail),
                                width: 30,
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(width: 10),
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  'Email:',
                                  style: TextStyle(fontSize: 15),
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
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const MySeparator(
                          color: AppColor.GREY_DADADA,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Image(
                                image: ImageUtils.instance
                                    .getImageNetWork(icPhone),
                                width: 30,
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(width: 10),
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  'Hotline:',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: '19006234 ',
                                  );
                                  await launchUrl(launchUri);
                                },
                                child: const Text(
                                  '1900.6234',
                                  style: TextStyle(
                                    color: AppColor.BLUE_TEXT,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                ' - ',
                                style: TextStyle(color: AppColor.BLUE_TEXT),
                              ),
                              InkWell(
                                onTap: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: ' 0922333636',
                                  );
                                  await launchUrl(launchUri);
                                },
                                child: const Text(
                                  '09.2233.3636',
                                  style: TextStyle(
                                    color: AppColor.BLUE_TEXT,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
