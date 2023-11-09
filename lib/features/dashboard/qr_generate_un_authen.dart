import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/water_mark_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../commons/widgets/repaint_boundary_widget.dart';
import '../login/events/qrcode_un_authen_event.dart';
import '../login/states/qrcode_un_authen_state.dart';

class QrGenerateUnAuthen extends StatefulWidget {
  final Map<String, String> params;
  final bool isAuthen;
  const QrGenerateUnAuthen(
      {super.key, required this.params, this.isAuthen = false});

  @override
  State<QrGenerateUnAuthen> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrGenerateUnAuthen> {
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
    data['bankAccount'] = widget.params['account'] ?? '';
    data['userBankName'] =
        widget.params['name'].toString().replaceAll('_', ' ') ?? '';
    data['bankCode'] = widget.params['bankCode'] ?? '';
    data['amount'] = widget.params['amount'] ?? '0';
    data['content'] =
        widget.params['content'].toString().replaceAll('_', ' ') ?? '';
    data['action'] = widget.params['action'] ?? '';
    data['showBankAccount'] = widget.params['showBankAccount'] ?? '1';

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
      await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
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
    return Scaffold(
      backgroundColor: AppColor.GREY_BG,
      body: Center(
        child: SizedBox(
          width: 1080,
          child: Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 40),
            child: Column(
              children: [
                _buildButtonBack(),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
                      listener: (context, state) {
                    if (state is CreateSuccessfulState) {
                      qrGeneratedDTO = state.dto;
                      if (data['action'] == 'SAVE') {
                        saveImage();
                      }
                      if (data['action'] == 'PRINT') {
                        Future.delayed(const Duration(seconds: 1), () {
                          html.window.print();
                        });
                      }
                    }
                  }, builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Image(
                                    image: ImageUtils.instance.getImageNetWork(
                                        AppImages.logoVietqrVn),
                                    height: 50,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  _buildWidgetQr(state),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: _buildInfo()),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetQr(QRCodeUnUTState state) {
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
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Quét mã qua ứng dụng Ngân hàng/Ví điện tử',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 360,
                child: RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return VietQRWidget(
                        qrGeneratedDTO: qrGeneratedDTO,
                        showBankAccount: data['showBankAccount'] == '1',
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        pathIcon: AppImages.icPrintBlue,
                        title: '',
                        function: () async {
                          String paramData = Session.instance
                              .formatDataParamUrl(qrGeneratedDTO,
                                  showBankAccount: 1);
                          html.window.open(
                              Uri.base.toString().replaceFirst('/qr_generate',
                                  '/qr-generate/print$paramData'),
                              'new tab');
                        },
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        textColor: AppColor.ORANGE,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: ButtonIconWidget(
                        height: 40,
                        pathIcon: AppImages.icEditAvatarSetting,
                        title: '',
                        function: () {
                          saveImage();
                        },
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        textColor: AppColor.RED_CALENDAR,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: ButtonIconWidget(
                        height: 40,
                        pathIcon: AppImages.icCopyBlue,
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
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                        textColor: AppColor.BLUE_TEXT,
                      ),
                    ),
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
            height: 70,
          ),
          const Text(
            'Thông tin mã VietQR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          if (data['amount'] != '0' && data['amount'] != null) ...[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                'Số tiền thanh toán',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
              style: const TextStyle(
                color: AppColor.ORANGE,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Tài khoản nhận',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '${qrGeneratedDTO.bankCode} - ${qrGeneratedDTO.bankName}',
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            qrGeneratedDTO.bankAccount,
          ),
          if (data['content'] != '' && data['content'] != null) ...[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                'Nội dung',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              qrGeneratedDTO.content,
            ),
          ],
          if (widget.isAuthen) ...[
            const Spacer(),
            ButtonIconWidget(
              height: 40,
              icon: Icons.home_rounded,
              title: 'Trang chủ',
              textColor: AppColor.BLUE_TEXT,
              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
              function: () {
                context.go('/');
              },
            ),
            const SizedBox(
              height: 8,
            ),
            ButtonWidget(
              height: 40,
              borderRadius: 5,
              text: 'Tạo mã VietQR khác',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              function: () {
                html.window.history.back();
              },
            ),
          ]
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

  Widget _buildButtonBack() {
    return InkWell(
      onTap: () {
        html.window.history.back();
      },
      child: Row(
        children: const [
          Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Trở về',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
