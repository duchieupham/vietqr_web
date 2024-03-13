import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/models/member_store_dto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TableMemberWidget extends StatefulWidget {
  final List<MemberStoreModel> members;
  final int offset;

  const TableMemberWidget(
      {super.key, required this.members, required this.offset});

  @override
  State<TableMemberWidget> createState() => _TableStoreWidgetState();
}

class _TableStoreWidgetState extends State<TableMemberWidget> {
  final List<TableData> list = [
    TableData(title: 'STT', padding: 0),
    TableData(title: 'Họ tên'.toUpperCase()),
    TableData(title: 'Số điện thoại'.toUpperCase()),
    TableData(title: 'Vai trò'.toUpperCase()),
    // TableData(title: ''),
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
              dataRowHeight: 40,
              horizontalMargin: 10,
              columnSpacing: 16,
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return AppColor.BLUE_TEXT.withOpacity(0.35);
              }),
              border: TableBorder.all(
                  width: 0.5, color: AppColor.GREY_TEXT.withOpacity(0.6)),
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
                widget.members.length,
                (index) {
                  MemberStoreModel model = widget.members[index];
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return Colors.transparent;
                    }),
                    cells: [
                      DataCell(_buildContent(
                          title:
                              '${(widget.offset * 20) + (widget.offset + index) + 1}')),
                      DataCell(
                        _buildContent(
                          title: model.fullName ?? '-',
                          icon: Icons.person,
                          iconColor: AppColor.GREY_TEXT,
                        ),
                      ),
                      DataCell(_buildContent(title: model.phoneNo ?? '-')),
                      DataCell(_buildContent(title: model.role ?? '-')),
                      // DataCell(
                      //   _buildContent(
                      //       title: 'Xoá',
                      //       isShowIcon: true,
                      //       textColor: AppColor.RED_EC1010,
                      //       iconColor: AppColor.RED_EC1010,
                      //       icon: Icons.remove_circle_outline,
                      //       onTap: () {
                      //         context.push('/enterprise/store/detail');
                      //       }),
                      // ),
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
    Color? iconColor,
    bool isShowIcon = false,
    GestureTapCallback? onTap,
    IconData? icon,
    double? fontSize,
    TextAlign? textAlign,
  }) {
    return SelectionArea(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? AppColor.BLUE_TEXT, size: 18),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                textAlign: textAlign,
                style: TextStyle(
                  color: textColor ?? AppColor.GREY_TEXT,
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
