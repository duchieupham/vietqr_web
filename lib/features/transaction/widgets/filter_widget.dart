import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/month_calculator.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../../models/transaction/data_filter.dart';
import 'dialog_excel_widget.dart';
import '../../../layouts/m_drop_widget.dart';

class FilterWidget extends StatefulWidget {
  final Function(int?, int?, int?, String?, String?, DateTime?, DateTime?, bool)
      callBack;
  final Function(int) onSearch;
  final Stream<bool> stream;
  final List<TerminalQRDTO> terminals;
  final String bankId;
  final bool isOwner;
  final bool isPending;

  const FilterWidget({
    super.key,
    required this.callBack,
    required this.onSearch,
    required this.stream,
    required this.terminals,
    required this.bankId,
    required this.isOwner,
    this.isPending = false,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final monthCalculator = MonthCalculator();
  final searchController = TextEditingController();

  DateFormat get _format => DateFormat('yyyy/MM/dd HH:mm:ss');

  DateTime get now => DateTime.now();

  String _value = '';
  String _terminalCode = '';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  DateTime _formatFromDate(DateTime now) {
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    return fromDate.subtract(const Duration(days: 7));
  }

  DateTime _formatEndDate(DateTime now) {
    DateTime fromDate = _formatFromDate(now);
    return fromDate
        .add(const Duration(days: 8))
        .subtract(const Duration(seconds: 1));
  }

  final List<DataFilter> listFilterBy = [
    const DataFilter(id: 9, name: 'Mã giao dịch'),
    const DataFilter(id: 5, name: 'Trạng thái giao dịch'),
    const DataFilter(id: 4, name: 'Mã điểm bán'),
    const DataFilter(id: 2, name: 'Mã đơn hàng (Order ID)'),
    const DataFilter(id: 3, name: 'Nội dung'),
  ];

  final List<DataFilter> listFilterByStatus = [
    const DataFilter(id: 0, name: 'Chờ thanh toán'),
    const DataFilter(id: 1, name: 'Thành công'),
    const DataFilter(id: 2, name: 'Đã huỷ'),
  ];

  List<DataFilter> listFilterByTime = [
    const DataFilter(id: 1, name: '7 ngày gần nhất'),
    const DataFilter(id: 2, name: 'Hôm nay'),
    const DataFilter(id: 3, name: '1 tháng gần đây'),
    const DataFilter(id: 4, name: '3 tháng gần đây'),
    const DataFilter(id: 5, name: 'Khoảng thời gian'),
  ];

  DataFilter _filterByTime = const DataFilter(id: 1, name: '7 ngày gần nhất');

  DataFilter _filterBy = const DataFilter(id: 9, name: 'Mã giao dịch');
  DataFilter _filterByStatus = const DataFilter(id: 0, name: 'Chờ thanh toán');

  String get hinText {
    if (_filterBy.id == 4) return 'Tìm kiếm theo mã điểm bán';
    if (_filterBy.id == 2) return 'Tìm kiếm theo mã đơn hàng';
    if (_filterBy.id == 3) return 'Tìm kiếm theo nội dung';
    return 'Tìm kiếm theo mã giao dịch';
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      _onClearFilter(clearData: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tìm kiếm GD thanh toán',
          style: TextStyle(
              color: AppColor.BLACK, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...[
                _buildFilterByWidget(),
                _buildSearchWidget(),
                _buildFilterByStatusWidget(),
              ],
              const SizedBox(width: 24),
              ...[
                _buildFilterByTimeWidget(),
                _buildRangeTimeWidget(),
              ],
              _removeFilterWidget(),
              _searchWidget(),
              if (widget.isOwner)
                ButtonWidget(
                  text: 'Xuất Excel',
                  width: 100,
                  border: Border.all(color: AppColor.GREEN),
                  textColor: AppColor.GREEN,
                  bgColor: AppColor.TRANSPARENT,
                  function: _onExportExcel,
                  borderRadius: 5,
                  height: 34,
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _onCallBack({
    int? type,
    int? time,
    int? status,
    String? search,
    String? terminalCode,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearData = false,
  }) {
    widget.callBack.call(
        type, time, status, search, terminalCode, fromDate, toDate, clearData);
  }

  Widget _buildFilterByWidget() {
    return SizedBox(
      width: 170,
      child: MDropWidget<DataFilter>(
        title: 'Tìm kiếm theo',
        list: listFilterBy,
        filter: _filterBy,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
        callBack: (value) {
          if (value == null) return;
          _filterBy = value;
          updateState();
          _onCallBack(type: _filterBy.id);
        },
      ),
    );
  }

  Widget _buildFilterByStatusWidget() {
    if (_filterBy.id != 5) return const SizedBox();
    return SizedBox(
      width: 200,
      child: MDropWidget<DataFilter>(
        list: listFilterByStatus,
        filter: _filterByStatus,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
        callBack: (value) {
          if (value == null) return;
          _filterByStatus = value;
          setState(() {});
          _onCallBack(status: _filterByStatus.id);
        },
      ),
    );
  }

  Widget _buildFilterByTimeWidget() {
    return SizedBox(
      width: 160,
      child: MDropWidget(
        title: 'Thời gian',
        list: listFilterByTime,
        filter: _filterByTime,
        callBack: onChangeTimeFilter,
      ),
    );
  }

  Widget _buildRangeTimeWidget() {
    if (_filterByTime.id != 5) return const SizedBox();
    return Row(
      children: [
        const SizedBox(width: 16),
        _itemPickTime(onTap: _pickFromDate, borderLeft: true),
        _itemPickTime(title: 'Đến ngày', date: _toDate, onTap: _pickToDate),
      ],
    );
  }

  Widget _itemPickTime(
      {String? title,
      DateTime? date,
      GestureTapCallback? onTap,
      bool borderLeft = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Từ ngày',
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 34,
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
              borderRadius: borderLeft
                  ? const BorderRadius.horizontal(left: Radius.circular(5))
                  : const BorderRadius.horizontal(right: Radius.circular(5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _format.format(date ?? _fromDate),
                    style: const TextStyle(fontSize: 10, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSearchWidget() {
    if (_filterBy.id == 5) return const SizedBox();
    return Container(
      width: 250,
      height: 34,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 12),
        controller: searchController,
        onChanged: onChangedSearch,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            bottom: (_filterBy.id == 4) ? 0 : 16,
            top: (_filterBy.id == 4) ? 5 : 0,
            left: 12,
            right: 12,
          ),
          hintText: hinText,
          hintStyle: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 4),
            child: Icon(Icons.search, size: 18, color: AppColor.GREY_TEXT),
          ),
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (searchController.text.isNotEmpty)
                InkWell(
                  onTap: _onClear,
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: _filterBy.id == 4 ? 0 : 8.0),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              if (_filterBy.id == 4) // Mã điểm bán
                PopupMenuButton<String>(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  constraints: const BoxConstraints(),
                  onSelected: onChangedTerminal,
                  itemBuilder: (BuildContext context) {
                    return widget.terminals.map((e) {
                      return PopupMenuItem<String>(
                        value: e.terminalCode,
                        child: Text(
                          e.terminalName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
            ],
          ),
          suffixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }

  void updateFromDate(DateTime dateTime) {
    _fromDate = dateTime;
    updateState();
  }

  void updateToDate(DateTime dateTime) {
    _toDate = dateTime;
    updateState();
  }

  void onChangeTimeFilter(DataFilter? value) {
    if (value == null) return;
    _filterByTime = value;
    updateState();
    DateTime endDate = DateTime(now.year, now.month, now.day);
    if (_filterByTime.id == TypeTimeFilter.TODAY.id ||
        _filterByTime.id == TypeTimeFilter.PERIOD.id) {
      DateTime fromDate = endDate;
      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      _onCallBack(fromDate: fromDate, toDate: endDate);
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
      DateTime fromDate = endDate.subtract(const Duration(days: 7));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      _onCallBack(fromDate: fromDate, toDate: endDate);
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (_filterByTime.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
      DateTime fromDate = endDate.subtract(const Duration(days: 30));
      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      _onCallBack(fromDate: fromDate, toDate: endDate);
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (_filterByTime.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
      DateTime fromDate = Jiffy(endDate).subtract(months: 3).dateTime;
      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      _onCallBack(fromDate: fromDate, toDate: endDate);
      updateFromDate(endDate);
      updateToDate(fromDate);
    }
  }

  Widget _removeFilterWidget() {
    if (_filterBy.id == 9 && _filterByTime.id == 1) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: () => _onClearFilter(clearData: true),
      child: Container(
        height: 34,
        margin: const EdgeInsets.only(left: 16),
        child: Row(
          children: const [
            Icon(Icons.remove_circle_outline,
                color: AppColor.BLUE_TEXT, size: 18),
            SizedBox(width: 4),
            Text('Xoá bộ lọc',
                style: TextStyle(fontSize: 10, color: AppColor.BLUE_TEXT)),
          ],
        ),
      ),
    );
  }

  Widget _searchWidget() {
    return InkWell(
      onTap: () => widget.onSearch(_filterByTime.id),
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColor.BLUE_TEXT,
        ),
        child: Image(
          image: ImageUtils.instance.getImageNetWork(AppImages.icSearchTrans),
          width: 28,
        ),
      ),
    );
  }

  void _onClearFilter({bool clearData = false}) {
    _value = '';
    _terminalCode = '';
    searchController.clear();
    _filterBy = listFilterBy.first;
    _filterByStatus = listFilterByStatus.first;
    _filterByTime = listFilterByTime.first;
    _fromDate = _formatFromDate(now);
    _toDate = _formatEndDate(now);
    _onCallBack(
        type: _filterBy.id,
        status: _filterByStatus.id,
        time: _filterByTime.id,
        fromDate: _fromDate,
        toDate: _toDate,
        search: _value,
        terminalCode: _terminalCode,
        clearData: clearData);
    updateState();
  }

  void _onClear() {
    _value = '';
    _terminalCode = '';
    searchController.clear();
    _onCallBack(search: _value, clearData: true, terminalCode: _terminalCode);
    updateState();
  }

  void updateState() {
    setState(() {});
  }

  void _pickToDate() async {
    DateTime? date = await TimeUtils.instance.showDateTimePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );
    int numberOfMonths =
        monthCalculator.calculateMonths(_fromDate, date ?? DateTime.now());

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((date ?? DateTime.now()).isBefore(_fromDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      updateToDate(date ?? DateTime.now());
      _onCallBack(toDate: _toDate);
    }
  }

  void _pickFromDate() async {
    DateTime? date = await TimeUtils.instance.showDateTimePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );

    int numberOfMonths =
        monthCalculator.calculateMonths(date ?? DateTime.now(), _toDate);

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((date ?? DateTime.now()).isAfter(_toDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      updateFromDate(date ?? DateTime.now());
      _onCallBack(fromDate: _fromDate);
    }
  }

  void _onExportExcel() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogExcelWidget(
          terminals: widget.terminals,
          bankId: widget.bankId,
        );
      },
    );
  }

  void onChangedTerminal(String value) {
    searchController.text = value;
    if (widget.isOwner || widget.isPending) {
      _value = value;
      _onCallBack(search: value);
    } else {
      _terminalCode = value;
      _onCallBack(terminalCode: value);
    }
    updateState();
  }

  void onChangedSearch(String value) {
    if (_filterBy.id == 4 && !widget.isOwner) {
      _terminalCode = value;
      _onCallBack(terminalCode: value);
    } else {
      _value = value;
      _onCallBack(search: value);
    }

    updateState();
  }
}
