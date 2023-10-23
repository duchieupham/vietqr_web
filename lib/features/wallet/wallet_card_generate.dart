import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/contact_detail_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../login/states/qrcode_un_authen_state.dart';
import 'blocs/wallet_qr_bloc.dart';
import 'events/wallet_event.dart';
import 'states/wallet_state.dart';

class QrCardGenerate extends StatefulWidget {
  final Map<String, String> params;
  const QrCardGenerate({super.key, required this.params});

  @override
  State<QrCardGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrCardGenerate> {
  Map<String, dynamic> data = {};

  late WalletBloc bloc;
  ContactDetailDTO contactDetailDTO = ContactDetailDTO();
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    String id = widget.params['id'] ?? '';
    bloc = WalletBloc()..add(ContactEventGetDetail(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: AppColor.GREY_BG,
        body: Center(
          child: SizedBox(
            width: 1080,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 40),
              child: BlocConsumer<WalletBloc, ContactState>(
                  listener: (context, state) {
                if (state is GetDetailContactSuccessState) {
                  contactDetailDTO = state.dto;
                }
              }, builder: (context, state) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildWidgetQr(state),
                      ),
                      Expanded(child: _buildInfo()),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetQr(ContactState state) {
    if (state is CreateQRLoadingState) {
      return const UnconstrainedBox(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: AppColor.BLUE_TEXT,
          ),
        ),
      );
    }
    return (contactDetailDTO.id.isEmpty)
        ? _buildQRCodeBlank('Không thể hiển thị thông tin \n mã id không đúng')
        : _buildViewCard();
  }

  Widget _buildViewCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Image(
          image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
          height: 50,
          fit: BoxFit.fitHeight,
        ),
        Container(
          width: 400,
          decoration: BoxDecoration(
              gradient: contactDetailDTO.getBgGradient(),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.only(top: 16),
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: getImage(
                            contactDetailDTO.type, contactDetailDTO.imgId),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactDetailDTO.nickname,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.BLACK),
                        ),
                        Text(
                          contactDetailDTO.type == 1
                              ? 'VietQR ID'
                              : contactDetailDTO.type == 4
                                  ? 'VCard'
                                  : 'Thẻ khác',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColor.BLACK,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(thickness: 1, color: AppColor.WHITE),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 80, right: 80, top: 20),
                decoration: const BoxDecoration(color: AppColor.WHITE),
                child: Stack(
                  children: [
                    QrImage(
                      data: contactDetailDTO.value,
                      version: QrVersions.auto,
                      size: 240,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius: BorderRadius.circular(40),
                            image: getImage(
                                contactDetailDTO.type, contactDetailDTO.imgId),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  contactDetailDTO.nickname,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.WHITE),
                ),
              ),
              const SizedBox(height: 4),
              const Divider(thickness: 1, color: AppColor.WHITE),
              _buildItem('Số điện thoại', contactDetailDTO.phoneNo),
              const Divider(thickness: 1, color: AppColor.WHITE),
              _buildItem(
                  'Email',
                  contactDetailDTO.email.isNotEmpty
                      ? contactDetailDTO.email
                      : '-'),
              const Divider(thickness: 1, color: AppColor.WHITE),
              _buildItem(
                  'Ghi chú',
                  contactDetailDTO.additionalData.isNotEmpty
                      ? contactDetailDTO.additionalData
                      : '-'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 90,
          ),
          const Text(
            'Thông tin mã VietQR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Tên thẻ QR',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            contactDetailDTO.nickname,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Số điện thoại',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            contactDetailDTO.phoneNo,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            contactDetailDTO.email.isNotEmpty ? contactDetailDTO.email : '-',
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Ghi chú',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            contactDetailDTO.additionalData.isNotEmpty
                ? contactDetailDTO.additionalData
                : '-',
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Loại QR',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            contactDetailDTO.type == 1
                ? 'VietQR ID'
                : contactDetailDTO.type == 4
                    ? 'VCard'
                    : 'Thẻ khác',
            style: const TextStyle(
              color: AppColor.BLACK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String content,
      {GestureTapCallback? onTap, TextStyle? style}) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: height < 750 ? 2 : 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(
                color: AppColor.WHITE,
                fontSize: height < 750 ? 12 : 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                content,
                style: style ??
                    TextStyle(
                      color: AppColor.WHITE,
                      fontSize: height < 750 ? 12 : 14,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeBlank(String err) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BoxLayout(
              width: 300,
              height: 300,
              bgColor: AppColor.WHITE,
              enableShadow: true,
              padding: const EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.5,
                child: QrImage(
                  data: 'https://vietqr.vn',
                  size: 250,
                  foregroundColor: AppColor.BLACK,
                  embeddedImage: ImageUtils.instance
                      .getImageNetWork(AppImages.icVietQrSmall),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(30, 30),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              err,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  DecorationImage getImage(int type, String imageId) {
    if (imageId.isNotEmpty) {
      return DecorationImage(
          image: ImageUtils.instance.getImageNetWork(imageId),
          fit: type == 2 ? BoxFit.contain : BoxFit.cover);
    } else {
      if (type != 1) {
        return DecorationImage(
            image: ImageUtils.instance.getImageNetWork(AppImages.icTbQr),
            fit: BoxFit.contain);
      } else {
        return DecorationImage(
            image: ImageUtils.instance.getImageNetWork(AppImages.icVietQrSmall),
            fit: BoxFit.contain);
      }
    }
  }
}
