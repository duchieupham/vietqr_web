import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/member/member_dto.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableMemberWidget extends StatefulWidget {
  final List<Member> items;
  final int offset;
  final bool isOwner;
  final bool isLoading;

  const TableMemberWidget({
    Key? key,
    required this.items,
    required this.offset,
    this.isOwner = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<TableMemberWidget> createState() => _TableMemberWidgetState();
}

class _TableMemberWidgetState extends State<TableMemberWidget> {
  final _horizontal = ScrollController();
  final double _headingRowHeight = 40;

  final List<TransData> list = [
    TransData(title: 'stt'.toUpperCase(), width: 40),
    TransData(title: 'Họ và tên', width: 150),
    TransData(title: 'Số điện thoại', width: 100),
    TransData(title: 'Cấp quản lý', width: 100),
    TransData(title: 'Cửa hàng / điểm bán', width: 200),
    TransData(title: 'Phân quyền chức năng', width: 200),
    TransData(title: 'Thao tác', width: 100),
  ];
  final List<TransData> listPin = [
    TransData(title: 'Thao tác', width: 100),
  ];

  double widthTable = 0;

  @override
  void initState() {
    super.initState();
    for (var element in list) {
      widthTable += (element.width ?? 0) + 1; // +1 là width của border
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
                rows: List.generate(
                  widget.items.length,
                  (index) {
                    Member model = widget.items[index];
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) => Colors.transparent),
                      cells: [
                        dataCell(
                          child: buildContent(
                            title: '${(widget.offset * 20) + index + 1}',
                            textAlign: TextAlign.center,
                            width: list[0].width,
                          ),
                        ),
                        dataCell(
                          child: buildContent(
                            title: model.fullName,
                            textAlign: TextAlign.left,
                            width: list[1].width,
                          ),
                        ),
                        dataCell(
                          child: buildContent(
                            title: model.phoneNo,
                            textAlign: TextAlign.right,
                            width: list[2].width,
                          ),
                        ),
                        dataCell(
                          child: buildContent(
                            title: model.level,
                            textAlign: TextAlign.left,
                            width: list[3].width,
                          ),
                        ),
                        dataCell(
                          child: buildContent(
                            title: model.nameStore,
                            textAlign: TextAlign.left,
                            width: list[4].width,
                          ),
                        ),
                        dataCell(
                          child: buildContent(
                            title: model.phoneNo,
                            textAlign: TextAlign.left,
                            width: list[5].width,
                          ),
                        ),
                        dataCell(
                          child: buildContent(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _buildEmpty(withEmpty),
            ],
          ),
        ),
      ),
    );
  }

  DataCell dataCell({required Widget child}) {
    return DataCell(child);
  }

  Widget _buildPinColumn() {
    if (widget.items.isEmpty) return const SizedBox();
    return SizedBox(
      width: widthTable - 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(
          listPin.length,
          (index) {
            TransData data = listPin[index];
            return _buildItemPin(
              data: data,
              child: Column(
                children: List.generate(widget.items.length, (index) {
                  Member member = widget.items[index];
                  return Container(
                    width: data.width,
                    height: member.headingRowHeight,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.GREY_TEXT.withOpacity(0.3)),
                        color: Colors.transparent),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIcon(
                          message: 'Thông tin nhân viên',
                          url: AppImages.icDetailMember,
                        ),
                        if (widget.isOwner) ...[
                          const SizedBox(width: 4),
                          _buildIcon(
                            message: 'Cập nhật ghi chú',
                            url: AppImages.icEditTrans,
                          ),
                          const SizedBox(width: 4),
                          _buildIcon(
                            message: 'Xoá nhân viên',
                            url: AppImages.icTrashRed,
                            color: AppColor.RED_CALENDAR.withOpacity(0.3),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ),
            );
          },
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

  Widget _buildItemPin({required TransData data, required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
              color: AppColor.GREY_DADADA,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 0)),
        ],
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
                  color: AppColor.GREY_TEXT.withOpacity(0.3), width: 1),
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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget buildContent({
    String? title,
    Color? textColor,
    GestureTapCallback? onTap,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? width,
    double height = 40,
  }) {
    return SelectionArea(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title ?? '-',
                maxLines: height > 40 ? null : 2,
                textAlign: textAlign,
                style: TextStyle(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                  fontSize: fontSize ?? 10,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(
      {String message = '',
      String url = '',
      GestureTapCallback? onTap,
      Color? color}) {
    return Tooltip(
      message: message,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: color ?? AppColor.BLUE_TEXT.withOpacity(0.25),
          ),
          child: Image(
            image: ImageUtils.instance.getImageNetWork(url),
            width: 24,
          ),
        ),
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
