import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/events/qrcode_un_authen_event.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/water_mark_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../commons/widgets/repaint_boundary_widget.dart';
import '../utils/currency_utils.dart';

class QrPrint extends StatefulWidget {
  final Map<String, String> params;
  final bool openPrint;
  const QrPrint({super.key, required this.params, this.openPrint = true});

  @override
  State<QrPrint> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrPrint> {
  Map<String, dynamic> data = {};
  late QRGeneratedDTO qrGeneratedDTO;
  late QRCodeUnUTBloc qrCodeUnUTBloc;
  final GlobalKey globalKey = GlobalKey();
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);
  bool showBgNapas = true;
  String isAuthen = '0';
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    qrGeneratedDTO = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    qrCodeUnUTBloc = BlocProvider.of(context);
    data['bankAccount'] = widget.params['account'] ?? '';
    data['userBankName'] =
        widget.params['name'].toString().replaceAll('_', ' ') ?? '';
    data['bankCode'] = widget.params['bankCode'] ?? '';
    data['amount'] = widget.params['amount'] ?? '0';
    data['content'] =
        widget.params['content'].toString().replaceAll('_', ' ') ?? '';
    data['showBankAccount'] = widget.params['showBankAccount'] ?? '1';
    isAuthen = widget.params['isAuthen'] ?? '0';
    qrCodeUnUTBloc.add(QRCodeUnUTCreateQR(data: data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      body: Padding(
        padding: const EdgeInsets.only(left: 160),
        child: BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
            listener: (context, state) {
          if (state is CreateSuccessfulState) {
            qrGeneratedDTO = state.dto;

            Future.delayed(const Duration(seconds: 2), () {
              if (widget.openPrint) {
                html.window.print();
              }
            });
          }
        }, builder: (context, state) {
          return _buildWidgetQr(state);
        }),
      ),
    );
  }

  Widget _buildWidgetQr(QRCodeUnUTState state) {
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
    return (qrGeneratedDTO.qrCode.isEmpty)
        ? _buildQRCodeBlank(
            'Không thể tạo mã VietQR \n mã ngân hàng không hợp lệ')
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              SizedBox(
                width: 400,
                child: RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return VietQRWidget(
                        qrGeneratedDTO: qrGeneratedDTO,
                        showBankAccount: data['showBankAccount'] == '1',
                      );
                    }),
              ),
              if (qrGeneratedDTO.amount.isNotEmpty &&
                  qrGeneratedDTO.amount != '0') ...[
                const SizedBox(height: 30),
                Text(
                  '+ ${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
                  style: const TextStyle(
                    color: AppColor.ORANGE_DARK,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 400,
                  height: 1,
                  color: AppColor.GREY_DADADA,
                ),
                const SizedBox(height: 30),
                Container(
                  width: 400,
                  height: 45,
                  child: Text(
                    qrGeneratedDTO.content,
                    style: TextStyle(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                Text(
                  'VietQR VN',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              ],
            ],
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
                child: QrImageView(
                  data: 'https://vietqr.vn',
                  size: 250,
                  version: QrVersions.auto,
                  eyeStyle: const QrEyeStyle(
                      color: AppColor.BLACK, eyeShape: QrEyeShape.square),
                  dataModuleStyle: const QrDataModuleStyle(
                      color: AppColor.BLACK,
                      dataModuleShape: QrDataModuleShape.square),
                  embeddedImage: ImageUtils.instance
                      .getImageNetWork(AppImages.icVietQrSmall),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(30, 30),
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
}
