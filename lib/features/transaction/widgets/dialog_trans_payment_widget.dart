import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/month_calculator.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'drop_down_trans_widget.dart';

class DialogTransPaymentWidget extends StatefulWidget {
  final int typeFilter;
  final int status;
  final int typeTime;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String terminalName;
  final Function(int, int, int, DateTime, DateTime) callBack;

  const DialogTransPaymentWidget({
    super.key,
    required this.typeFilter,
    required this.status,
    required this.typeTime,
    required this.callBack,
    this.fromDate,
    this.toDate,
    this.terminalName = '',
  });

  @override
  State<DialogTransPaymentWidget> createState() =>
      _DialogTransPaymentWidgetState();
}

class _DialogTransPaymentWidgetState extends State<DialogTransPaymentWidget> {
  MonthCalculator monthCalculator = MonthCalculator();

  List<DataFilter> listFilterBy = [
    const DataFilter(id: 9, name: 'Tất cả (mặc định)'),
    const DataFilter(id: 5, name: 'Trạng thái giao dịch'),
    const DataFilter(id: 1, name: 'Mã giao dịch'),
    const DataFilter(id: 4, name: 'Mã điểm bán'),
    const DataFilter(id: 2, name: 'Mã đơn hàng (Order ID)'),
    const DataFilter(id: 3, name: 'Nội dung'),
  ];

  List<DataFilter> listFilterByStatus = [
    const DataFilter(id: 0, name: 'Chờ thanh toán'),
    const DataFilter(id: 1, name: 'Thành công'),
    const DataFilter(id: 2, name: 'Đã huỷ'),
  ];

  List<DataFilter> listFilterByTime = [
    const DataFilter(id: 1, name: 'Hôm nay (mặc định)'),
    const DataFilter(id: 2, name: '7 ngày gần nhất'),
    const DataFilter(id: 3, name: '1 tháng gần đây'),
    const DataFilter(id: 4, name: '3 tháng gần đây'),
    const DataFilter(id: 5, name: 'Khoảng thời gian'),
  ];

  DataFilter _filterBy = const DataFilter(id: 9, name: 'Tất cả (mặc định)');
  DataFilter _filterByStatus = const DataFilter(id: 0, name: 'Chờ thanh toán');
  DataFilter _filterByTime =
      const DataFilter(id: 1, name: 'Hôm nay (mặc định)');

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() {
    updateToDate(widget.toDate ?? _toDate);
    updateFromDate(widget.fromDate ?? _fromDate);

    /// Get Filter by Filter
    int indexFilter =
        listFilterBy.indexWhere((element) => element.id == widget.typeFilter);
    if (indexFilter != -1) _filterBy = listFilterBy[indexFilter];

    /// Get Filter by status
    int indexStatus = listFilterByStatus
        .indexWhere((element) => element.id == widget.typeFilter);
    if (indexStatus != -1) _filterByStatus = listFilterByStatus[indexStatus];

    /// Get Filter by time
    int indexTime =
        listFilterByTime.indexWhere((element) => element.id == widget.typeTime);
    if (indexTime != -1) {
      _filterByTime = listFilterByTime[indexTime];
      if (_filterByTime.id != 5) onChangeTimeFilter(_filterByTime);
    }

    updateState();
  }

  void onReset() {
    _filterBy = const DataFilter(id: 9, name: 'Tất cả (mặc định)');
    _filterByStatus = const DataFilter(id: 0, name: 'Thành công');
    _filterByTime = const DataFilter(id: 1, name: 'Hôm nay (mặc định)');

    onChangeTimeFilter(_filterByTime);
  }

  void updateState() {
    setState(() {});
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  void _handleApply() {
    Navigator.pop(context);
    widget.callBack.call(
        _filterBy.id, _filterByStatus.id, _filterByTime.id, _fromDate, _toDate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleBack,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 450,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bộ lọc giao dịch',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: _handleBack,
                      child: const Icon(Icons.close, size: 14),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                if (widget.terminalName.isNotEmpty) ...[
                  const Text(
                    'Cửa hàng',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColor.GREY_TEXT.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.terminalName,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _buildFilterByWidget(),
                if (_filterBy.id == 5) _buildFilterByStatusWidget(),
                const SizedBox(height: 16),
                _buildFilterByTimeWidget(),
                const SizedBox(height: 12),
                if (_filterByTime.id == 5) _buildRangeTimeWidget(),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: 'Xoá bộ lọc',
                        textColor: AppColor.BLUE_TEXT,
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.25),
                        function: onReset,
                        borderRadius: 5,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ButtonWidget(
                        text: 'Áp dụng',
                        textColor: AppColor.WHITE,
                        bgColor: AppColor.BLUE_TEXT,
                        function: _handleApply,
                        borderRadius: 5,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterByWidget() {
    return DropdownTransWidget(
      title: 'Tìm kiếm theo',
      list: listFilterBy,
      filter: _filterBy,
      callBack: (value) {
        if (value == null) return;
        _filterBy = value;
        updateState();
      },
    );
  }

  Widget _buildFilterByStatusWidget() {
    return DropdownTransWidget(
      list: listFilterByStatus,
      filter: _filterByStatus,
      callBack: (value) {
        if (value == null) return;
        _filterByStatus = value;
        updateState();
      },
    );
  }

  Widget _buildFilterByTimeWidget() {
    return DropdownTransWidget(
      title: 'Thời gian',
      list: listFilterByTime,
      filter: _filterByTime,
      callBack: onChangeTimeFilter,
    );
  }

  Widget _buildRangeTimeWidget() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              DateTime? date = await showDateTimePicker(
                context: context,
                initialDate: _fromDate,
                firstDate: DateTime(2021, 6),
                lastDate: DateTime.now(),
              );

              int numberOfMonths = monthCalculator.calculateMonths(
                  date ?? DateTime.now(), _toDate);

              if (numberOfMonths > 3) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
              } else if ((date ?? DateTime.now()).isAfter(_toDate)) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
              } else {
                updateFromDate(date ?? DateTime.now());
              }
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border.all(color: AppColor.GREY_LIGHT),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Text(
                    'Từ ngày',
                    style: TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      TimeUtils.instance.formatDateToString(_fromDate),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 12,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () async {
              DateTime? date = await showDateTimePicker(
                context: context,
                initialDate: _toDate,
                firstDate: DateTime(2021, 6),
                lastDate: DateTime.now(),
              );
              int numberOfMonths = monthCalculator.calculateMonths(
                  _fromDate, date ?? DateTime.now());

              if (numberOfMonths > 3) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
              } else if ((date ?? DateTime.now()).isBefore(_fromDate)) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
              } else {
                updateToDate(date ?? DateTime.now());
              }
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border.all(color: AppColor.GREY_LIGHT),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Text(
                    'Đến ngày',
                    style: TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      TimeUtils.instance.formatDateToString(_toDate),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 12,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
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
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    if (_filterByTime.id == TypeTimeFilter.PERIOD.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.TODAY.id) {
      DateTime endDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 7));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (_filterByTime.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
      DateTime endDate = fromDate.subtract(const Duration(days: 30));

      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    } else if (_filterByTime.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
      DateTime endDate = Jiffy(fromDate).subtract(months: 3).dateTime;
      fromDate = fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(endDate);
      updateToDate(fromDate);
    }
  }
}

class DataFilter {
  final int id;
  final String name;

  const DataFilter({required this.id, required this.name});
}
