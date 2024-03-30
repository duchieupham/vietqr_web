import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/layouts/table/data_cell_widget.dart';
import 'package:VietQR/models/member/member_dto.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableMemberWidget extends StatefulWidget {
  final List<Member> items;
  final int offset;
  final bool isLoading;
  final MerchantRole role;

  const TableMemberWidget({
    Key? key,
    required this.items,
    required this.offset,
    this.isLoading = false,
    required this.role,
  }) : super(key: key);

  @override
  State<TableMemberWidget> createState() => _TableMemberWidgetState();
}

class _TableMemberWidgetState extends State<TableMemberWidget> {
  final _horizontal = ScrollController();
  final double _headingRowHeight = 50;

  final List<TransData> list = [
    TransData(title: 'stt'.toUpperCase(), width: 40),
    TransData(title: 'Họ và tên', width: 150),
    TransData(title: 'Số điện thoại', width: 100),
    TransData(title: 'Cấp quản lý', width: 100),
    TransData(title: 'Cửa hàng / điểm bán', width: 200),
    TransData(title: 'Phân quyền chức năng', width: 200),
    TransData(title: 'Thao tác', width: 120),
  ];
  final List<TransData> listPin = [
    TransData(title: 'Thao tác', width: 120),
  ];

  double widthTable = 0;

  @override
  void initState() {
    super.initState();
    for (var element in list) {
      widthTable += (element.width ?? 0); // +1 là width của border
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        double withEmpty = 0;
        double width = MediaQuery.of(context).size.width;
        width -= 50;
        if (provider.showMenu) width -= 170;

        withEmpty = width - widthTable;

        return Stack(
          children: [
            _buildTable(withEmpty),
            _buildPinColumn(),
          ],
        );
      },
    );
  }

  Widget _buildTable(double withEmpty) {
    return SizedBox(
      width: widthTable,
      child: RawScrollbar(
        controller: _horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataTable(
                headingRowHeight: _headingRowHeight,
                dataRowHeight: _headingRowHeight,
                horizontalMargin: 0,
                columnSpacing: 0,
                headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return AppColor.BLUE_TEXT.withOpacity(0.25);
                  },
                ),
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
                    ),
                  );
                }),
                rows: const [],
              ),
              _buildRows(),
              _buildEmpty(withEmpty),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinColumn() {
    if (widget.items.isEmpty) return const SizedBox();
    return SizedBox(
      width: widthTable - 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildItemPin(
            data: listPin[0],
            isShadow: false,
            child: Column(
              children: List.generate(widget.items.length, (index) {
                Member dto = widget.items[index];
                return Container(
                  width: listPin[0].width,
                  height: dto.heightRow,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.GREY_TEXT.withOpacity(0.3),
                          width: 0.25),
                      color: Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIcon(
                        icon: AppImages.icDetailMember,
                        message: 'Xem chi tiết',
                        // onTap: () => widget.onEditNote(dto),
                      ),
                      if (widget.role.isAdmin) ...[
                        const SizedBox(width: 6),
                        _buildIcon(
                          icon: AppImages.icEditTrans,
                          message: 'Cập nhật',
                          // onTap: () => widget.onChooseTerminal(dto),
                        ),
                        const SizedBox(width: 6),
                        _buildIcon(
                          icon: AppImages.icTrashRed,
                          message: 'Xoá nhân viên',
                        ),
                      ]
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon({
    GestureTapCallback? onTap,
    required String icon,
    required String message,
  }) {
    return Tooltip(
      message: message,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: AppColor.BLUE_TEXT.withOpacity(0.25),
          ),
          child: Image(
            image: ImageUtils.instance.getImageNetWork(icon),
            width: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(double withEmpty) {
    if (widget.items.isNotEmpty) return const SizedBox.shrink();
    double width =
        withEmpty > 0 ? widthTable : (widthTable - (withEmpty.abs()));
    return Container(
      height: 100,
      width: widthTable,
      color: AppColor.BLUE_TEXT.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: width,
            child: (widget.isLoading)
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      Image(
                        image: ImageUtils.instance
                            .getImageNetWork(AppImages.icEmptyTrans),
                        width: 60,
                      ),
                      const Text(
                        'Trống',
                        style: TextStyle(color: AppColor.GREY_TEXT),
                      ),
                    ],
                  ),
          ),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildItemPin(
      {required TransData data, required Widget child, bool isShadow = true}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        boxShadow: isShadow
            ? [
                const BoxShadow(
                    color: AppColor.GREY_DADADA,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 0)),
              ]
            : [],
      ),
      child: Column(
        children: [
          Container(
            height: _headingRowHeight,
            width: data.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColor.BLUE_TEXT.withOpacity(0.25),
              border: Border.all(
                  color: AppColor.GREY_TEXT.withOpacity(0.3), width: 0.25),
            ),
            alignment: Alignment.center,
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildTitle({required String title, double? width}) {
    return Container(
      height: 40,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildRows() {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      width: widthTable,
      child: Column(
        children: List.generate(widget.items.length, (index) {
          Member e = widget.items[index];
          return Row(
            children: [
              /// STT
              DataCellWidget(
                title: '${(widget.offset * 20) + index + 1}',
                width: list[0].width,
                height: e.heightRow,
                textAlign: TextAlign.center,
              ),

              /// Họ tên
              DataCellWidget(
                title: e.fullName.trim(),
                width: list[1].width,
                height: e.heightRow,
                textAlign: TextAlign.left,
              ),

              /// Phone
              DataCellWidget(
                title: e.phoneNo,
                width: list[2].width,
                height: e.heightRow,
                textAlign: TextAlign.right,
              ),

              /// cấp quản lý
              DataCellWidget(
                title: e.level,
                width: list[3].width,
                height: e.heightRow,
                textAlign: TextAlign.left,
              ),

              /// tên cửa hàng
              DataCellWidget(
                title: e.nameStore,
                width: list[4].width,
                height: e.heightRow,
                textAlign: TextAlign.left,
              ),

              _buildRoleWidget(
                e,
                width: list[5].width,
              ),

              DataCellWidget(
                width: list[6].width,
                height: e.heightRow,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRoleWidget(Member e, {double? width}) {
    List<TransReceiveRole> listData = [...e.transReceiveRoles];
    return Container(
      height: e.heightRow,
      width: width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.GREY_DADADA, width: 0.25),
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 6,
        runSpacing: 6,
        children: List.generate(listData.length, (index) {
          TransReceiveRole dto = listData[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: dto.getBgrColor,
            ),
            child: Text(
              dto.name ?? '',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: dto.getColor,
                height: 1.4,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TransData {
  final String title;
  final double? width;

  TransData({
    required this.title,
    this.width,
  });
}
