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
  final List<TableData> list = [
    TableData(title: 'STT'),
    TableData(title: 'TÊN CỬA HÀNG'.toUpperCase()),
    TableData(title: 'Giao dich hôm nay'.toUpperCase()),
    TableData(title: 'Doanh thu hôm nay (VND)'.toUpperCase()),
    TableData(title: 'Thành viên'.toUpperCase()),
    TableData(title: 'Mã điểm bán'.toUpperCase()),
    TableData(title: 'Tk ngân hàng'.toUpperCase()),
    TableData(title: 'Địa chỉ'.toUpperCase()),
    TableData(title: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return AppColor.BLUE_TEXT.withOpacity(0.35);
              }),
              border: TableBorder.all(width: 0.5, color: AppColor.GREY_TEXT),
              columns: List.generate(list.length, (index) {
                TableData e = list[index];
                return DataColumn(
                  label: _buildTitle(title: e.title, isShowIcon: e.isIcon),
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
                      DataCell(_buildContent(
                          title:
                              '${(widget.offset * 20) + (widget.offset + index) + 1}')),
                      DataCell(_buildContent(title: model.terminalName ?? '')),
                      DataCell(
                          _buildContent(title: '${model.totalTrans ?? 0}')),
                      DataCell(_buildContent(title: model.amount)),
                      DataCell(
                          _buildContent(title: '${model.totalMember ?? 0}')),
                      DataCell(_buildContent(title: model.terminalCode ?? '')),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(model.bankShortName ?? ''),
                            Text(model.bankAccount ?? ''),
                          ],
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: _buildContent(
                            title: model.terminalAddress ?? '',
                          ),
                        ),
                      ),
                      DataCell(
                        _buildContent(
                            title: 'Chi tiết',
                            isShowIcon: true,
                            textColor: AppColor.BLUE_TEXT,
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
        ],
      ),
    );
  }

  _buildTitle({bool isShowIcon = false, required String title}) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildContent({
    required String title,
    Color? textColor,
    bool isShowIcon = false,
    GestureTapCallback? onTap,
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
              style: TextStyle(
                color: textColor ?? AppColor.GREY_TEXT,
                overflow: TextOverflow.ellipsis,
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

  TableData({required this.title, this.isIcon = false});
}
