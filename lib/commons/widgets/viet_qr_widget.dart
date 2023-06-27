import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VietQRWidget extends StatelessWidget {
  final double width, horizontalInfoWidth;
  final double? height;
  final QRGeneratedDTO qrGeneratedDTO;
  final bool? isStatistic;
  final bool? isCopy;
  final double? qrSize;
  final bool showQROnly;
  final bool horizontalInfo;
  final bool hasBgNapas;
  final bool showBankAccount;
  const VietQRWidget(
      {super.key,
      required this.width,
      required this.qrGeneratedDTO,
      this.height,
      this.isStatistic,
      this.isCopy,
      this.qrSize,
      this.showQROnly = false,
      this.horizontalInfo = false,
      this.horizontalInfoWidth = 500,
      this.hasBgNapas = false,
      this.showBankAccount = true});

  @override
  Widget build(BuildContext context) {
    if (horizontalInfo) {
      return _buildHorizontalInfo();
    }
    if (hasBgNapas) {
      return _buildQRInforWidthBg();
    }
    return (showQROnly)
        ? _buildQR()
        : BoxLayout(
            width: width - 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBankName(),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                DividerWidget(width: width),
                _buildQR(),
                _buildInfoCard()
              ],
            ),
          );
  }

  Widget _buildHorizontalInfo() {
    return SizedBox(
      width: horizontalInfoWidth - 40,
      child: SizedBox(
        child: Row(
          children: [
            _buildQR(),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBankName(),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildInfoCard()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (qrGeneratedDTO.amount.isNotEmpty &&
            qrGeneratedDTO.amount != '0') ...[
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          const Text(
            'Quét mã QR để thanh toán',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          Text(
            '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
            style: const TextStyle(
              color: DefaultTheme.ORANGE,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        DividerWidget(width: width),
        if (showBankAccount) ...[
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          _buildSection(
              title: 'Tài khoản: ', description: qrGeneratedDTO.bankAccount),
        ],
        Padding(padding: EdgeInsets.only(bottom: showBankAccount ? 5 : 20)),
        _buildSection(
          title: 'Chủ thẻ: ',
          description: qrGeneratedDTO.userBankName.toUpperCase(),
          isUnbold: true,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        if (qrGeneratedDTO.content.isNotEmpty) ...[
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          _buildSection(
            title: 'Nội dung: ',
            description: qrGeneratedDTO.content,
            isUnbold: true,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ],
    );
  }

  Widget _buildBankName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: DefaultTheme.WHITE,
            image: (qrGeneratedDTO.imgId.isEmpty)
                ? null
                : DecorationImage(
                    image: ImageUtils.instance
                        .getImageNetWork(qrGeneratedDTO.imgId),
                  ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Expanded(
          child: Text(
            qrGeneratedDTO.bankName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQR() {
    return BoxLayout(
      width: width * 0.7,
      height: width * 0.78,
      enableShadow: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 20),
      bgColor: DefaultTheme.WHITE,
      child: Column(
        children: [
          QrImage(
            data: qrGeneratedDTO.qrCode,
            version: QrVersions.auto,
            size: width * 0.6,
            embeddedImage:
                const AssetImage('assets/images/ic-viet-qr-small.png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: const Size(30, 30),
            ),
          ),
          SizedBox(
            width: width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/ic-viet-qr.png',
                  width: width * 0.22,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.asset(
                    'assets/images/ic-napas247.png',
                    width: width * 0.22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    Color? descColor,
    bool? isUnbold,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: SelectableText(
                description,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: (isUnbold != null && isUnbold)
                      ? FontWeight.normal
                      : FontWeight.w500,
                  color: descColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRInforWidthBg() {
    return BoxLayout(
      width: width - 40,
      bgImage: 'assets/images/bg_napas_qr.png',
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
      borderRadius: 22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBankName(),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          DividerWidget(width: width),
          BoxLayout(
            width: width * 0.7,
            enableShadow: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 20),
            bgColor: DefaultTheme.WHITE,
            child: Column(
              children: [
                QrImage(
                  data: qrGeneratedDTO.qrCode,
                  version: QrVersions.auto,
                  size: width * 0.6,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(30, 30),
                  ),
                ),
                SizedBox(
                  width: width * 0.55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/ic-viet-qr.png',
                        width: width * 0.22,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.asset(
                          'assets/images/ic-napas247.png',
                          width: width * 0.22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8, right: 12),
              child: Text(
                'Tạo bởi VietQR.vn',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: DefaultTheme.BLUE_DARK),
              ),
            ),
          ),
          DividerWidget(width: width),
          if (showBankAccount) ...[
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            _buildSection(
                title: 'Tài khoản: ', description: qrGeneratedDTO.bankAccount),
          ],
          Padding(padding: EdgeInsets.only(bottom: showBankAccount ? 5 : 20)),
          _buildSection(
            title: 'Chủ thẻ: ',
            description: qrGeneratedDTO.userBankName.toUpperCase(),
            isUnbold: true,
          ),
          if (!showBankAccount)
            const SizedBox(
              height: 10,
            ),
        ],
      ),
    );
  }
}
