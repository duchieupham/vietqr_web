import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/bottom_web.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/create_qr/provider/transaction_qr_provider.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/events/qrcode_un_authen_event.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction_qr_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/water_mark_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../commons/utils/image_utils.dart';
import '../../commons/widgets/repaint_boundary_widget.dart';
import '../login/states/qrcode_un_authen_state.dart';

class QrGenerate extends StatefulWidget {
  final Map<String, String> params;
  final bool isAuthen;
  const QrGenerate({super.key, required this.params, this.isAuthen = false});

  @override
  State<QrGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrGenerate> {
  Map<String, dynamic> data = {};
  TransactionQRDTO transactionQRdto = const TransactionQRDTO();
  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO();
  late QRCodeUnUTBloc qrCodeUnUTBloc;
  final GlobalKey globalKey = GlobalKey();
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);
  bool showBgNapas = true;
  int timeCountDown = 0;
  bool isSuccess = false;

  @override
  void initState() {
    Session.instance.updateQRGeneratePage(true);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() {
    qrCodeUnUTBloc = BlocProvider.of(context);
    data['token'] = widget.params['token'] ?? '';
    Future.delayed(const Duration(seconds: 1), () {
      WebSocketHelper.instance.listenTransactionQRSocket(data['token'], () {
        setState(() {
          isSuccess = true;
        });
      });
    });
    qrCodeUnUTBloc.add(GetTransactionQRBytToken(token: data['token']));
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
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.GREY_BG,
      body: ChangeNotifierProvider<TransactionQRProvider>(
        create: (context) => TransactionQRProvider(),
        child: Center(
          child: SizedBox(
            width: 900,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 24, bottom: 40, left: 12, right: 12),
              child: Column(
                children: [
                  _buildButtonBack(),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(12)),
                      child: BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
                          listener: (context, state) {
                        if (state is CreateTransactionQRSuccessfulState) {
                          transactionQRdto = state.dto;
                          qrGeneratedDTO = QRGeneratedDTO(
                            bankAccount: transactionQRdto.bankAccount,
                            bankCode: transactionQRdto.bankCode,
                            bankName: transactionQRdto.bankName,
                            qrCode: transactionQRdto.qr,
                            type: transactionQRdto.type,
                            imgId: transactionQRdto.imgId,
                            content: transactionQRdto.content,
                            userBankName: transactionQRdto.userBankName,
                            amount: transactionQRdto.amount.toString(),
                          );
                          if (transactionQRdto.status == 1) {
                            isSuccess = true;
                          }
                          timeCountDown = DateTime.fromMillisecondsSinceEpoch(
                                      transactionQRdto.timeCreated * 1000)
                                  .add(const Duration(minutes: 15))
                                  .millisecondsSinceEpoch -
                              DateTime.now().millisecondsSinceEpoch;
                          context
                              .read<TransactionQRProvider>()
                              .updateTimeCountDown(timeCountDown);
                        }
                      }, builder: (context, state) {
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

                        if (state is CreateTransactionQRSuccessfulState) {
                          if (state.dto.qr.isEmpty) {
                            return _buildWidgetTimeExpires();
                          }
                        }

                        return Consumer<TransactionQRProvider>(
                            builder: (context, provider, child) {
                          if (provider.timeExpires || timeCountDown <= 0) {
                            return _buildWidgetTimeExpires();
                          }

                          return LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth > 760) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildWidgetQr(state, false),
                                        ),
                                        Expanded(child: _buildInfo(false)),
                                      ],
                                    ),
                                  ),
                                  ButtonIconWidget(
                                    height: 40,
                                    width: 400,
                                    icon: Icons.home_rounded,
                                    title: 'Trang chủ',
                                    textColor: AppColor.WHITE,
                                    bgColor: AppColor.BLUE_TEXT,
                                    function: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        context.go('/');
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 80,
                                  )
                                ],
                              );
                            }
                            return Center(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: _buildCountDown(),
                                  ),
                                  _buildWidgetQr(state, true,
                                      width: widthScreen * 0.7),
                                  SizedBox(
                                      height: 450, child: _buildInfo(true)),
                                ],
                              ),
                            );
                          });
                        });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountDown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image(
          image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
          height: 50,
          fit: BoxFit.fitHeight,
        ),
        const Spacer(),
        if (!isSuccess)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Giao dịch có thời hạn 15 phút',
                style: TextStyle(fontSize: 12),
              ),
              _buildTimeCountDown()
            ],
          ),
      ],
    );
  }

  Widget _buildWidgetQr(QRCodeUnUTState state, bool isVertical,
      {double width = 360}) {
    if (isSuccess) {
      return _buildTransactionSuccess(isVertical);
    }

    return (qrGeneratedDTO.qrCode.isEmpty)
        ? _buildQRCodeBlank(
            'Không thể tạo mã VietQR \n mã ngân hàng không hợp lệ')
        : Column(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 20),
                  child: Text(
                    'Quyét mã qua ứng dụng Ngân hàng/Ví điện tử',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              UnconstrainedBox(
                child: SizedBox(
                  width: width,
                  child: RepaintBoundaryWidget(
                      globalKey: globalKey,
                      builder: (key) {
                        return VietQRWidget(
                          qrGeneratedDTO: qrGeneratedDTO,
                        );
                      }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              UnconstrainedBox(
                child: SizedBox(
                  width: width,
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
              ),
            ],
          );
  }

  Widget _buildInfo(bool isVertical) {
    Color colorAmount = Colors.white;
    if (isSuccess) {
      if (qrGeneratedDTO.type == 0) {
        colorAmount = AppColor.GREEN;
      } else {
        colorAmount = AppColor.BLUE_TEXT;
      }
    } else {
      colorAmount = AppColor.ORANGE_Dark;
    }

    return Padding(
      padding: isVertical
          ? const EdgeInsets.only(bottom: 20)
          : const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            isVertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (!isVertical) _buildCountDown(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Thông tin mã VietQR',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  if (qrGeneratedDTO.amount != '0') ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        'Số tiền thanh toán',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
                      style: TextStyle(
                        color: colorAmount,
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
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    qrGeneratedDTO.bankAccount,
                  ),
                  Text(
                    '${qrGeneratedDTO.bankCode} - ${qrGeneratedDTO.bankName}',
                  ),
                  if (transactionQRdto.orderId.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        'Mã hóa đơn',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      transactionQRdto.orderId,
                    ),
                  ],
                  if (transactionQRdto.terminalCode.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        'Mã điểm bán',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      transactionQRdto.terminalCode,
                    ),
                  ],
                  if (qrGeneratedDTO.content.isNotEmpty) ...[
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
                        Future.delayed(const Duration(milliseconds: 500), () {
                          html.window.history.back();
                        });
                      },
                    ),
                  ],
                  if (isVertical && isSuccess) ...[
                    const Spacer(),
                    ButtonIconWidget(
                      height: 40,
                      icon: Icons.home_rounded,
                      title: 'Trang chủ',
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                      function: () {
                        context.go('/');
                      },
                    ),
                  ]
                ],
              ),
            ),
          )
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

  Widget _buildTimeCountDown() {
    return Consumer<TransactionQRProvider>(builder: (context, provider, child) {
      if (provider.timeCountDown > 0) {
        return Row(
          children: [
            const Text(
              'Hết hạn sau',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              width: 12,
            ),
            TweenAnimationBuilder<Duration>(
                duration: Duration(milliseconds: provider.timeCountDown),
                tween: Tween(
                    begin: Duration(milliseconds: provider.timeCountDown),
                    end: Duration.zero),
                onEnd: () {
                  provider.updateTimeExpires(true);
                },
                builder: (BuildContext context, Duration value, Widget? child) {
                  final minutes = value.inMinutes;
                  final seconds = value.inSeconds % 60;
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColor.BLUE_TEXT.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                                minutes < 10 ? '0$minutes' : minutes.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColor.BLUE_TEXT, fontSize: 14)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              ':',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColor.BLUE_TEXT.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                                seconds < 10 ? '0$seconds' : seconds.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColor.BLUE_TEXT, fontSize: 14)),
                          ),
                        ],
                      ));
                }),
            const SizedBox(
              width: 4,
            ),
            const Text(
              'phút',
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildTransactionSuccess(bool isVertical) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 32, bottom: 20),
          child: Text(
            'Thanh toán thành công',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: isVertical
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(vertical: 60),
          child: SizedBox(
            width: 300,
            height: 300,
            child: Image(
                image: ImageUtils.instance
                    .getImageNetWork(AppImages.iconTransactionSuccess)),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetTimeExpires() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
            height: 60,
            fit: BoxFit.fitHeight,
          ),
          const DividerWidget(
            width: double.infinity,
          ),
          const Spacer(),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.icWarning),
            width: 80,
            height: 80,
          ),
          const Text(
            'Thông báo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
              'Không tìm thấy giao dịch này hoặc giao dịch đã hết hạn thanh toán',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              )),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(40),
            child: ButtonIconWidget(
              width: 400,
              height: 40,
              icon: Icons.home_rounded,
              title: 'Trang chủ',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              function: () {
                context.go('/');
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const BottomWeb()
        ],
      ),
    );
  }
}
