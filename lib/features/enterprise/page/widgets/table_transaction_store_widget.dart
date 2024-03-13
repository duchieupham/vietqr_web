import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/transaction_store_dto.dart';
import 'package:flutter/material.dart';

class TableTransactionStoreWidget extends StatefulWidget {
  final List<TransactionStoreDTO> trans;
  final Function(TransactionStoreDTO) onEditNote;
  final int offset;

  const TableTransactionStoreWidget({
    super.key,
    required this.trans,
    required this.offset,
    required this.onEditNote,
  });

  @override
  State<TableTransactionStoreWidget> createState() =>
      _TableTransactionStoreWidgetState();
}

class _TableTransactionStoreWidgetState
    extends State<TableTransactionStoreWidget> {
  final List<TableData> list = [
    TableData(title: 'STT'.toUpperCase(), padding: 0),
    TableData(title: 'Số tiền (VND)', width: 100, padding: 0),
    TableData(title: 'Mã đơn hàng'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Mã điểm bán'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Trạng thái'.toUpperCase(), width: 80, padding: 0),
    TableData(title: 'Loại GD'.toUpperCase(), width: 80, padding: 0),
    TableData(title: 'Thời gian\ntạo GD'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Nội dung'.toUpperCase(), width: 200),
    TableData(title: 'Tài khoản\nnhận'.toUpperCase()),
    TableData(title: 'Ghi chú'.toUpperCase(), width: 220),
    TableData(title: 'Thao tác', padding: 0, width: 80),
  ];

  final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          SizedBox(
            width: 1360,
            child: RawScrollbar(
              controller: _vertical,
              thumbVisibility: true,
              trackVisibility: true,
              thumbColor: Colors.grey.withOpacity(0.6),
              child: RawScrollbar(
                controller: _horizontal,
                thumbVisibility: true,
                trackVisibility: true,
                thumbColor: Colors.grey.withOpacity(0.6),
                notificationPredicate: (notif) => notif.depth == 1,
                child: SingleChildScrollView(
                  controller: _vertical,
                  child: SingleChildScrollView(
                    controller: _horizontal,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 40,
                      dataRowHeight: 40,
                      horizontalMargin: 10,
                      columnSpacing: 16,
                      headingRowColor:
                          MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                        return AppColor.BLUE_TEXT.withOpacity(0.35);
                      }),
                      border: TableBorder.all(
                        width: 0.5,
                        color: AppColor.GREY_TEXT.withOpacity(0.6),
                      ),
                      columns: List.generate(list.length, (index) {
                        TableData e = list[index];
                        return DataColumn(
                          label: _buildTitle(
                              title: e.title,
                              width: e.width,
                              padding: e.padding),
                        );
                      }),
                      rows: List.generate(
                        widget.trans.length,
                        (index) {
                          TransactionStoreDTO model = widget.trans[index];
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

                              /// Số tiền
                              DataCell(
                                _buildContent(
                                  title:
                                      '${model.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(model.amount.toString())}',
                                  textAlign: TextAlign.right,
                                  textColor: model.getColorStatus,
                                ),
                              ),

                              /// Mã đơn hàng
                              DataCell(
                                  _buildContent(title: model.orderId ?? '-')),

                              /// Mã điểm bán
                              DataCell(
                                _buildContent(
                                  title: model.terminalCode ?? '-',
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              /// Trạng thái
                              DataCell(
                                _buildContent(
                                  title: model.statusType,
                                  textAlign: TextAlign.center,
                                  textColor: model.getColorStatus,
                                ),
                              ),

                              /// Loại GD
                              DataCell(
                                _buildContent(
                                  title: model.transactionType,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              /// Time tạo
                              DataCell(_buildContent(
                                title: model.timeCreate,
                                textAlign: TextAlign.right,
                              )),

                              /// Nội dung
                              DataCell(
                                SizedBox(
                                  width: 200,
                                  child: _buildContent(title: model.content),
                                ),
                              ),

                              /// TK nhận
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
                                    Text(
                                      model.bankShortName,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),

                              /// Ghi chú

                              ///Ghi chú
                              DataCell(
                                SizedBox(
                                  width: 200,
                                  child:
                                      _buildContent(title: model.note ?? '-'),
                                ),
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
            ),
          ),
          if (widget.trans.isNotEmpty)
            SizedBox(
              width: 1360,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.GREY_BG,
                      boxShadow: [
                        BoxShadow(
                            color: AppColor.GREY_BORDER.withOpacity(0.8),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 0)),
                      ],
                    ),
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
                            widget.trans.length,
                            (index) {
                              TransactionStoreDTO dto = widget.trans[index];
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
    return SelectionArea(
      child: GestureDetector(
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
      ),
    );
  }
}

class TableData {
  final String title;
  final bool isIcon;
  final double? width;
  final double? padding;

  TableData(
      {required this.title, this.isIcon = false, this.width, this.padding});
}
