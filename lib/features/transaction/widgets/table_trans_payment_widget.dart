import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:flutter/material.dart';

class TableTransPaymentWidget extends StatefulWidget {
  final List<TransReceiveDTO> list;
  final int offset;
  final Function(String transactionId, String terminalCode) onChooseTerminal;
  final Function(TransReceiveDTO) onEditNote;
  final bool isOwner;

  const TableTransPaymentWidget({
    super.key,
    required this.list,
    required this.offset,
    required this.onChooseTerminal,
    required this.onEditNote,
    this.isOwner = false,
  });

  @override
  State<TableTransPaymentWidget> createState() =>
      _TableTransPaymentWidgetState();
}

class _TableTransPaymentWidgetState extends State<TableTransPaymentWidget> {
  final ScrollController _horizontal = ScrollController();

  final List<TransData> list = [
    TransData(title: 'stt'.toUpperCase()),
    TransData(title: 'Thời gian\nthanh toán', width: 80),
    TransData(title: 'Số tiền (VND)', width: 100),
    TransData(title: 'Mã giao dịch', width: 100),
    TransData(title: 'Mã đơn hàng', width: 100),
    TransData(title: 'Mã điểm bán', width: 100),
    TransData(title: 'Loại GD', width: 100),
    TransData(title: 'Thời gian\ntạo GD', width: 80),
    TransData(title: 'Tài khoản\nnhận', width: 80),
    TransData(title: 'Nội dung', width: 200),
    TransData(title: 'Ghi chú', width: 200),
    TransData(title: 'Trạng thái', padding: 0, width: 80),
    TransData(title: 'Thao tác', padding: 0, width: 80),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          SizedBox(
            width: 1480,
            child: RawScrollbar(
              controller: _horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontal,
                child: DataTable(
                  headingRowHeight: 40,
                  dataRowHeight: 40,
                  horizontalMargin: 10,
                  columnSpacing: 16,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return AppColor.BLUE_TEXT.withOpacity(0.25);
                  }),
                  border: TableBorder.all(
                    width: 0.5,
                    color: AppColor.GREY_TEXT.withOpacity(0.6),
                  ),
                  columns: List.generate(list.length, (index) {
                    TransData e = list[index];
                    return DataColumn(
                      label: _buildTitle(
                        title: e.title,
                        width: e.width,
                        padding: e.padding,
                      ),
                    );
                  }),
                  rows: List.generate(
                    widget.list.length,
                    (index) {
                      TransReceiveDTO model = widget.list[index];
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          return Colors.transparent;
                        }),
                        cells: [
                          /// STT
                          DataCell(
                            _buildContent(
                              title: '${(widget.offset * 20) + index + 1}',
                              textAlign: TextAlign.center,
                            ),
                          ),

                          /// Thời gian tạo
                          DataCell(
                              _buildContent(title: model.timePayment ?? '-')),

                          /// Số tiền
                          DataCell(
                            _buildContent(
                              title:
                                  '${model.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(model.amount)}',
                              textAlign: TextAlign.right,
                              textColor: model.getColorStatus,
                            ),
                          ),

                          /// Mã giao dịch
                          DataCell(
                            _buildContent(
                              title: model.referenceNumber,
                              textAlign: TextAlign.left,
                            ),
                          ),

                          /// Mã đơn hàng
                          DataCell(
                            _buildContent(
                              title: model.orderId,
                              textAlign: TextAlign.left,
                            ),
                          ),

                          /// Mã điểm bán
                          DataCell(_buildContent(
                            title: model.terminalCode,
                            textAlign: TextAlign.left,
                          )),

                          /// Loại GD
                          DataCell(
                            _buildContent(
                              title: model.transactionType,
                              textAlign: TextAlign.right,
                            ),
                          ),

                          /// Thời gian tạo
                          DataCell(
                            _buildContent(title: model.timeCreate),
                          ),

                          /// Tài khoản nhận
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.bankAccount,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Text(
                                  'MBBank',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          /// Nội dung
                          DataCell(
                            SizedBox(
                                width: 200,
                                child: _buildContent(title: model.content)),
                          ),

                          ///Ghi chú
                          DataCell(
                            SizedBox(
                                width: 200,
                                child: _buildContent(title: model.note)),
                          ),

                          /// Tài khoản nhận
                          const DataCell(
                            SizedBox(width: 80),
                          ),

                          /// Tài khoản nhận
                          const DataCell(
                            SizedBox(width: 80),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          if (widget.list.isNotEmpty)
            SizedBox(
              width: 1480,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    color: AppColor.WHITE,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT.withOpacity(0.25),
                            border: Border.all(
                              color: AppColor.GREY_TEXT.withOpacity(0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Trạng thái',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            widget.list.length,
                            (index) {
                              TransReceiveDTO dto =
                                  widget.list[index];
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            AppColor.GREY_TEXT.withOpacity(0.3),
                                      ),
                                      color: Colors.transparent),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dto.getStatusString,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: dto.getColorStatus,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: AppColor.WHITE,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 110,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT.withOpacity(0.25),
                            border: Border.all(
                              color: AppColor.GREY_TEXT.withOpacity(0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Thao tác',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            widget.list.length,
                            (index) {
                              TransReceiveDTO dto =
                                  widget.list[index];
                              return Container(
                                width: 110,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          AppColor.GREY_TEXT.withOpacity(0.3),
                                    ),
                                    color: Colors.transparent),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tooltip(
                                      message: 'Sửa ghi chú',
                                      child: GestureDetector(
                                        onTap: () => widget.onEditNote(dto),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: AppColor.BLUE_TEXT
                                                .withOpacity(0.25),
                                          ),
                                          child: Image(
                                            image: ImageUtils.instance
                                                .getImageNetWork(
                                                    AppImages.icEditTrans),
                                            width: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Sửa mã điểm bán',
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!widget.isOwner &&
                                              !dto.isEnableTerminal) return;
                                          widget.onChooseTerminal(
                                              dto.transactionId,
                                              dto.terminalCode);
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: (!widget.isOwner &&
                                                    !dto.isEnableTerminal)
                                                ? AppColor.GREY_BG
                                                : AppColor.BLUE_TEXT
                                                    .withOpacity(0.25),
                                          ),
                                          child: Image(
                                            image: ImageUtils.instance
                                                .getImageNetWork(
                                                    AppImages.icNoteTrans),
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
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle(
      {required String title, double? width, double? padding, Color? bgr}) {
    return Container(
      height: 40,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: padding ?? 20),
      decoration: BoxDecoration(color: bgr),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildContent(
      {required String title,
      Color? textColor,
      GestureTapCallback? onTap,
      double? fontSize,
      TextAlign? textAlign}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.isNotEmpty ? title : '-',
              maxLines: 2,
              textAlign: textAlign,
              style: TextStyle(
                color: textColor,
                overflow: TextOverflow.ellipsis,
                fontSize: fontSize ?? 10,
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