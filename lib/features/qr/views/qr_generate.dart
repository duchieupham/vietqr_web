import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    data['userBankName'] = Uri.base.queryParameters['name'] ?? '';
    data['bankCode'] = Uri.base.queryParameters['bankCode'] ?? '';
    data['amount'] = Uri.base.queryParameters['amount'] ?? '';
    data['content'] = Uri.base.queryParameters['content'] ?? '';
    qrCodeUnUTBloc.add(QRCodeUnUTCreateQR(data: data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
          listener: (context, state) {
            if (state is CreateSuccessfulState) {
              qrGeneratedDTO = state.dto;
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
                    height: 667,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        width: 0.5,
                      ),
                    ),
                    child: VietQRWidget(
                      width: 500,
                      qrGeneratedDTO: qrGeneratedDTO,
                      amount: data['amount'],
                      content: data['content'],
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
