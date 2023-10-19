import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/repaint_boundary_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class InfoDetailBankAccount extends StatelessWidget {
  final RefreshCallback refresh;
  final AccountBankDetailDTO dto;
  final QRGeneratedDTO qrGeneratedDTO;
  final String bankId;
  final GestureTapCallback? onChangePage;

  InfoDetailBankAccount({
    Key? key,
    required this.refresh,
    required this.dto,
    required this.qrGeneratedDTO,
    required this.bankId,
    this.onChangePage,
  }) : super(key: key);

  String get userId => UserInformationHelper.instance.getUserId();

  final globalKey = GlobalKey();

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).cardColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Thông tin tài khoản',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return SizedBox(
                          width: 360,
                          child: VietQRWidget(qrGeneratedDTO: qrGeneratedDTO));
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 28)),
                  SizedBox(
                    width: 360,
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ButtonIconWidget(
                            height: 40,
                            pathIcon: 'assets/images/ic-print-blue.png',
                            title: '',
                            function: () async {
                              String paramData =
                                  Session.instance.formatDataParamUrl(
                                qrGeneratedDTO,
                                action: 'PRINT',
                              );
                              html.window.open(
                                  Uri.base.toString().replaceFirst(
                                      '/home', '/qr_generate/print$paramData'),
                                  'new tab');
                            },
                            textColor: AppColor.BLUE_TEXT,
                            bgColor: AppColor.WHITE.withOpacity(0.4),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Expanded(
                          child: ButtonIconWidget(
                            height: 40,
                            pathIcon:
                                'assets/images/ic-edit-avatar-setting.png',
                            title: '',
                            function: () {
                              String paramData =
                                  Session.instance.formatDataParamUrl(
                                qrGeneratedDTO,
                                action: 'SAVE',
                              );
                              html.window.open(
                                  Uri.base.toString().replaceFirst(
                                      '/home', '/qr_generate$paramData'),
                                  'new tab');
                            },
                            textColor: AppColor.BLUE_TEXT,
                            bgColor: AppColor.WHITE.withOpacity(0.4),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Expanded(
                          child: ButtonIconWidget(
                            height: 40,
                            pathIcon: 'assets/images/ic-copy-blue.png',
                            title: '',
                            function: () async {
                              await FlutterClipboard.copy(ShareUtils.instance
                                      .getTextSharing(qrGeneratedDTO))
                                  .then(
                                (value) => Fluttertoast.showToast(
                                  msg: 'Đã sao chép',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Theme.of(context).cardColor,
                                  textColor: Theme.of(context).hintColor,
                                  fontSize: 15,
                                  webBgColor: 'rgba(255, 255, 255)',
                                  webPosition: 'center',
                                ),
                              );
                            },
                            textColor: AppColor.BLUE_TEXT,
                            bgColor: AppColor.WHITE.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  ButtonIconWidget(
                    width: 360,
                    height: 40,
                    icon: Icons.add_rounded,
                    textSize: 12,
                    title: 'Tạo QR giao dịch',
                    function: () {
                      context.go('/create-qr/${dto.id}');
                    },
                    textColor: AppColor.BLUE_TEXT,
                    bgColor: AppColor.WHITE.withOpacity(0.4),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  ButtonIconWidget(
                    width: 360,
                    height: 40,
                    icon: Icons.info_outline,
                    textSize: 12,
                    title: 'Chi tiết TK ngân hàng',
                    function: () {},
                    textColor: AppColor.BLUE_TEXT,
                    bgColor: AppColor.WHITE.withOpacity(0.4),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}