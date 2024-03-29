import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button/m_button_icon_widget.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TablePendingWidget extends StatefulWidget {
  final List<TransReceiveDTO> items;
  final ValueChanged<TransRequest> callBack;
  final int offset;
  final bool isOwner;
  final bool isLoading;

  const TablePendingWidget({
    Key? key,
    required this.items,
    required this.offset,
    this.isOwner = false,
    this.isLoading = false,
    required this.callBack,
  }) : super(key: key);

  @override
  State<TablePendingWidget> createState() => _TablePendingWidgetState();
}

class _TablePendingWidgetState extends State<TablePendingWidget> {
  final _horizontal = ScrollController();
  final double _headingRowHeight = 50;

  final List<TransData> list = [
    TransData(title: 'stt'.toUpperCase(), width: 40),
    TransData(title: 'Thời gian\nthanh toán', width: 100),
    TransData(title: 'Số tiền (VND)', width: 140),
    TransData(title: 'Mã giao dịch', width: 140),
    TransData(title: 'Tài khoản nhận', width: 200),
    TransData(title: 'Nội dung', width: 250),
    TransData(title: 'Người tạo', width: 140),
    TransData(title: 'Yêu cầu', width: 200),
    TransData(title: 'Thao tác', width: 170),
  ];
  final List<TransData> listPin = [
    TransData(title: 'Yêu cầu', width: 200),
    TransData(title: 'Thao tác', width: 170),
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
            child: Column(
              children: List.generate(widget.items.length, (index) {
                TransReceiveDTO dto = widget.items[index];
                return SizedBox(
                  width: listPin[0].width,
                  height: dto.heightRequest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(dto.requests.length, (index) {
                      return _buildColumnRequest(
                        dto: dto.requests[index],
                        width: listPin[0].width,
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
          _buildItemPin(
            data: listPin[1],
            child: Column(
              children: List.generate(widget.items.length, (index) {
                TransReceiveDTO dto = widget.items[index];
                return SizedBox(
                  width: listPin[1].width,
                  height: dto.heightRequest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(dto.requests.length, (index) {
                      TransRequest e = dto.requests[index];
                      return Container(
                        width: listPin[1].width,
                        height: _headingRowHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.GREY_TEXT.withOpacity(0.3)),
                            color: Colors.transparent),
                        child: Row(
                          children: [
                            Expanded(
                              child: Tooltip(
                                message: '',
                                child: MButtonIconWidget(
                                  height: 30,
                                  icon: Icons.check,
                                  iconSize: 14,
                                  iconColor: AppColor.BLUE_TEXT,
                                  title: 'Duyệt',
                                  onTap: () {
                                    e.status = 1;
                                    widget.callBack.call(e);
                                  },
                                  bgColor: AppColor.BLUE_TEXT.withOpacity(0.25),
                                  textColor: AppColor.BLUE_TEXT,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Tooltip(
                                message: '',
                                child: MButtonIconWidget(
                                  height: 30,
                                  iconSize: 14,
                                  icon: Icons.remove_circle_outline,
                                  iconColor: AppColor.RED_CALENDAR,
                                  title: 'Huỷ',
                                  onTap: () {
                                    e.status = 2;
                                    widget.callBack.call(e);
                                  },
                                  bgColor:
                                      AppColor.RED_CALENDAR.withOpacity(0.25),
                                  textColor: AppColor.RED_CALENDAR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
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
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.GREY_DADADA, width: 0.25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title ?? '-',
                maxLines: 2,
                textAlign: textAlign,
                style: TextStyle(
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                  fontSize: fontSize ?? 11,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRows() {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      width: widthTable,
      child: Column(
        children: List.generate(widget.items.length, (index) {
          TransReceiveDTO e = widget.items[index];
          return Row(
            children: [
              /// STT
              buildContent(
                title: '${(widget.offset * 20) + index + 1}',
                width: list[0].width,
                height: e.heightRequest,
                textAlign: TextAlign.center,
              ),

              /// thời gian tạo
              buildContent(
                title: e.timePayment,
                width: list[1].width,
                height: e.heightRequest,
                textAlign: TextAlign.right,
              ),

              /// Số tiền
              buildContent(
                title:
                    '${e.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(e.amount)}',
                width: list[2].width,
                height: e.heightRequest,
                textAlign: TextAlign.right,
                textColor: e.getColorStatus,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),

              /// Mã giao dịch
              buildContent(
                title: e.referenceNumber,
                width: list[3].width,
                height: e.heightRequest,
                textAlign: TextAlign.left,
              ),

              /// Tài khoản nhận
              _buildAccount(
                e,
                width: list[4].width,
                height: e.heightRequest,
              ),

              /// Nội dung
              buildContent(
                title: e.content,
                width: list[5].width,
                height: e.heightRequest,
                textAlign: TextAlign.left,
              ),

              /// Người tạo
              _buildPersonCreate(
                e,
                width: list[6].width,
              ),

              /// 2 cột pin
              buildContent(
                width: list[7].width,
                height: e.heightRequest,
              ),
              buildContent(
                width: list[8].width,
                height: e.heightRequest,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAccount(e, {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.GREY_DADADA, width: 0.25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            e.bankAccount,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 11,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500),
          ),
          Text(
            e.bankShortName,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 11,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonCreate(TransReceiveDTO e, {double? width}) {
    return SizedBox(
      height: e.heightRequest,
      width: width,
      child: Column(
        children: List.generate(e.requests.length, (index) {
          TransRequest transRequest = e.requests[index];
          return Container(
            width: width,
            height: _headingRowHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.GREY_DADADA, width: 0.25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transRequest.fullName,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  transRequest.phoneNumber,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildColumnRequest({required TransRequest dto, double? width}) {
    return Container(
      width: width,
      height: _headingRowHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.GREY_TEXT.withOpacity(0.3)),
          color: Colors.transparent),
      child: Text(
        dto.nameRequest,
        maxLines: 2,
        style: const TextStyle(
            color: AppColor.ORANGE,
            overflow: TextOverflow.ellipsis,
            fontSize: 11,
            fontWeight: FontWeight.w500),
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
