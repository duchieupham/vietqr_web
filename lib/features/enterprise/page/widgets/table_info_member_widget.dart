import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/models/member_store_dto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TableInfoMemberWidget extends StatefulWidget {
  final List<MemberStoreModel> members;
  final int offset;

  const TableInfoMemberWidget(
      {super.key, required this.members, required this.offset});

  @override
  State<TableInfoMemberWidget> createState() => _TableStoreWidgetState();
}

class _TableStoreWidgetState extends State<TableInfoMemberWidget> {
  final List<TableData> list = [
    TableData(title: 'STT'),
    TableData(title: 'Họ tên'.toUpperCase()),
    TableData(title: 'Số điện thoại'.toUpperCase()),
    TableData(title: 'Vai trò'.toUpperCase()),
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
                      DataCell(
                        _buildContent(
                            title: 'Xoá',
                            isShowIcon: true,
                            textColor: AppColor.RED_EC1010,
                            iconColor: AppColor.RED_EC1010,
                            icon: Icons.remove_circle_outline,
                            onTap: () {
                              context.push('/enterprise/store/detail');
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
    Color? iconColor,
    bool isShowIcon = false,
    GestureTapCallback? onTap,
    IconData? icon,
  }) {
    return GestureDetector(
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
