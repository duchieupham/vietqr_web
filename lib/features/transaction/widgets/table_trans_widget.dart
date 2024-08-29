import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableTransWidget extends StatefulWidget {
  final List<TransReceiveDTO> list;
  final int offset;
  final Function(TransReceiveDTO) onChooseTerminal;
  final Function(TransReceiveDTO) onEditNote;
  final bool isOwner;
  final bool isLoading;

  const TableTransWidget({
    super.key,
    required this.list,
    required this.offset,
    required this.onChooseTerminal,
    required this.onEditNote,
    this.isOwner = false,
    this.isLoading = false,
  });

  @override
  State<TableTransWidget> createState() => _TableTransWidgetState();
}

class _TableTransWidgetState extends State<TableTransWidget> {
  final ScrollController _horizontal = ScrollController();
  // ScrollController controller1 = ScrollController();
  // ScrollController controller2 = ScrollController();
  // bool isScrollingDown1 = false;
  // bool isScrollingDown2 = false;

  final List<TransData> list = [
    TransData(title: 'stt'.toUpperCase(), width: 50),
    TransData(title: 'Thời gian\nthanh toán', width: 100),
    TransData(title: 'Số tiền (VND)', width: 100),
    TransData(title: 'Mã giao dịch', width: 100),
    TransData(title: 'Mã đơn hàng', width: 100),
    TransData(title: 'Mã điểm bán', width: 100),
    TransData(title: 'Mã cửa hàng', width: 120),

    TransData(title: 'Loại GD', width: 100),
    TransData(title: 'Thời gian\ntạo GD', width: 100),
    TransData(title: 'Tài khoản\nnhận', width: 100),
    TransData(title: 'Nội dung', width: 250),
    TransData(title: 'Ghi chú', width: 200),
    // TransData(title: 'Trạng thái', padding: 0, width: 80),
    // TransData(title: 'Thao tác', padding: 0, width: 80),
  ];

  @override
  void initState() {
    super.initState();
    // controller1 = ScrollController();
    // controller2 = ScrollController();
    // controller1.addListener(() {
    //   if (!isScrollingDown2) {
    //     isScrollingDown1 = true;
    //     controller2.jumpTo(controller1.offset);
    //   }
    //   isScrollingDown1 = false;
    // });

    // controller2.addListener(() {
    //   if (!isScrollingDown1) {
    //     isScrollingDown2 = true;
    //     controller1.jumpTo(controller2.offset);
    //   }
    //   isScrollingDown2 = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        double width = MediaQuery.of(context).size.width;
        if (provider.showMenu) {
          width = width - 220;
        } else {
          width = width - 50;
        }

        return Expanded(
          child: SizedBox(
            width: width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double widthTable = constraints.maxWidth;
                double withEmpty = 0;

                withEmpty = width - widthTable;
                return Stack(
                  children: [
                    Positioned.fill(
                      right: 210,
                      child: SizedBox(
                        width: widthTable,
                        child: RawScrollbar(
                          controller: _horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.3)),
                                  child: Row(
                                    children: List.generate(
                                      list.length,
                                      (index) {
                                        TransData e = list[index];
                                        return _buildItemTitle(e.title,
                                            height: 40,
                                            width: e.width,
                                            alignment: Alignment.center,
                                            textAlign: TextAlign.center);
                                      },
                                    ),
                                  ),
                                ),
                                if (widget.list.isEmpty)
                                  Container(
                                    height: 100,
                                    width: widthTable,
                                    color: AppColor.BLUE_TEXT.withOpacity(0.1),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: withEmpty > 0
                                              ? widthTable
                                              : widthTable - (withEmpty.abs()),
                                          child: (widget.isLoading)
                                              ? const Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Image(
                                                      image: ImageUtils.instance
                                                          .getImageNetWork(
                                                              AppImages
                                                                  .icEmptyTrans),
                                                      width: 60,
                                                    ),
                                                    const Text('Trống',
                                                        style: TextStyle(
                                                            color: AppColor
                                                                .GREY_TEXT)),
                                                  ],
                                                ),
                                        ),
                                        // const Expanded(child: SizedBox.shrink())
                                      ],
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    children: widget.list
                                        .asMap()
                                        .map(
                                          (index, x) {
                                            return MapEntry(
                                                index,
                                                _buildItem(
                                                  index: index,
                                                  model: x,
                                                ));
                                          },
                                        )
                                        .values
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColor.WHITE,
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColor.BLUE_TEXT.withOpacity(0.3)),
                                child: Row(
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColor.GREY_TEXT
                                                    .withOpacity(0.3))),
                                        child: const Text(
                                          'Trạng thái',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLACK,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        height: 40,
                                        width: 110,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColor.GREY_TEXT
                                                    .withOpacity(0.3))),
                                        child: const Text(
                                          'Thao tác',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.BLACK,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ),
                              if (widget.list.isNotEmpty)
                                Expanded(
                                  child: Column(
                                    children: List.generate(
                                      widget.list.length,
                                      (index) {
                                        TransReceiveDTO dto =
                                            widget.list[index];
                                        return Container(
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(0.3),
                                                      ),
                                                      color:
                                                          Colors.transparent),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        dto.getStatusString,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: dto
                                                              .getColorStatus,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 110,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColor
                                                            .GREY_TEXT
                                                            .withOpacity(0.3),
                                                      ),
                                                      color:
                                                          Colors.transparent),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Tooltip(
                                                        message:
                                                            'Cập nhật ghi chú',
                                                        child: GestureDetector(
                                                          onTap: () => widget
                                                              .onEditNote(dto),
                                                          child: Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          32),
                                                              color: AppColor
                                                                  .BLUE_TEXT
                                                                  .withOpacity(
                                                                      0.25),
                                                            ),
                                                            child: Image(
                                                              image: ImageUtils
                                                                  .instance
                                                                  .getImageNetWork(
                                                                      AppImages
                                                                          .icEditTrans),
                                                              width: 24,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (widget.isOwner)
                                                        Tooltip(
                                                          message:
                                                              'Cập nhật giao dịch',
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              widget
                                                                  .onChooseTerminal(
                                                                      dto);
                                                            },
                                                            child: Container(
                                                              width: 24,
                                                              height: 24,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            32),
                                                                color: (!widget
                                                                            .isOwner &&
                                                                        !dto
                                                                            .isEnableTerminal)
                                                                    ? AppColor
                                                                        .GREY_BG
                                                                    : AppColor
                                                                        .BLUE_TEXT
                                                                        .withOpacity(
                                                                            0.25),
                                                              ),
                                                              child: Image(
                                                                image: ImageUtils
                                                                    .instance
                                                                    .getImageNetWork(
                                                                        AppImages
                                                                            .icNoteTrans),
                                                                width: 24,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      // GestureDetector(
                                                      //   child: Container(
                                                      //     width: 24,
                                                      //     height: 24,
                                                      //     decoration: BoxDecoration(
                                                      //       borderRadius:
                                                      //           BorderRadius.circular(32),
                                                      //       color: AppColor.GREY_BG,
                                                      //     ),
                                                      //     child: Image(
                                                      //       image: ImageUtils.instance
                                                      //           .getImageNetWork(
                                                      //               AppImages.icRefundTrans),
                                                      //       width: 24,
                                                      //       color: AppColor.GREY_BG,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ));
                                      },
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: 100,
                                  width: 210,
                                  color: AppColor.BLUE_TEXT.withOpacity(0.1),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemTitle(String title,
      {TextAlign? textAlign,
      EdgeInsets? padding,
      double? width,
      double? height,
      Alignment? alignment}) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(
            fontSize: 12, color: AppColor.BLACK, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItem({int? index, TransReceiveDTO? model}) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                '${(widget.offset * 20) + index! + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                model!.timePayment,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                '${model.statusAmount} ${model.amount.contains('*') ? model.amount : CurrencyUtils.instance.getCurrencyFormatted(model.amount)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: model.getColorStatus,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                model.referenceNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                model.orderId,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                model.subCode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                model.terminalCode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                model.transactionType,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                model.timeCreate,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Column(
                // crossAxisAlignment:
                //     CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.bankAccount,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 10, overflow: TextOverflow.ellipsis),
                  ),
                  Text(
                    model.bankShortName,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 10, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 250,
            child: SelectionArea(
              child: Text(
                model.content,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                model.note,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransData {
  final String title;
  final double padding;
  final double? width;

  TransData({
    required this.title,
    this.width,
    this.padding = 0,
  });
}
