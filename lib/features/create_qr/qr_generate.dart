import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/stringify.dart';
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
import 'package:rive/rive.dart' as rive;

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
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;
  @override
  void initState() {
    Session.instance.updateQRGeneratePage(true);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    super.dispose();
  }

  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, Stringify.SUCCESS_ANI_STATE_MACHINE)!;
    artboard.addController(_riveController);
    _isRiveInit = true;
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_INIT)
            as rive.SMITrigger;
    _action.fire();
  }

  void _doEndAnimation() {
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_END)
            as rive.SMITrigger;
    _action.fire();
  }

  void getData() {
    qrCodeUnUTBloc = BlocProvider.of(context);
    data['token'] = widget.params['token'] ?? '';
    Future.delayed(const Duration(seconds: 1), () {
      WebSocketHelper.instance.listenTransactionQRSocket(data['token'], () {
        setState(() {
          _doEndAnimation();
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
                        if (state is CreateTransactionQRSuccessfulState &&
                            transactionQRdto.bankAccount.isEmpty) {
                          return _buildWidgetTimeExpires();
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
                                          child: _buildWidgetQr(state),
                                        ),
                                        Expanded(child: _buildInfo(false)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Center(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      _buildCountDown(),
                                      _buildWidgetQr(state),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 650, child: _buildInfo(true)),
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
        Image.asset(
          'assets/images/logo-vietqr-vn.png',
          height: 50,
          fit: BoxFit.fitHeight,
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Giao dịch có thời hạn 15 phút',
              style: TextStyle(fontSize: 12),
            ),
            if (!isSuccess) _buildTimeCountDown()
          ],
        ),
      ],
    );
  }

  Widget _buildWidgetQr(QRCodeUnUTState state) {
    if (isSuccess) {
      return _buildTransactionSuccess();
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
                padding: EdgeInsets.only(top: 32, bottom: 20),
                child: Text(
                  'Quyét mã qua ứng dụng Ngân hàng/Ví điện tử',
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
                        pathIcon: 'assets/images/ic-print-blue.png',
                        title: '',
                        function: () async {
                          String paramData = Session.instance
                              .formatDataParamUrl(qrGeneratedDTO,
                                  showBankAccount: 1);
                          html.window.open(
                              Uri.base.toString().replaceFirst('/qr_generate',
                                  '/qr_generate/print$paramData'),
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
                        pathIcon: 'assets/images/ic-edit-avatar-setting.png',
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
                        pathIcon: 'assets/images/ic-copy-blue.png',
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

  Widget _buildInfo(bool isVertical) {
    return Padding(
      padding: isVertical ? EdgeInsets.zero : const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            isVertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _buildCountDown(),
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
                      style: const TextStyle(
                        color: AppColor.ORANGE_Dark,
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
                        _doEndAnimation();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          context.go('/');
                        });
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
                        _doEndAnimation();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                          html.window.history.back();
                        });
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
              'Giao dịch hết hạn sau',
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

  Widget _buildTransactionSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            'Thanh toán thành công',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 160),
          child: SizedBox(
            width: 300,
            height: 150,
            child: rive.RiveAnimation.asset(
              'assets/rives/success_ani.riv',
              fit: BoxFit.fitWidth,
              antialiasing: false,
              animations: const [Stringify.SUCCESS_ANI_INITIAL_STATE],
              onInit: _onRiveInit,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWidgetTimeExpires() {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Image.asset(
          'assets/images/logo-vietqr-vn.png',
          height: 60,
          fit: BoxFit.fitHeight,
        ),
        const DividerWidget(
          width: double.infinity,
        ),
        const Spacer(),
        Image.asset(
          'assets/images/ic-warning.png',
          height: 60,
          fit: BoxFit.fitHeight,
        ),
        const Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
            'Không tìm thấy giao dịch này hoặc giao dịch đã hết hạn thanh toán',
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
    );
  }
}
