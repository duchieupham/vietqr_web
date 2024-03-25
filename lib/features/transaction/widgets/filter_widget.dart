import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/month_calculator.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../../models/transaction/data_filter.dart';
import 'drop_down_trans_widget.dart';

class FilterWidget extends StatefulWidget {
  final Function(int?, int?, int?, String?, DateTime?, DateTime?, bool)
      callBack;
  final Function(int) onSearch;
  final Stream<bool> stream;

  const FilterWidget(
      {super.key,
      required this.callBack,
      required this.onSearch,
      required this.stream});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final monthCalculator = MonthCalculator();
  final searchController = TextEditingController();

  DateFormat get _format => DateFormat('yyyy/MM/dd HH:mm:ss');

  DateTime get now => DateTime.now();

  String _value = '';
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
        const SizedBox(height: 16),
        Row(
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
            ButtonWidget(
              text: 'Xuất Excel',
              width: 100,
              border: Border.all(color: AppColor.GREEN),
              textColor: AppColor.GREEN,
              bgColor: AppColor.TRANSPARENT,
              function: () {},
              borderRadius: 5,
              height: 34,
            ),
          ],
        ),
      ],
    );
  }

  void _onCallBack({
    int? type,
    int? time,
    int? status,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearData = false,
  }) {
    widget.callBack
        .call(type, time, status, search, fromDate, toDate, clearData);
  }

  Widget _buildFilterByWidget() {
    return SizedBox(
      width: 170,
      child: DropdownTransWidget(
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
      child: DropdownTransWidget(
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
      child: DropdownTransWidget(
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
      width: 220,
      height: 34,
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(5),
        ),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 12),
        controller: searchController,
        onChanged: (value) {
          _value = value;
          _onCallBack(search: value);
          updateState();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(bottom: 16, left: 12, right: 12),
          hintText: hinText,
          hintStyle: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 4),
            child: Icon(Icons.search, size: 18, color: AppColor.GREY_TEXT),
          ),
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: _onClear,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.close, size: 18),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
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
    if (_filterByTime.id == TypeTimeFilter.PERIOD.id) {
      DateTime fromDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      _onCallBack(fromDate: fromDate, toDate: endDate);
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.TODAY.id) {
      DateTime fromDate = endDate
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
        clearData: clearData);
    updateState();
  }

  void _onClear() {
    _value = '';
    searchController.clear();
    _onCallBack(search: _value, clearData: true);
    updateState();
  }

  void updateState() {
    setState(() {});
  }

  void _pickToDate() async {
    DateTime? date = await showDateTimePicker(
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
    DateTime? date = await showDateTimePicker(
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
}
