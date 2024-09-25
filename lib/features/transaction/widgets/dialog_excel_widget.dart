// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/month_calculator.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/transaction/repositories/transaction_repository.dart';
import 'package:VietQR/features/transaction/widgets/time_picker_dialog_with_seconds.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/models/transaction/data_filter.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/services/shared_references/shared_pref.dart';

import '../../../layouts/m_drop_widget.dart';
import '../../../services/shared_references/user_information_helper.dart';
import 'dialog_pick_date.dart';

class DialogExcelWidget extends StatefulWidget {
  final List<TerminalQRDTO> terminals;
  final String bankId;
  DateTime? selectFromDate;
  DateTime? selectToDate;

  DialogExcelWidget({
    Key? key,
    required this.terminals,
    required this.bankId,
    this.selectFromDate,
    this.selectToDate,
  }) : super(key: key);

  @override
  State<DialogExcelWidget> createState() => _DialogExcelWidgetState();
}

class _DialogExcelWidgetState extends State<DialogExcelWidget> {
  final monthCalculator = MonthCalculator();
  final repository = TransactionRepository();

  List<TerminalQRDTO> terminals = [];

  TerminalQRDTO terminalDTO = TerminalQRDTO();

  List<DataFilter> listFilterByTime = [
    const DataFilter(id: 1, name: 'Hôm qua'),
    const DataFilter(id: 2, name: 'Ngày'),
    const DataFilter(id: 3, name: 'Tháng'),
    const DataFilter(id: 4, name: 'Khoảng thời gian (mặc định)'),
  ];

  DataFilter _filterByTime =
      const DataFilter(id: 4, name: 'Khoảng thời gian (mặc định)');

  DateFormat get _format => DateFormat('yyyy/MM/dd HH:mm:ss');

  DateFormat get _formatDay => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime get now => DateTime.now();

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  void _handleBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    terminals = [...widget.terminals];
    terminalDTO = terminals.first;
    updateState();
  }

  void _handleExportExcel() async {
    DateTime? formattedDate;
    if (widget.selectFromDate != null) {
      formattedDate = DateTime(
          widget.selectFromDate!.year,
          widget.selectFromDate!.month,
          widget.selectFromDate!.day,
          _filterByTime.id != 4 ? 0 : widget.selectFromDate!.hour,
          _filterByTime.id != 4 ? 0 : widget.selectFromDate!.minute,
          _filterByTime.id != 4 ? 0 : widget.selectFromDate!.second);
    } else {
      formattedDate = DateTime(
          _fromDate.year,
          _fromDate.month,
          _fromDate.day,
          _filterByTime.id != 4 ? 0 : _fromDate.hour,
          _filterByTime.id != 4 ? 0 : _fromDate.minute,
          _filterByTime.id != 4 ? 0 : _fromDate.second);
    }

    final result = await repository.exportExcel(
        widget.bankId,
        _formatDay.format(formattedDate),
        _formatDay.format(widget.selectToDate ?? _toDate),
        terminalDTO.terminalCode);

    downloadFile(result);
  }

  void downloadFile(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = 'trans.xlsx'; // Set the desired file name
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          width: 350,
          height: 450,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Xuất Excel',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                  InkWell(
                    onTap: _handleBack,
                    child: const Icon(Icons.close, size: 14),
                  )
                ],
              ),
              const SizedBox(height: 40),
              _buildDropListTerminal(),
              const SizedBox(height: 24),
              _buildFilterByTimeWidget(),
              if (_filterByTime.id != 4 && _filterByTime.id != 1) ...[
                const SizedBox(height: 8),
                _pickDateWithDay(),
              ],
              if (_filterByTime.id == 4) ...[
                const SizedBox(height: 24),
                _buildRangeTimeWidget(),
              ],
              const Spacer(),
              ButtonWidget(
                text: 'Xuất Excel',
                textColor: AppColor.WHITE,
                bgColor: AppColor.DARK_GREEN,
                function: _handleExportExcel,
                borderRadius: 5,
                height: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get textByDay =>
      '${_fromDate.day} tháng ${DateFormat('MM').format(_fromDate)} năm ${_fromDate.year}';

  String get textByMonth =>
      'Tháng ${DateFormat('MM').format(_fromDate)} năm ${_fromDate.year}';

  Widget _buildRangeTimeWidget() {
    return Row(
      children: [
        Expanded(
            child:
                _pickTime(date: widget.selectFromDate, onTap: _pickFromDate)),
        const SizedBox(width: 8),
        Expanded(
            child: _pickTime(
                title: 'Đến ngày',
                date: widget.selectToDate ?? _toDate,
                onTap: _pickToDate)),
      ],
    );
  }

  Widget _pickTime({String? title, DateTime? date, GestureTapCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Từ ngày',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _format.format(date ?? _fromDate),
                    style: const TextStyle(fontSize: 12, height: 1.4),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.calendar_month_outlined, size: 14),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _pickToDate() async {
    DateTime formattedDate =
        DateTime(_toDate.year, _toDate.month, _toDate.day, 23, 59, 59);
    DateTime? date = await TimeUtils.instance.showDateTimePicker(
      context: context,
      initialDate: formattedDate,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );
    int numberOfMonths = monthCalculator.calculateMonths(
        _fromDate, widget.selectToDate ?? date ?? DateTime.now());

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((date ?? DateTime.now()).isBefore(_fromDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      // updateToDate(widget.selectToDate ?? date ?? DateTime.now());
      updateToDate(date ?? widget.selectToDate ?? DateTime.now());
    }
  }

  void _pickFromDate() async {
    DateTime formattedDate =
        DateTime(_fromDate.year, _fromDate.month, _fromDate.day, 0, 0, 0);
    DateTime? date = await TimeUtils.instance.showDateTimePicker(
      context: context,
      initialDate: formattedDate,
      firstDate: DateTime(2021, 6),
      lastDate: DateTime.now(),
    );

    int numberOfMonths = monthCalculator.calculateMonths(
        widget.selectFromDate ?? date ?? DateTime.now(), _toDate);

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((date ?? DateTime.now()).isAfter(_toDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      // updateFromDate(widget.selectFromDate ?? date ?? DateTime.now());
      updateFromDate(date ?? widget.selectFromDate ?? DateTime.now());
    }
  }

  Widget _pickDateWithDay() {
    return GestureDetector(
      onTap: _onPickDateWithDay,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColor.WHITE,
          border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _filterByTime.id == 2 ? textByDay : textByMonth,
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.calendar_month_outlined, size: 14),
          ],
        ),
      ),
    );
  }

  void _onPickMonth() async {
    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              dateTime: _fromDate,
            ),
          ),
        );
      },
    );

    if (result != null && result is DateTime) {
      int year = result.year;
      int month = result.month; // March

      DateTime firstDayOfMonth = DateTime(year, month, 1);
      DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

      _fromDate = firstDayOfMonth;
      _toDate = lastDayOfMonth
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateState();
    }
  }

  void _onPickDateWithDay() async {
    if (_filterByTime.id == 2) {
      DateTime? date = await TimeUtils.instance.showDateTimePicker(
        context: context,
        initialDate: _fromDate,
        firstDate: DateTime(2021, 6),
        lastDate: DateTime.now(),
        isSelectedTime: false,
      );

      DateTime value = date ?? DateTime(now.year, now.month, now.day);

      _fromDate = DateTime(value.year, value.month, value.day);
      _toDate = _fromDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateState();
    } else {
      _onPickMonth();
    }
  }

  Widget _buildDropListTerminal() {
    return MDropWidget<TerminalQRDTO>(
      title: 'Cửa hàng',
      list: terminals,
      filter: terminalDTO,
      callBack: updateTerminal,
    );
  }

  Widget _buildFilterByTimeWidget() {
    return MDropWidget<DataFilter>(
      title: 'Thời gian',
      list: listFilterByTime,
      filter: _filterByTime,
      callBack: onChangeTimeFilter,
    );
  }

  void updateFromDate(DateTime dateTime) {
    _fromDate = dateTime;
    widget.selectFromDate = dateTime;
    updateState();
  }

  void updateToDate(DateTime dateTime) {
    _toDate = dateTime;
    widget.selectToDate = dateTime;
    updateState();
  }

  void onChangeTimeFilter(DataFilter? value) {
    if (value == null) return;
    _filterByTime = value;
    updateState();
    DateTime endDate = DateTime(now.year, now.month, now.day);
    if (_filterByTime.id == 1 || _filterByTime.id == 4) {
      DateTime fromDate = endDate.subtract(const Duration(days: 1));
      endDate = endDate.subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == 2) {
      DateTime fromDate = endDate;
      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == 3) {
      DateTime fromDate = endDate.subtract(const Duration(days: 30));
      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    }
  }

  void updateState() {
    setState(() {});
  }

  void updateTerminal(TerminalQRDTO? value) {
    if (value == null) return;
    terminalDTO = value;
    updateState();
  }
}
