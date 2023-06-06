import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/repaint_boundary_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/qr_recreate_dto.dart';
import 'package:VietQR/models/transaction_receive_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailView extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();
  static late TransactionBloc transactionBloc;
  static TransactionReceiveDTO dto = const TransactionReceiveDTO(
    time: 0,
    status: 0,
    id: '',
    type: 0,
    content: '',
    bankAccount: '',
    bankAccountName: '',
    bankId: '',
    bankCode: '',
    bankName: '',
    imgId: '',
    amount: 0,
    transType: '',
    traceId: '',
    refId: '',
    referenceNumber: '',
  );

  TransactionDetailView(
      {super.key, required this.transactionId, this.width = 450});
  final String transactionId;
  final double width;
  Future<void> _refresh(String transactionId) async {
    transactionBloc.add(TransactionEventGetDetail(id: transactionId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc()
            ..add(TransactionEventGetDetail(id: transactionId)),
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              dto = const TransactionReceiveDTO(
                time: 0,
                status: 0,
                id: '',
                type: 0,
                content: '',
                bankAccount: '',
                bankAccountName: '',
                bankId: '',
                bankCode: '',
                bankName: '',
                imgId: '',
                amount: 0,
                transType: '',
                traceId: '',
                refId: '',
                referenceNumber: '',
              );
              if (state is TransactionDetailSuccessState) {
                dto = state.dto;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _refresh(transactionId);
                      },
                      child: Visibility(
                        visible: dto.id.isNotEmpty,
                        child: RepaintBoundaryWidget(
                          globalKey: globalKey,
                          builder: (key) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      margin: const EdgeInsets.only(
                                          top: 8, right: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context).cardColor),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                Center(
                                  child: Text(
                                    '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount.toString())} VND',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: TransactionUtils.instance
                                          .getColorStatus(
                                        dto.status,
                                        dto.type,
                                        dto.transType,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                Center(
                                  child: Text(
                                    TransactionUtils.instance
                                        .getStatusString(dto.status),
                                    style: TextStyle(
                                      color: TransactionUtils.instance
                                          .getColorStatus(
                                        dto.status,
                                        dto.type,
                                        dto.transType,
                                      ),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 40)),
                                UnconstrainedBox(
                                  child: BoxLayout(
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        Text(
                                          TransactionUtils.instance
                                              .getPrefixBankAccount(
                                                  dto.transType),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: DefaultTheme.GREY_TEXT,
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${dto.bankCode} - ${dto.bankName}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: DefaultTheme.WHITE,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width: 0.5,
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: ImageUtils.instance
                                                        .getImageNetWork(
                                                            dto.imgId),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        _buildElement1(
                                          context: context,
                                          width: width,
                                          content:
                                              dto.bankAccountName.toUpperCase(),
                                          isBold: true,
                                        ),
                                        _buildElement1(
                                          context: context,
                                          width: width,
                                          content: dto.bankAccount,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: DividerWidget(width: width),
                                        ),
                                        _buildElement2(
                                          context: context,
                                          title: 'Thời gian',
                                          content: TimeUtils.instance
                                              .formatDateFromInt(
                                                  dto.time, false),
                                          width: width,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        if (dto.referenceNumber
                                            .trim()
                                            .isNotEmpty) ...[
                                          _buildElement2(
                                            context: context,
                                            title: 'Mã giao dịch',
                                            content: dto.referenceNumber,
                                            width: width,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                        ],
                                        _buildElement2(
                                          context: context,
                                          title: 'Nội dung',
                                          content: dto.content,
                                          width: width,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        // _buildElement2(
                                        //   context: context,
                                        //   title: 'Trạng thái',
                                        //   content: TransactionUtils.instance
                                        //       .getStatusString(dto.status),
                                        //   width: width - 40,
                                        //   isBold: true,
                                        //   color: TransactionUtils.instance
                                        //       .getColorStatus(
                                        //     dto.status,
                                        //     dto.type,
                                        //     dto.transType,
                                        //   ),
                                        // ),
                                        // const Padding(
                                        //     padding: EdgeInsets.only(top: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 30)),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  // if (dto.transType == 'C')
                  //   SizedBox(
                  //     width: width,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         if (dto.status != 0)
                  //           ButtonIconWidget(
                  //             width: width,
                  //             height: 40,
                  //             icon: Icons.refresh_rounded,
                  //             title: 'Thực hiện lại',
                  //             function: () {
                  //               QRRecreateDTO qrRecreateDTO = QRRecreateDTO(
                  //                 bankId: dto.bankId,
                  //                 amount: dto.amount.toString(),
                  //                 content: dto.content,
                  //                 userId: UserInformationHelper.instance
                  //                     .getUserId(),
                  //                 newTransaction: true,
                  //               );
                  //               // qrBloc
                  //               //     .add(QREventRegenerate(dto: qrRecreateDTO));
                  //             },
                  //             bgColor: DefaultTheme.GREEN,
                  //             textColor: DefaultTheme.WHITE,
                  //           ),
                  //       ],
                  //     ),
                  //   ),
                  // const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              );
            },
          )),
    );
  }

  // Future<void> saveImage(BuildContext context) async {
  //   _waterMarkProvider.updateWaterMark(true);
  //   DialogWidget.instance.openLoadingDialog();
  //   await Future.delayed(const Duration(milliseconds: 200), () async {
  //     await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
  //       _waterMarkProvider.updateWaterMark(false);
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(
  //         msg: 'Đã lưu ảnh',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Theme.of(context).cardColor,
  //         textColor: Theme.of(context).cardColor,
  //         fontSize: 15,
  //       );
  //     });
  //   });
  // }

  // Future<void> shareImage() async {
  //   _waterMarkProvider.updateWaterMark(true);
  //   await Future.delayed(const Duration(milliseconds: 200), () async {
  //     await ShareUtils.instance
  //         .shareImage(
  //           key: globalKey,
  //           textSharing:
  //               'Giao dịch ${TransactionUtils.instance.getStatusString(dto.status)} ${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount.toString())} VND\nĐược tạo bởi vietqr.vn - Hotline 19006234',
  //         )
  //         .then((value) => _waterMarkProvider.updateWaterMark(false));
  //   });
  // }

  Widget _buildElement1({
    required double width,
    required BuildContext context,
    required String content,
    bool? isBold,
  }) {
    return Container(
      width: width,
      height: 20,
      alignment: Alignment.centerLeft,
      child: Text(
        content,
        style: TextStyle(
          fontWeight:
              (isBold != null && isBold) ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildElement2({
    required double width,
    required BuildContext context,
    required String title,
    required String content,
    Color? color,
    bool? isBold,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: DefaultTheme.GREY_TEXT,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: (color != null) ? color : Theme.of(context).hintColor,
                fontWeight: (isBold != null && isBold)
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
