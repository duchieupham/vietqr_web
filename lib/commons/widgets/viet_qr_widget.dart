import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dashed_line.dart';

class VietQRWidget extends StatelessWidget {
  final double horizontalInfoWidth;
  final double? height;
  final QRGeneratedDTO qrGeneratedDTO;
  final bool? isStatistic;
  final bool? isCopy;
  final double? qrSize;
  final bool showQROnly;
  final bool horizontalInfo;
  final bool showBankAccount;

  const VietQRWidget(
      {super.key,
      required this.qrGeneratedDTO,
      this.height,
      this.isStatistic,
      this.isCopy,
      this.qrSize,
      this.showQROnly = false,
      this.horizontalInfo = false,
      this.horizontalInfoWidth = 500,
      this.showBankAccount = true});

  @override
  Widget build(BuildContext context) {
    if (horizontalInfo) {
      return _buildHorizontalInfo(context);
    }

    return _buildQRInforWidthBg(context);
  }

  Widget _buildHorizontalInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: horizontalInfoWidth - 40,
        child: Row(
          children: [
            _buildQR(context),
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
              color: AppColor.ORANGE,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        const DividerWidget(width: double.infinity),
        SelectableText(
          qrGeneratedDTO.userBankName.toUpperCase(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        SelectableText(
          qrGeneratedDTO.bankAccount,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        if (qrGeneratedDTO.content.isNotEmpty) ...[
          const DividerWidget(width: double.infinity),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          _buildSection(
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
            color: AppColor.WHITE,
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

  Widget _buildQR(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image(
          //   image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
          //   width: 110,
          //   fit: BoxFit.fitWidth,
          // ),
          QrImageView(
            data: qrGeneratedDTO.qrCode,
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
                color: AppColor.BLACK, eyeShape: QrEyeShape.square),
            dataModuleStyle: const QrDataModuleStyle(
                color: AppColor.BLACK,
                dataModuleShape: QrDataModuleShape.square),
            embeddedImage:
                ImageUtils.instance.getImageNetWork(AppImages.icVietQrSmall),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(30, 30),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                  image:
                      ImageUtils.instance.getImageNetWork(AppImages.icNapas247),
                  width: 95,
                  fit: BoxFit.fitWidth),
              Container(
                width: 95,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                  image: (qrGeneratedDTO.imgId.isEmpty)
                      ? null
                      : DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(qrGeneratedDTO.imgId),
                          fit: BoxFit.fitWidth),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String description,
    Color? descColor,
    bool? isUnbold,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
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
    );
  }

  Widget _buildQRInforWidthBg(BuildContext context) {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('assets/images/bg-qr-vqr.png'),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColor.GREY_BG,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(qrGeneratedDTO.imgId),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: VerticalDashedLine(),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              qrGeneratedDTO.bankAccount,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              qrGeneratedDTO.userBankName.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColor.BLACK,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              height: 300,
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 240,
                    height: 240,
                    child: QrImageView(
                      data: qrGeneratedDTO.qrCode,
                      size: 220,
                      version: QrVersions.auto,
                      embeddedImage:
                          const AssetImage('assets/images/ic-viet-qr.png'),
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size(30, 30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Image.asset(
                            "assets/images/ic-viet-qr-code.png",
                            height: 20,
                          ),
                        ),
                        Image.asset(
                          "assets/images/ic-napas247.png",
                          height: 30,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return Container(
    //   decoration: const BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage('assets/images/bg_napas_qr.png'),
    //       fit: BoxFit.fill,
    //     ),
    //   ),
    //   padding: const EdgeInsets.fromLTRB(36, 40, 36, 20),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Container(
    //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(18),
    //           color: AppColor.WHITE,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Theme.of(context).shadowColor.withOpacity(0.3),
    //               spreadRadius: 2,
    //               blurRadius: 2,
    //               offset: const Offset(0, 3),
    //             ),
    //           ],
    //         ),
    //         child: Column(
    //           children: [
    //             // Image(
    //             //   image: ImageUtils.instance
    //             //       .getImageNetWork(AppImages.logoVietqrVn),
    //             //   width: 110,
    //             // ),
    //             QrImage(
    //               data: qrGeneratedDTO.qrCode,
    //               version: QrVersions.auto,
    //               embeddedImage:
    //                   const AssetImage('assets/images/ic-viet-qr.png'),
    //               embeddedImageStyle: QrEmbeddedImageStyle(
    //                 size: const Size(25, 25),
    //               ),
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Image(
    //                     image: ImageUtils.instance
    //                         .getImageNetWork(AppImages.icNapas247),
    //                     width: 85,
    //                     fit: BoxFit.fitWidth),
    //                 Container(
    //                   width: 85,
    //                   height: 20,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5),
    //                     color: AppColor.WHITE,
    //                     image: (qrGeneratedDTO.imgId.isEmpty)
    //                         ? null
    //                         : DecorationImage(
    //                             image: ImageUtils.instance
    //                                 .getImageNetWork(qrGeneratedDTO.imgId),
    //                             fit: BoxFit.fitWidth),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //       _buildInfo()
    //     ],
    //   ),
    // );
  }

  Widget _buildInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 25)),
        if (qrGeneratedDTO.amount.isNotEmpty && qrGeneratedDTO.amount != '0')
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '+ ${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColor.ORANGE_Dark,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        SelectableText(
          qrGeneratedDTO.userBankName.toUpperCase(),
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColor.BLACK),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        SelectableText(
          qrGeneratedDTO.bankAccount,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w900, color: AppColor.BLACK),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        Text(
          qrGeneratedDTO.bankName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: AppColor.BLACK),
        ),
        if (qrGeneratedDTO.content.isNotEmpty) ...[
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            qrGeneratedDTO.content,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
          ),
        ],
      ],
    );
  }
}
