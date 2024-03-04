// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/dashed_line.dart';
import 'package:VietQR/commons/widgets/repaint_boundary_widget.dart';
import 'package:VietQR/commons/widgets/vietqr_new.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/store_detail_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class QrStoreWidget extends StatefulWidget {
  final StoreDetailDTO dto;

  const QrStoreWidget({super.key, required this.dto});

  @override
  State<QrStoreWidget> createState() => _QrStoreWidgetState();
}

class _QrStoreWidgetState extends State<QrStoreWidget> {
  bool get isMobile => MediaQuery.of(context).size.width < 1000;
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQr(widget.dto.bank),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextButton(
                  title: 'Tạo mã VietQR giao dịch',
                  isMobile: isMobile,
                  onTap: () {
                    context.go('/create-qr/${widget.dto.id}');
                  },
                ),
                _buildTextButton(
                  title: 'Lưu ảnh VietQR',
                  isMobile: isMobile,
                  onTap: () => onSaveImage(context),
                ),
                _buildTextButton(
                  title: 'In mã VietQR',
                  isBorder: false,
                  isMobile: isMobile,
                  onTap: onPrint,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        _buildQr(widget.dto.bank),
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextButton(
                title: 'Tạo mã VietQR giao dịch',
                onTap: () {
                  context.go('/create-qr/${widget.dto.id}');
                },
              ),
              _buildTextButton(
                title: 'Lưu ảnh VietQR',
                onTap: () => onSaveImage(context),
              ),
              _buildTextButton(
                title: 'In mã VietQR',
                isBorder: false,
                onTap: onPrint,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton({
    required String title,
    bool isBorder = true,
    bool isMobile = false,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isMobile ? 300 : 180,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: isBorder
              ? Border(
                  bottom:
                      BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)))
              : null,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.image,
              size: 14,
              color: AppColor.BLUE_TEXT,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: AppColor.BLUE_TEXT, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  void onSaveImage(BuildContext context) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
              webBgColor: 'rgba(255, 255, 255)',
              webPosition: 'center',
            );
          },
        );
      },
    );
  }

  void onPrint() {
    QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
      bankCode: widget.dto.bank.bankCode,
      bankName: widget.dto.bank.bankName,
      bankAccount: widget.dto.bank.bankAccount,
      userBankName: widget.dto.bank.userBankName,
      qrCode: widget.dto.bank.qrCode,
      imgId: widget.dto.bank.imgId,
    );

    String paramData = Session.instance.formatDataParamUrl(
      qrGeneratedDTO,
      action: 'PRINT',
    );
    html.window.open(
        Uri.base.toString().replaceFirst(
            '/enterprise/store/detail', '/qr-generate/print$paramData'),
        'new tab');
  }

  Widget _buildQr(BankAccountDTO bank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          const Text(
            'Mã VietQR cửa hàng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Nhận tiền từ mọi ngân hàng và ví điện tử có hỗ trợ VietQR',
            style: TextStyle(
              color: AppColor.GREY_TEXT,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
                return Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        height: 50,
                        width: 300,
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageUtils.instance.getImageNetWork(
                                        widget.dto.bank.imgId)),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                              child: VerticalDashedLine(),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(bank.bankAccount,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                    Text(bank.bankName,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      VietQrNew(qrCode: bank.qrCode),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
