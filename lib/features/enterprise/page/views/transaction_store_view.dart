import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/enterprise/enterprise.dart';
import 'package:VietQR/features/enterprise/page/widgets/dialog_filter_trans_widget.dart';
import 'package:VietQR/features/enterprise/page/widgets/table_transaction_store_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionStoreView extends StatefulWidget {
  final String terminalId;

  const TransactionStoreView({super.key, required this.terminalId});

  @override
  State<TransactionStoreView> createState() => _TransactionStoreViewState();
}

class _TransactionStoreViewState extends State<TransactionStoreView> {
  double get width => MediaQuery.of(context).size.width;

  bool get isKWeb => (PlatformUtils.instance.resizeWhen(width, 1360));

  late EnterpriseBloc bloc;
  final searchController = TextEditingController();
  int typeFilter = 9;
  int statusFilter = 0;
  int typeTime = 1;
  String _value = '';

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  DateFormat get _dateFormat => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateFormat get _dateFormatShow => DateFormat('dd-MM-yyyy HH:mm:ss');

  DateTime get now => DateTime.now();

  DateTime _formatFromDate(DateTime now) {
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    return fromDate;
  }

  DateTime _endDate(DateTime now) {
    DateTime fromDate = _formatFromDate(now);
    return fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    bloc = EnterpriseBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fromDate = _formatFromDate(now);
      _toDate = _endDate(now);

      bloc.add(GetStoreDetailEvent(widget.terminalId));
      bloc.add(GetTransStoreEvent(
        type: typeFilter,
        terminalId: widget.terminalId,
        fromDate: _dateFormat.format(_fromDate),
        toDate: _dateFormat.format(_toDate),
        keySearch: _value,
      ));
    });
  }

  void loadMore(int offset) {
    if (typeFilter == 5) {
      _value = '$statusFilter';
    }
    bloc.add(GetTransStoreEvent(
      type: typeFilter,
      terminalId: widget.terminalId,
      fromDate: _dateFormat.format(_fromDate),
      toDate: _dateFormat.format(_toDate),
      keySearch: _value,
      offset: offset,
      loadMore: true,
    ));
  }

  void _onSearch() {
    if (typeFilter == 5) {
      _value = '$statusFilter';
    }
    bloc.add(GetTransStoreEvent(
      type: typeFilter,
      terminalId: widget.terminalId,
      fromDate: _dateFormat.format(_fromDate),
      toDate: _dateFormat.format(_toDate),
      keySearch: _value,
    ));
  }

  void _onClear() {
    _value = '';
    searchController.clear();
    setState(() {});
  }

  void _onFilter(String terminalName) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogFilterTransWidget(
          typeFilter: typeFilter,
          status: statusFilter,
          typeTime: typeTime,
          fromDate: _fromDate,
          toDate: _toDate,
          terminalName: terminalName,
          callBack: _onReceive,
        );
      },
    );
  }

  _onReceive(
      int type, int status, int time, DateTime fromDate, DateTime toDate) {
    setState(() {
      typeFilter = type;
      statusFilter = status;
      typeTime = time;
      _fromDate = fromDate;
      _toDate = toDate;
    });

    if (type == 9 || type == 5) {
      _onSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EnterpriseBloc>(
      create: (context) => bloc,
      child: BlocConsumer<EnterpriseBloc, EnterpriseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isKWeb) ...[
                _buildHeaderWeb(context, state),
                const SizedBox(height: 40),
                _buildBodyWeb(state),
              ] else ...[
                _buildHeaderMobile(context, state),
                const SizedBox(height: 40),
                _buildBodyMobile(state),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderWeb(BuildContext context, EnterpriseState state) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Danh sách giao dịch',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('0 giao dịch'),
          ],
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => _onFilter(state.storeDetailModel.name),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: AppColor.BLUE_TEXT.withOpacity(0.25),
            ),
            child: const Icon(Icons.filter_list, color: AppColor.WHITE),
          ),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 12, right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.GREY_BG,
            border: Border.all(color: AppColor.GREY_LIGHT),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            style: const TextStyle(fontSize: 12),
            controller: searchController,
            enabled: typeFilter != 5,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 18),
              border: InputBorder.none,
              hintText: hinText,
              hintStyle:
                  const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _onClear,
                      child: const Icon(Icons.close, size: 18),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(),
            ),
          ),
        ),
        GestureDetector(
          onTap: _onSearch,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: AppColor.BLUE_TEXT,
            ),
            child: const Icon(Icons.search, color: AppColor.WHITE),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lọc theo:',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              ),
              const SizedBox(height: 4),
              Wrap(
                children: [
                  if (typeFilter == 9) _buildFilterWith('Tất cả (mặc định)'),
                  _buildFilterWith('Thời gian: $timeValue'),
                  if (typeFilter == 1)
                    _buildFilterWith('Mã giao dịch: ${searchController.text}'),
                  if (typeFilter == 3)
                    _buildFilterWith('Nội dung: ${searchController.text}'),
                  if (typeFilter == 5)
                    _buildFilterWith('Trạng thái: $statusValue'),
                  if (typeFilter == 2)
                    _buildFilterWith('Mã đơn hàng: ${searchController.text}'),
                ],
              ),
            ],
          ),
        ),
        ButtonWidget(
          text: 'Xuất Excel',
          width: 120,
          border: Border.all(color: AppColor.GREEN),
          textColor: AppColor.GREEN,
          bgColor: AppColor.TRANSPARENT,
          function: () {
            Navigator.pop(context);
          },
          borderRadius: 5,
          height: 40,
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  String get statusValue => statusFilter == 0
      ? 'Thành công'
      : statusFilter == 1
          ? 'Chờ thanh toán'
          : 'Đã huỷ';

  String get timeValue {
    if (typeTime == 1) return 'Hôm nay (mặc định)';
    if (typeTime == 2) return '7 ngày gần nhất';
    if (typeTime == 3) return '1 tháng gần đây';
    if (typeTime == 4) return '3 tháng gần đây';
    return 'Từ ${_dateFormatShow.format(_fromDate)} - đến ${_dateFormatShow.format(_toDate)}';
  }

  String get hinText {
    if (typeFilter == 1) return 'Tìm kiếm theo mã giao dịch';
    if (typeFilter == 2) return 'Tìm kiếm theo mã đơn hàng';
    if (typeFilter == 3) return 'Tìm kiếm theo nội dung';
    return 'Tìm kiếm giao dịch';
  }

  Widget _buildFilterWith(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.BLUE_TEXT.withOpacity(0.3),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
      ),
    );
  }

  Widget _buildHeaderMobile(BuildContext context, EnterpriseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Danh sách giao dịch',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${state.transactions.length} giao dịch'),
                ],
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _onFilter(state.storeDetailModel.name),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.BLUE_TEXT.withOpacity(0.25),
                  ),
                  child: const Icon(Icons.filter_list, color: AppColor.WHITE),
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 12, right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  controller: searchController,
                  enabled: typeFilter != 5,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 18),
                    border: InputBorder.none,
                    enabled: typeFilter != 5,
                    hintText: hinText,
                    hintStyle: const TextStyle(
                        fontSize: 12, color: AppColor.GREY_TEXT),
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _onClear,
                            child: const Icon(Icons.close, size: 18),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _onSearch,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.BLUE_TEXT,
                  ),
                  child: const Icon(Icons.search, color: AppColor.WHITE),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ButtonWidget(
              text: 'Xuất Excel',
              width: 120,
              border: Border.all(color: AppColor.GREEN),
              textColor: AppColor.GREEN,
              bgColor: AppColor.TRANSPARENT,
              function: () {
                Navigator.pop(context);
              },
              borderRadius: 5,
              height: 40,
            ),
            const SizedBox(width: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyWeb(EnterpriseState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: TableTransactionStoreWidget(
                  trans: state.transactionsMap['${state.offset}'] ?? [],
                  offset: state.offset)),
          Container(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Text('Trang ${state.offset + 1}'),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    int offset = state.offset;
                    if (offset <= 0) return;
                    offset = offset - 1;
                    loadMore(offset);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color:
                              state.offset <= 0 ? Colors.grey : Colors.black),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: state.offset <= 0 ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (!state.isLoadMore) return;
                    int offset = state.offset;
                    offset = offset + 1;
                    loadMore(offset);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: !state.isLoadMore ? Colors.grey : Colors.black,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: !state.isLoadMore ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMobile(EnterpriseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableTransactionStoreWidget(
            trans: state.transactionsMap['${state.offset}'] ?? [],
            offset: state.offset),
        Container(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              Text('Trang ${state.offset + 1}'),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  int offset = state.offset;
                  if (offset <= 0) return;
                  offset = offset - 1;
                  loadMore(offset);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: state.offset <= 0 ? Colors.grey : Colors.black),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: state.offset <= 0 ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (!state.isLoadMore) return;
                  int offset = state.offset;
                  offset = offset + 1;
                  loadMore(offset);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: !state.isLoadMore ? Colors.grey : Colors.black,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: !state.isLoadMore ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
