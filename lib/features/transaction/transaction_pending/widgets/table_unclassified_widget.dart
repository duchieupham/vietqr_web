import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TableUnclassifiedWidget extends StatefulWidget {
  final MerchantRole role;
  final List<TransReceiveDTO> items;
  final ValueChanged<TransRequest> callBack;
  final Function(TransReceiveDTO) onChooseTerminal;
  final Function(TransReceiveDTO) onEditNote;
  final Function(TransReceiveDTO) onCopy;
  final int offset;
  final bool isOwner;
  final bool isLoading;

  const TableUnclassifiedWidget({
    Key? key,
    required this.items,
    required this.offset,
    this.isOwner = false,
    this.isLoading = false,
    required this.callBack,
    required this.onChooseTerminal,
    required this.onEditNote,
    required this.role,
    required this.onCopy,
  }) : super(key: key);

  @override
  State<TableUnclassifiedWidget> createState() =>
      _TableUnclassifiedWidgetState();
}

class _TableUnclassifiedWidgetState extends State<TableUnclassifiedWidget> {
  final _horizontal = ScrollController();
  final double _headingRowHeight = 50;

  final List<TransData> list = [
    TransData(title: 'stt'.toUpperCase(), width: 40),
    TransData(title: 'Thời gian\nthanh toán', width: 100),
    TransData(title: 'Số tiền (VND)', width: 140),
    TransData(title: 'Mã giao dịch', width: 140),
    TransData(title: 'Tài khoản nhận', width: 200),
    TransData(title: 'Nội dung', width: 250),
    TransData(title: 'Ghi chú', width: 200),
    TransData(title: 'Trạng thái', width: 100),
    TransData(title: 'Thao tác', width: 150),
  ];
  final List<TransData> listPin = [
    TransData(title: 'Trạng thái', width: 100),
    TransData(title: 'Thao tác', width: 150),
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
                textAlign: TextAlign.center,
              ),

              /// thời gian tạo
              buildContent(
                title: e.timePayment,
                width: list[1].width,
                textAlign: TextAlign.right,
                onTap: () async {
                  await FlutterClipboard.copy(e.timePayment).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
              ),

              /// Số tiền
              buildContent(
                title:
                    '${e.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(e.amount)}',
                width: list[2].width,
                textAlign: TextAlign.right,
                textColor: e.getColorStatus,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                onTap: () async {
                  await FlutterClipboard.copy(
                          '${e.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(e.amount)}')
                      .then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
              ),

              /// Mã giao dịch
              buildContent(
                title: e.referenceNumber,
                width: list[3].width,
                textAlign: TextAlign.left,
                onTap: () async {
                  await FlutterClipboard.copy(e.referenceNumber).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
              ),

              /// Tài khoản nhận
              InkWell(
                onTap: () async {
                  await FlutterClipboard.copy(e.bankAccount).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: _buildAccount(
                  e,
                  width: list[4].width,
                  height: _headingRowHeight,
                ),
              ),

              /// Nội dung
              buildContent(
                title: e.content,
                width: list[5].width,
                textAlign: TextAlign.left,
                onTap: () async {
                  await FlutterClipboard.copy(e.content).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
              ),

              /// Người tạo
              buildContent(
                title: e.note,
                width: list[6].width,
                textAlign: TextAlign.left,
                onTap: () async {
                  await FlutterClipboard.copy(e.note).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
              ),

              /// 2 cột pin
              buildContent(
                width: list[7].width,
              ),
              buildContent(
                width: list[8].width,
              ),
            ],
          );
        }),
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
                return buildContent(
                  width: listPin[0].width,
                  title: dto.getStatusString,
                  textAlign: TextAlign.center,
                  textColor: dto.getColorStatus,
                );
              }),
            ),
          ),
          _buildItemPin(
            data: listPin[1],
            isShadow: false,
            child: Column(
              children: List.generate(widget.items.length, (index) {
                TransReceiveDTO dto = widget.items[index];
                return Container(
                  width: listPin[1].width,
                  height: _headingRowHeight,
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
                        icon: AppImages.icEditTrans,
                        message: 'Cập nhật ghi chú',
                        onTap: () => widget.onEditNote(dto),
                      ),
                      if (widget.role.isUpdateTrans || widget.isOwner) ...[
                        const SizedBox(width: 6),
                        _buildIcon(
                          icon: AppImages.icNoteTrans,
                          message: 'Cập nhật giao dịch',
                          onTap: () => widget.onChooseTerminal(dto),
                        ),
                        const SizedBox(width: 6),
                        Tooltip(
                          message: 'Copy',
                          child: InkWell(
                            onTap: () => widget.onCopy(dto),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: AppColor.BLUE_TEXT.withOpacity(0.25),
                              ),
                              child: const Icon(
                                Icons.copy,
                                size: 12,
                                color: AppColor.BLUE_TEXT,
                              ),
                            ),
                          ),
                        )
                      ],
                      if (dto.totalRequest > 0) ...[
                        const SizedBox(width: 6),
                        _buildIconRequest(
                          icon: AppImages.icRequestTrans,
                          onTap: () => widget.onChooseTerminal(dto),
                          dto: dto,
                        ),
                      ],
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

  Widget _buildIcon(
      {GestureTapCallback? onTap,
      required String icon,
      required String message}) {
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

  Widget _buildIconRequest({
    GestureTapCallback? onTap,
    required String icon,
    required TransReceiveDTO dto,
  }) {
    return Tooltip(
      message: '',
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 24,
          padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColor.ORANGE_DARK,
          ),
          child: Row(
            children: [
              Text(
                '${dto.totalRequest}',
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
              Image(
                image: ImageUtils.instance.getImageNetWork(icon),
                width: 24,
              ),
            ],
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

  Widget buildContent({
    String? title,
    Color? textColor,
    GestureTapCallback? onTap,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? width,
    double height = 50,
  }) {
    return InkWell(
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
}

class TransData {
  final String title;
  final double? width;

  TransData({
    required this.title,
    this.width,
  });
}
