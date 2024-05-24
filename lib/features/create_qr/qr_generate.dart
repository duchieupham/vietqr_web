import 'dart:async';
import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_type_bloc.dart';
import 'package:VietQR/features/bank/states/bank_type_state.dart';
import 'package:VietQR/features/create_qr/provider/transaction_qr_provider.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/events/qrcode_un_authen_event.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction_qr_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/water_mark_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../commons/utils/image_utils.dart';
import '../../commons/widgets/button/m_button_icon_widget.dart';
import '../../commons/widgets/dashed_line.dart';
import '../../commons/widgets/repaint_boundary_widget.dart';
import '../bank/events/bank_type_event.dart';
import '../login/states/qrcode_un_authen_state.dart';

class QrGenerate extends StatelessWidget {
  final Map<String, String> params;
  final bool isAuthen;
  final bool isDev;

  const QrGenerate(
      {super.key,
      required this.params,
      required this.isAuthen,
      this.isDev = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionQRProvider>(
      create: (context) => TransactionQRProvider(),
      child: _QrGenerate(
        params: params,
        isAuthen: isAuthen,
        isDev: isDev,
      ),
    );
  }
}

class _QrGenerate extends StatefulWidget {
  final Map<String, String> params;
  final bool isAuthen;
  final bool isDev;

  const _QrGenerate(
      {super.key,
      required this.params,
      this.isAuthen = false,
      this.isDev = false});

  @override
  State<_QrGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<_QrGenerate> {
  Map<String, dynamic> data = {};
  TransactionQRDTO transactionQRdto = const TransactionQRDTO();
  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO();
  late BankTypeBloc bankTypeBloc;
  late QRCodeUnUTBloc qrCodeUnUTBloc;
  final GlobalKey globalKey = GlobalKey();
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);
  bool showBgNapas = true;
  int timeCountDown = 0;
  bool isSuccess = false;
  late ValueNotifier<int> _valueNotifier;

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
    _valueNotifier = ValueNotifier<int>(3);
    _valueNotifier.value = 3;
    bankTypeBloc = BlocProvider.of(context);
    qrCodeUnUTBloc = BlocProvider.of(context);
    bankTypeBloc.add(const BankTypeEventGetListUnauthenticated());
    data['token'] = widget.params['token'] ?? '';
    qrCodeUnUTBloc.add(GetTransactionQRBytToken(token: data['token']));
    Future.delayed(const Duration(seconds: 1), () {
      WebSocketHelper.instance.listenTransactionQRSocket(data['token'], (data) {
        Provider.of<TransactionQRProvider>(context, listen: false)
            .redirectUrl(data['urlLink']);
        setState(() {
          isSuccess = true;
        });
      }, () {
        Provider.of<TransactionQRProvider>(context, listen: false)
            .updateTimeExpires(true);
      });
    });
  }

  saveImage() async {
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
      backgroundColor: AppColor.BLUE_BGR,
      body: Center(
        child: SizedBox(
          width: 1200,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.WHITE,
            ),
            padding: const EdgeInsets.only(top: 16),
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
              if (state is CancelQRSuccessState) {
                html.window.close();
              }
            }, builder: (context, state) {
              if (state is CreateQRLoadingState) {
                return Column(
                  children: [
                    _buildCountDown(),
                    const SizedBox(
                      height: 8,
                    ),
                    DividerWidget(
                      width: double.infinity,
                      color: AppColor.GREY_BUTTON.withOpacity(0.8),
                    ),
                    const Expanded(
                      child: UnconstrainedBox(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                if (provider.isRedirect) {
                  Timer.periodic(const Duration(seconds: 1), (timer) {
                    if (_valueNotifier.value > 0) {
                      _valueNotifier.value--;
                    } else {
                      timer.cancel();
                      html.window.location.href = provider.url;
                    }
                  });
                }

                return LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth > 760) {
                    return Column(
                      children: [
                        _buildCountDown(),
                        const SizedBox(
                          height: 8,
                        ),
                        DividerWidget(
                          width: double.infinity,
                          color: AppColor.GREY_BUTTON.withOpacity(0.8),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildWidgetQr(
                                          state, false, constraints.maxWidth,
                                          width: 350),
                                    ),
                                    Expanded(child: _buildInfo(false)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                provider.isRedirect
                                    ? ValueListenableBuilder(
                                        valueListenable: _valueNotifier,
                                        builder: (context, value, child) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                  'Hệ thống tự điều hướng sau: '),
                                              Text(
                                                value.toString(),
                                                style: const TextStyle(
                                                    color: AppColor.BLUE_TEXT,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text('giây'),
                                            ],
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                // const SizedBox(height: 20),
                                // _buildListBank(),
                                // DividerWidget(
                                //   width: double.infinity,
                                //   color: AppColor.GREY_BUTTON.withOpacity(0.8),
                                // ),
                                // const Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 12),
                                //   child: FooterWeb(
                                //     showListBank: true,
                                //     bgColor: AppColor.WHITE,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // _buildListBank(),
                        DividerWidget(
                          width: double.infinity,
                          color: AppColor.GREY_BUTTON.withOpacity(0.8),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: FooterWeb(
                            showListBank: true,
                            bgColor: AppColor.WHITE,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Column(
                      children: [
                        _buildCountDown(),
                        const SizedBox(
                          height: 8,
                        ),
                        const DividerWidget(
                          width: double.infinity,
                          color: AppColor.GREY_DADADA,
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _buildWidgetQr(state, true, constraints.maxWidth,
                                  width: widthScreen * 0.9),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: _buildQrLink(),
                              ),
                              const SizedBox(height: 20),
                              const DividerWidget(
                                width: double.infinity,
                                color: AppColor.GREY_DADADA,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: FooterWeb(
                                  bgColor: AppColor.WHITE,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
              });
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCountDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
            height: 50,
            fit: BoxFit.fitHeight,
          ),
          // if (transactionQRdto.merchant.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 20),
          //     child: Text(
          //       transactionQRdto.merchant,
          //       style: const TextStyle(fontSize: 18),
          //     ),
          //   ),
          const Spacer(),
          if (!isSuccess) _buildTimeCountDown()
        ],
      ),
    );
  }

  Widget _buildWidgetQr(QRCodeUnUTState state, bool isVertical, double maxWidth,
      {double width = 360}) {
    if (isSuccess) {
      return _buildTransactionSuccess(isVertical);
    }

    if ((qrGeneratedDTO.qrCode.isEmpty)) {
      return _buildQRCodeBlank(
          'Không thể tạo mã VietQR \n mã ngân hàng không hợp lệ');
    } else {
      return Column(
        children: [
          if (!isVertical)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 32, bottom: 20),
                child: Text(
                  'Quét mã qua ứng dụng Ngân hàng/Ví điện tử',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            const SizedBox(height: 20),
          RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(
                                              qrGeneratedDTO.imgId),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          qrGeneratedDTO.bankAccount,
                                          // 'widget.qrGeneratedDTO.bankAccount,',
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: AppColor.BLACK,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          // 'widget.qrGeneratedDTO.userBankName'
                                          //     .toUpperCase(),
                                          qrGeneratedDTO.userBankName
                                              .toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
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
                                child: QrImage(
                                  data: qrGeneratedDTO.qrCode,
                                  size: 220,
                                  version: QrVersions.auto,
                                  embeddedImage: const AssetImage(
                                      'assets/images/ic-viet-qr.png'),
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: const Size(30, 30),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
              }),
          if (qrGeneratedDTO.amount.isNotEmpty &&
              qrGeneratedDTO.amount != '0') ...[
            const SizedBox(height: 10),
            Text(
              '+ ${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
              style: const TextStyle(
                color: AppColor.ORANGE_DARK,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width,
              height: 1,
              color: AppColor.GREY_DADADA,
            ),
            const SizedBox(height: 10),
            Container(
              width: width,
              height: 45,
              child: Text(
                qrGeneratedDTO.content,
                style: TextStyle(fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
          // const SizedBox(height: 10),
          // Container(
          //   height: 50,
          //   width: width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Tooltip(
          //         message: '',
          //         child: MButtonIconWidget(
          //           height: 50,
          //           width: width / 2 - 10,
          //           icon: Icons.image_outlined,
          //           iconSize: 15,
          //           textSize: 15,
          //           iconColor: AppColor.BLUE_TEXT,
          //           title: 'Lưu ảnh VietQR',
          //           onTap: () {
          //             saveImage();
          //           },
          //           border: Border.all(color: AppColor.BLUE_TEXT),
          //           bgColor: AppColor.WHITE,
          //           textColor: AppColor.BLUE_TEXT,
          //         ),
          //       ),
          //       Tooltip(
          //         message: '',
          //         child: MButtonIconWidget(
          //           height: 50,
          //           width: width / 2 - 10,
          //           icon: Icons.print_outlined,
          //           iconSize: 15,
          //           textSize: 15,
          //           iconColor: AppColor.BLUE_TEXT,
          //           title: 'In mã VietQR',
          //           onTap: () async {
          //             String paramData = Session.instance.formatDataParamUrl(
          //                 qrGeneratedDTO,
          //                 showBankAccount: 1);
          //             html.window.open(
          //                 Uri.base.toString().replaceFirst(
          //                     '/qr-generate', '/qr-generate/print$paramData'),
          //                 'new tab');
          //           },
          //           border: Border.all(color: AppColor.BLUE_TEXT),
          //           bgColor: AppColor.WHITE,
          //           textColor: AppColor.BLUE_TEXT,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (maxWidth > 760) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: '',
                            child: MButtonIconWidget(
                              height: 50,
                              width: width / 2 - 10,
                              icon: Icons.image_outlined,
                              iconSize: 15,
                              textSize: 15,
                              iconColor: AppColor.BLUE_TEXT,
                              title: 'Lưu ảnh VietQR',
                              onTap: () {
                                saveImage();
                              },
                              border: Border.all(color: AppColor.BLUE_TEXT),
                              bgColor: AppColor.WHITE,
                              textColor: AppColor.BLUE_TEXT,
                            ),
                          ),
                          Tooltip(
                            message: '',
                            child: MButtonIconWidget(
                              height: 50,
                              width: width / 2 - 10,
                              icon: Icons.print_outlined,
                              iconSize: 15,
                              textSize: 15,
                              iconColor: AppColor.BLUE_TEXT,
                              title: 'In mã VietQR',
                              onTap: () async {
                                String paramData = Session.instance
                                    .formatDataParamUrl(qrGeneratedDTO,
                                        showBankAccount: 1);
                                html.window.open(
                                    Uri.base.toString().replaceFirst(
                                        '/qr-generate',
                                        '/qr-generate/print$paramData'),
                                    'new tab');
                              },
                              border: Border.all(color: AppColor.BLUE_TEXT),
                              bgColor: AppColor.WHITE,
                              textColor: AppColor.BLUE_TEXT,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 70,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Tooltip(
                        message: '',
                        child: MButtonIconWidget(
                          height: 50,
                          width: width / 3 - 10,
                          icon: Icons.image_outlined,
                          iconSize: 12,
                          textSize: 12,
                          iconColor: AppColor.BLUE_TEXT,
                          title: 'Sao chép',
                          onTap: () async {
                            await FlutterClipboard.copy(
                                    qrGeneratedDTO.bankAccount)
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
                          border: Border.all(color: AppColor.BLUE_TEXT),
                          bgColor: AppColor.WHITE,
                          textColor: AppColor.BLUE_TEXT,
                        ),
                      ),
                      Tooltip(
                        message: '',
                        child: MButtonIconWidget(
                          height: 50,
                          width: width / 3 - 10,
                          icon: Icons.image_outlined,
                          iconSize: 12,
                          textSize: 12,
                          iconColor: AppColor.BLUE_TEXT,
                          title: 'Lưu ảnh',
                          onTap: () {
                            saveImage();
                          },
                          border: Border.all(color: AppColor.BLUE_TEXT),
                          bgColor: AppColor.WHITE,
                          textColor: AppColor.BLUE_TEXT,
                        ),
                      ),
                      Tooltip(
                        message: '',
                        child: MButtonIconWidget(
                          height: 50,
                          width: width / 3 - 10,
                          icon: Icons.print_outlined,
                          iconSize: 12,
                          textSize: 12,
                          iconColor: AppColor.BLUE_TEXT,
                          title: 'In QR',
                          onTap: () async {
                            String paramData = Session.instance
                                .formatDataParamUrl(qrGeneratedDTO,
                                    showBankAccount: 1);
                            html.window.open(
                                Uri.base.toString().replaceFirst('/qr-generate',
                                    '/qr-generate/print$paramData'),
                                'new tab');
                          },
                          border: Border.all(color: AppColor.BLUE_TEXT),
                          bgColor: AppColor.WHITE,
                          textColor: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: width,
            child: ButtonWidget(
              height: 50,
              text: 'Huỷ thanh toán',
              function: () async {
                qrCodeUnUTBloc.add(QRGenerateCancelEvent(data['token']));
              },
              bgColor: AppColor.GREY_BUTTON.withOpacity(0.5),
              borderRadius: 4,
              textColor: AppColor.BLACK,
              textSize: 15,
            ),
          ),
        ],
      );
    }
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

    return Container(
      padding: isVertical
          ? const EdgeInsets.only(bottom: 20)
          : const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Thông tin đơn hàng',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 30),
          _buildItemData(
              'Số tiền thanh toán',
              '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
              FontWeight.bold,
              AppColor.ORANGE_DARK),
          _buildItemData(
              'Tài khoản nhận',
              '${qrGeneratedDTO.bankCode} - ${qrGeneratedDTO.bankAccount}',
              FontWeight.normal,
              AppColor.BLACK),
          _buildItemData('Chủ tài khoản', qrGeneratedDTO.userBankName,
              FontWeight.normal, AppColor.BLACK),

          _buildItemData('Nhà cung cấp', transactionQRdto.merchant,
              FontWeight.normal, AppColor.BLACK),

          _buildItemData('Mã đơn hàng', transactionQRdto.orderId,
              FontWeight.normal, AppColor.BLACK),

          _buildItemData('Mã điểm bán', transactionQRdto.terminalCode,
              FontWeight.normal, AppColor.BLACK),
          _buildItemData('Nội dung thanh toán', qrGeneratedDTO.content,
              FontWeight.normal, AppColor.BLACK),
          const SizedBox(height: 30),
          _buildQrLink(),
          // const Text(
          //   'QR Link to Pay:',
          //   style: TextStyle(fontSize: 18),
          // ),
          // const SizedBox(height: 10),
          // Container(
          //   height: 50,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: AppColor.GREY_DADADA),
          //     color: AppColor.BLUE_BGR,
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Text(
          //           Uri.base.toString(),
          //           style: TextStyle(color: AppColor.BLUE_TEXT, fontSize: 18),
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //       InkWell(
          // onTap: () async {
          //   await FlutterClipboard.copy(Uri.base.toString()).then(
          //     (value) => Fluttertoast.showToast(
          //       msg: 'Đã sao chép',
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.CENTER,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Theme.of(context).cardColor,
          //       textColor: Theme.of(context).hintColor,
          //       fontSize: 15,
          //       webBgColor: 'rgba(255, 255, 255)',
          //       webPosition: 'center',
          //     ),
          //   );
          // },
          //         child: Tooltip(
          //           message: 'Sao chép',
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 18),
          //             child: const Icon(
          //               Icons.file_copy_outlined,
          //               color: AppColor.BLUE_TEXT,
          //               size: 18,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // if (qrGeneratedDTO.amount != '0') ...[
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20, bottom: 8),
          //     child: Text(
          //       'Số tiền thanh toán',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   Text(
          //     '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
          //     style: TextStyle(
          //       color: colorAmount,
          //       fontSize: 20,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ],
          // const Padding(
          //   padding: EdgeInsets.only(top: 20, bottom: 8),
          //   child: Text(
          //     'Tài khoản nhận',
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),
          // const SizedBox(
          //   height: 4,
          // ),
          // Text(
          //   qrGeneratedDTO.bankAccount,
          // ),
          // Text(
          //   '${qrGeneratedDTO.bankCode} - ${qrGeneratedDTO.bankName}',
          // ),
          // if (transactionQRdto.orderId.isNotEmpty) ...[
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20, bottom: 8),
          //     child: Text(
          //       'Nhà cung cấp',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   Text(
          //     transactionQRdto.merchant,
          //   ),
          // ],
          // if (transactionQRdto.orderId.isNotEmpty) ...[
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20, bottom: 8),
          //     child: Text(
          //       'Mã hóa đơn',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   Text(
          //     transactionQRdto.orderId,
          //   ),
          // ],
          // if (transactionQRdto.terminalCode.isNotEmpty) ...[
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20, bottom: 8),
          //     child: Text(
          //       'Mã điểm bán',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   Text(
          //     transactionQRdto.terminalCode,
          //   ),
          // ],
          // if (qrGeneratedDTO.content.isNotEmpty) ...[
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20, bottom: 8),
          //     child: Text(
          //       'Nội dung',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   Text(
          //     qrGeneratedDTO.content,
          //   ),
          // ],
          // const SizedBox(
          //   height: 28,
          // ),
          // _buildRowButton()
        ],
      ),
    );
  }

  Widget _buildQrLink() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QR Link to Pay:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.GREY_DADADA),
            color: AppColor.BLUE_BGR,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  Uri.base.toString(),
                  style: TextStyle(color: AppColor.BLUE_TEXT, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () async {
                  await FlutterClipboard.copy(Uri.base.toString()).then(
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
                child: Tooltip(
                  message: 'Sao chép',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: const Icon(
                      Icons.file_copy_outlined,
                      color: AppColor.BLUE_TEXT,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildTimeCountDown() {
    return Consumer<TransactionQRProvider>(builder: (context, provider, child) {
      if (provider.timeCountDown > 0) {
        return Row(
          children: [
            Row(
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
                    builder:
                        (BuildContext context, Duration value, Widget? child) {
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
                                    minutes < 10
                                        ? '0$minutes'
                                        : minutes.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColor.BLUE_TEXT,
                                        fontSize: 14)),
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
                                    seconds < 10
                                        ? '0$seconds'
                                        : seconds.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColor.BLUE_TEXT,
                                        fontSize: 14)),
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
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildItemData(String leftText, String rightText, FontWeight rightFont,
      Color rightColor) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  leftText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(
                  rightText.isNotEmpty ? rightText : "-",
                  style: TextStyle(
                    color: rightColor,
                    fontWeight: rightFont,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
      ],
    );
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
                    .getImageNetWork(AppImages.icSuccessGreen)),
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
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  Widget _buildRowButton() {
    return Row(
      children: [
        _buildButtonText(() async {
          await FlutterClipboard.copy(Uri.base.toString()).then(
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
        }, Alignment.centerLeft, 'Sao chép Link to Pay'),
        const Spacer(),
        _buildButtonText(() {}, Alignment.centerRight, 'Hướng dẫn thanh toán'),
      ],
    );
  }

  Widget _buildButtonText(
      VoidCallback onTap, Alignment alignmentIcon, String text) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (alignmentIcon == Alignment.centerLeft) ...[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColor.BLUE_TEXT)),
              child: const Icon(
                Icons.link,
                color: AppColor.BLUE_TEXT,
                size: 12,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
          ],
          Text(
            text,
            style: const TextStyle(
                fontSize: 12,
                decoration: TextDecoration.underline,
                color: AppColor.BLUE_TEXT),
          ),
          if (alignmentIcon == Alignment.centerRight) ...[
            const SizedBox(
              width: 4,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColor.BLUE_TEXT)),
              child: const Icon(
                Icons.question_mark,
                color: AppColor.BLUE_TEXT,
                size: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListBank({bool forMobile = false}) {
    return BlocBuilder<BankTypeBloc, BankTypeState>(builder: (context, state) {
      if (state is BankTypeGetListSuccessfulState) {
        if (forMobile) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                const Text(
                  'Danh sách ngân hàng hỗ trợ thanh toán ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildFooterWidthListBank(double.infinity, state.list),
              ],
            ),
          );
        }

        return SizedBox(
            width: 960,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Danh sách ngân hàng hỗ trợ thanh toán ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: state.list.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.GREY_BUTTON)),
                        child: Image(
                          image: ImageUtils.instance.getImageNetWork(e.imageId),
                          height: 32,
                          width: 90,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ));
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildFooterWidthListBank(double width, List<BankTypeDTO> list) {
    return Container(
      color: AppColor.WHITE,
      child: Column(
        children: [
          if (list.isNotEmpty)
            SizedBox(
              height: 44,
              width: width,
              child: CarouselSlider(
                items: list.map(
                  (e) {
                    return Image(
                      image: ImageUtils.instance.getImageNetWork(e.imageId),
                      height: 44,
                    );
                  },
                ).toList(),
                options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 0.2,
                    pageSnapping: false,
                    autoPlayCurve: Curves.linear,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(seconds: 2)),
              ),
            )
          else
            const SizedBox.shrink(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
