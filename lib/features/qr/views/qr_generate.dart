import 'dart:html';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/water_mark_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../commons/widgets/repaint_boundary_widget.dart';
import '../../login/events/qrcode_un_authen_event.dart';
import '../../login/states/qrcode_un_authen_state.dart';

class QrGenerate extends StatefulWidget {
  const QrGenerate({super.key});

  @override
  State<QrGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrGenerate> {
  Map<String, dynamic> data = {};
  late QRGeneratedDTO qrGeneratedDTO;
  late QRCodeUnUTBloc qrCodeUnUTBloc;
  final GlobalKey globalKey = GlobalKey();
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);
  bool showBgNapas = true;
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
    data['bankAccount'] = Uri.base.queryParameters['account'] ?? '';
    data['userBankName'] =
        Uri.base.queryParameters['name'].toString().replaceAll('_', ' ') ?? '';
    data['bankCode'] = Uri.base.queryParameters['bankCode'] ?? '';
    data['amount'] = Uri.base.queryParameters['amount'] ?? '';
    data['content'] =
        Uri.base.queryParameters['content'].toString().replaceAll('_', ' ') ??
            '';
    data['action'] = Uri.base.queryParameters['action'] ?? '';
    data['showBankAccount'] =
        Uri.base.queryParameters['showBankAccount'] ?? '1';
    qrCodeUnUTBloc.add(QRCodeUnUTCreateQR(data: data));
  }

  saveImage() async {
    String nameFile =
        'VietQR_${data['bankCode']}_${data['userBankName'].replaceAll(' ', '_')}';
    await Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ActionShareProvider>(context, listen: false)
          .updateAction(true);
    });
    _waterMarkProvider.updateWaterMark(true);
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      _waterMarkProvider.updateWaterMark(false);
      await ShareUtils.instance
          .saveImageToGallery(globalKey, nameFile)
          .then((value) {
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
        // Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Material(
        child: BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
          listener: (context, state) {
            if (state is CreateSuccessfulState) {
              qrGeneratedDTO = state.dto;
              if (data['action'] == 'SAVE') {
                saveImage();
              }
              if (data['action'] == 'PRINT') {
                Future.delayed(const Duration(seconds: 1), () {
                  window.print();
                });
              }
            }
          },
          builder: (context, state) {
            if (data['content'].toString().length > 30) {
              return _buildQRCodeBlank(
                  'Không thể tạo mã VietQR \n Nội dung chuyển khoản tối đa 30 ký tự');
            }

            if (state is CreateQRLoadingState) {
              return const UnconstrainedBox(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: DefaultTheme.GREEN,
                  ),
                ),
              );
            }
            return (qrGeneratedDTO.qrCode.isEmpty)
                ? _buildQRCodeBlank(
                    'Không thể tạo mã VietQR \n mã ngân hàng không hợp lệ')
                : Container(
                    height: double.infinity,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RepaintBoundaryWidget(
                            globalKey: globalKey,
                            builder: (key) {
                              return showBgNapas
                                  ? VietQRWidget(
                                      width: 416,
                                      qrGeneratedDTO: qrGeneratedDTO,
                                      hasBgNapas: showBgNapas,
                                      showBankAccount:
                                          data['showBankAccount'] == '1',
                                    )
                                  : VietQRWidget(
                                      width: 500,
                                      qrGeneratedDTO: qrGeneratedDTO,
                                    );
                            }),
                      ],
                    ),
                  );
          },
        ),
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
              bgColor: DefaultTheme.WHITE,
              enableShadow: true,
              padding: const EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.5,
                child: QrImage(
                  data: 'https://vietqr.vn',
                  size: 250,
                  foregroundColor: DefaultTheme.BLACK,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
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
}
