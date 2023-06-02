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
  final String content;
  final bool? isStatistic;
  final bool? isCopy;
  final double? qrSize;
  final bool showQROnly;
  final bool horizontalInfo;

  const VietQRWidget(
      {super.key,
      required this.width,
      required this.qrGeneratedDTO,
      required this.content,
      this.height,
      this.isStatistic,
      this.isCopy,
      this.qrSize,
      this.showQROnly = false,
      this.horizontalInfo = false,
      this.horizontalInfoWidth = 500});

  @override
  Widget build(BuildContext context) {
    if (horizontalInfo) {
      return _buildHorizontalInfo();
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
                // DividerWidget(width: width),
                // const Padding(padding: EdgeInsets.only(bottom: 10)),
                // _buildSection(
                //     title: 'Tài khoản: ', description: qrGeneratedDTO.bankAccount),
                // const Padding(padding: EdgeInsets.only(bottom: 5)),
                // _buildSection(
                //     title: 'Chủ thẻ: ',
                //     description: qrGeneratedDTO.userBankName.toUpperCase()),
                // const Padding(padding: EdgeInsets.only(bottom: 10)),
                // if (qrGeneratedDTO.amount.isNotEmpty &&
                //     qrGeneratedDTO.amount != '0') ...[
                //   DividerWidget(width: width),
                //   const Padding(padding: EdgeInsets.only(bottom: 10)),
                //   _buildSection(
                //     title: 'Số tiền: ',
                //     description:
                //         '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
                //     descColor: DefaultTheme.GREEN,
                //   ),
                // ],
                // if (qrGeneratedDTO.content.isNotEmpty) ...[
                //   const Padding(padding: EdgeInsets.only(bottom: 10)),
                //   _buildSection(
                //     title: 'Nội dung: ',
                //     description: qrGeneratedDTO.content,
                //     isUnbold: true,
                //   ),
                //   const Padding(padding: EdgeInsets.only(bottom: 10)),
                // ],
                _buildInfoCard()
              ],
            ),
          );
  }

  Widget _buildHorizontalInfo() {
    return SizedBox(
      width: horizontalInfoWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        _buildSection(
            title: 'Tài khoản: ', description: qrGeneratedDTO.bankAccount),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
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
}
