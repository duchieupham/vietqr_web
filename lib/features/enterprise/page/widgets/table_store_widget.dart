import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TableStoreWidget extends StatefulWidget {
  final List<Terminal> terminals;
  final int offset;

  const TableStoreWidget(
      {super.key, required this.terminals, required this.offset});

  @override
  State<TableStoreWidget> createState() => _TableStoreWidgetState();
}

class _TableStoreWidgetState extends State<TableStoreWidget> {
  final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  final List<TableData> list = [
    TableData(title: 'STT'.toUpperCase(), padding: 0),
    TableData(title: 'TÊN CỬA HÀNG'.toUpperCase()),
    TableData(title: 'Giao dich\nhôm nay'.toUpperCase(), width: 80, padding: 0),
    TableData(
        title: 'Doanh thu\nhôm nay (VND)'.toUpperCase(),
        width: 100,
        padding: 0),
    TableData(title: 'Thành viên'.toUpperCase(), width: 80, padding: 0),
    TableData(title: 'Mã điểm bán'.toUpperCase(), width: 100, padding: 0),
    TableData(title: 'Tk ngân hàng'.toUpperCase()),
    TableData(title: 'Địa chỉ'.toUpperCase(), width: 150),
    TableData(title: ''),
  ];

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
                  widget.terminals.length,
                  (index) {
                    Terminal model = widget.terminals[index];
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

                        /// Tên cửa hàng
                        DataCell(
                            _buildContent(title: model.terminalName ?? '-')),

                        /// Giao dịch hôm nay
                        DataCell(
                          _buildContent(
                            title: '${model.totalTrans ?? 0}',
                            textAlign: TextAlign.right,
                          ),
                        ),

                        /// Doanh thu hôm nay
                        DataCell(
                          _buildContent(
                            title: model.amount,
                            textAlign: TextAlign.right,
                          ),
                        ),

                        /// Thành viên
                        DataCell(
                          _buildContent(
                            title: '${model.totalMember ?? 0}',
                            textAlign: TextAlign.center,
                          ),
                        ),

                        /// Mã điểm bán
                        DataCell(_buildContent(
                          title: model.terminalCode ?? '-',
                          textAlign: TextAlign.left,
                        )),

                        /// TK ngân hàng
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

                        /// Địa chỉ
                        DataCell(
                          _buildContent(title: model.terminalAddress ?? '-'),
                        ),

                        /// Chi tiết
                        DataCell(
                          _buildContent(
                              title: 'Chi tiết',
                              isShowIcon: true,
                              textColor: AppColor.BLUE_TEXT,
                              fontSize: 10,
                              onTap: () {
                                context.push(
                                    '/enterprise/store/detail?id=${model.terminalId}');
                              }),
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
      padding: EdgeInsets.symmetric(horizontal: padding ?? 40),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
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
              title,
              maxLines: 2,
              textAlign: textAlign,
              style: TextStyle(
                color: textColor,
                overflow: TextOverflow.ellipsis,
                fontSize: fontSize ?? 12,
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
