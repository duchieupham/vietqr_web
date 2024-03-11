import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/models/transaction_store_dto.dart';
import 'package:flutter/material.dart';

class TableTransactionStoreWidget extends StatefulWidget {
  final List<TransactionStoreDTO> trans;
  final int offset;

  const TableTransactionStoreWidget({
    super.key,
    required this.trans,
    required this.offset,
  });

  @override
  State<TableTransactionStoreWidget> createState() =>
      _TableTransactionStoreWidgetState();
}

class _TableTransactionStoreWidgetState
    extends State<TableTransactionStoreWidget> {
  final List<TableData> list = [
    TableData(title: 'STT'.toUpperCase(), padding: 0),
    TableData(title: 'Mã đơn hàng'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Mã điểm bán'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Trạng thái'.toUpperCase(), width: 80, padding: 0),
    TableData(title: 'Loại GD'.toUpperCase(), width: 80, padding: 0),
    TableData(title: 'Thời gian\ntạo GD'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Nội dung'.toUpperCase(), width: 200),
    TableData(title: 'Tài khoản\nnhận'.toUpperCase()),
    TableData(title: 'Ghi chú'.toUpperCase(), width: 220),
  ];

  final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
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
                headingRowColor: MaterialStateProperty.resolveWith<Color?>(
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
                        isShowIcon: e.isIcon,
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
                            title:
                                '${(widget.offset * 20) + (widget.offset + index) + 1}',
                            textAlign: TextAlign.center,
                          ),
                        ),

                        /// Mã đơn hàng
                        DataCell(_buildContent(title: model.orderId ?? '-')),

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
                            child: _buildContent(title: model.content ?? '-'),
                          ),
                        ),

                        /// TK nhận
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model.bankAccount ?? '-',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                model.bankShortName ?? '-',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        /// Ghi chú

                        DataCell(
                          SizedBox(
                            width: 220,
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                      _buildContent(title: model.note ?? '-'),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.25),
                                    ),
                                    child: const Icon(Icons.edit,
                                        size: 14, color: AppColor.BLUE_TEXT),
                                  ),
                                )
                              ],
                            ),
                          ),
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
    );
  }

  _buildTitle(
      {bool isShowIcon = false,
      required String title,
      double? width,
      double? padding}) {
    return Container(
      height: 40,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: padding ?? 30),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  _buildContent({
    required String title,
    Color? textColor,
    bool isShowIcon = false,
    GestureTapCallback? onTap,
    double? fontSize,
    TextAlign? textAlign,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          if (isShowIcon) ...[
            const Icon(Icons.info_outline, color: AppColor.BLUE_TEXT, size: 18),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              title.isNotEmpty ? title : '-',
              maxLines: 2,
              textAlign: textAlign,
              style: TextStyle(
                color: textColor,
                overflow: TextOverflow.ellipsis,
                fontSize: fontSize ?? 11,
              ),
            ),
          ),
        ],
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
