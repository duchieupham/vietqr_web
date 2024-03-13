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
    TableData(title: '', padding: 0, width: 80),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          SizedBox(
            width: 1025,
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
                              title: '${(widget.offset * 20) + index + 1}',
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
          SizedBox(
            width: 1025,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Container(
                  color: AppColor.GREY_BG,
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: AppColor.BLUE_TEXT.withOpacity(0.35),
                          border: Border.all(
                            color: AppColor.GREY_TEXT.withOpacity(0.6),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          list.last.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Column(
                        children: List.generate(
                          widget.terminals.length,
                          (index) {
                            Terminal dto = widget.terminals[index];
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                    '/enterprise/store/detail?id=${dto.terminalId}');
                              },
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          AppColor.GREY_TEXT.withOpacity(0.6),
                                    ),
                                    color: Colors.transparent),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.info_outline,
                                        color: AppColor.BLUE_TEXT, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      'Chi tiết',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: AppColor.BLUE_TEXT,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTitle(
      {bool isShowIcon = false,
      required String title,
      double? width,
      double? padding,
      Color? bgr}) {
    return Container(
      height: 40,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: padding ?? 30),
      decoration: BoxDecoration(color: bgr),
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
    return SelectionArea(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            if (isShowIcon) ...[
              const Icon(Icons.info_outline,
                  color: AppColor.BLUE_TEXT, size: 18),
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
