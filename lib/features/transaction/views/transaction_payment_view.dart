import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_bank_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_trans_payment_widget.dart';
import 'package:VietQR/features/transaction/widgets/table_trans_payment_widget.dart';
import 'package:VietQR/features/transaction/widgets/trans_header_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class TransactionPaymentView extends StatefulWidget {
  const TransactionPaymentView({super.key});

  @override
  State<TransactionPaymentView> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<TransactionPaymentView> {
  late TransactionBloc bloc;

  double get width => MediaQuery.of(context).size.width;

  bool get isMobile => (PlatformUtils.instance.resizeWhen(width, 650));

  final searchController = TextEditingController();

  int typeFilter = 9;
  int statusFilter = 0;
  int typeTime = 1;
  String _value = '';
  String _bankId = '';
  bool _isOwner = false;

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

  void _onChooseBank(List<BankAccountDTO> list) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogChooseBankWidget(banks: list);
      },
    );

    if (data != null && data is BankAccountDTO) {
      bloc.add(UpdateBankAccountEvent(data));
      html.window.history.pushState(
          null,
          '/transactions?type=0?bankId=$_bankId',
          '/transactions?type=0?bankId=${data.bankId}');
      setState(() {
        _bankId = data.bankId;
      });
      _onSearch();
    }
  }

  void loadMore(int offset) {
    if (typeFilter == 5) {
      _value = '$statusFilter';
    }
    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      offset: offset,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
      value: _value,
      type: typeFilter,
      status: statusFilter,
    );

    if (_isOwner) {
      bloc.add(GetTransOwnerEvent(dto: dto, isLoadMore: true));
    } else {
      bloc.add(GetTransNotOwnerEvent(dto: dto, isLoadMore: true));
    }
  }

  void _onSearch() {
    if (typeFilter == 5) {
      _value = '$statusFilter';
      searchController.clear();
    }
    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      offset: 0,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
      value: _value,
      type: typeFilter,
      status: statusFilter,
    );

    if (_isOwner) {
      bloc.add(GetTransOwnerEvent(dto: dto));
    } else {
      bloc.add(GetTransNotOwnerEvent(dto: dto));
    }
  }

  void _onFilter() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogTransPaymentWidget(
          typeFilter: typeFilter,
          status: statusFilter,
          typeTime: typeTime,
          fromDate: _fromDate,
          toDate: _toDate,
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

  void _onClear() {
    _value = '';
    searchController.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    bloc = TransactionBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetListBankEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => bloc,
      child: Material(
        color: AppColor.GREY_BG,
        child: (!isMobile)
            ? const WebMobileBlankWidget()
            : BlocConsumer<TransactionBloc, TransactionState>(
                listener: (context, state) {
                  if (state.request == TransType.GET_BANKS) {
                    setState(() {
                      _bankId = state.bankDTO?.bankId ?? '';
                      _isOwner = state.bankDTO?.isOwner ?? false;
                    });

                    html.window.history.pushState(
                        null,
                        '/transactions?type=0?bankId=$_bankId',
                        '/transactions?type=0?bankId=$_bankId');

                    TransactionInputDTO dto = TransactionInputDTO(
                      bankId: _bankId,
                      offset: 0,
                      from: TimeUtils.instance.getCurrentDate(DateTime.now()),
                      to: TimeUtils.instance.getCurrentDate(DateTime.now()),
                      value: '',
                      type: 9,
                      terminalCode: '',
                      status: 0,
                    );

                    if (_isOwner) {
                      bloc.add(GetTransOwnerEvent(dto: dto));
                    } else {
                      bloc.add(GetTransNotOwnerEvent(dto: dto));
                    }
                  }
                },
                builder: (context, state) {
                  return TransHeaderWidget(
                    title: 'Giao dịch thanh toán',
                    dto: state.bankDTO,
                    onTap: () => _onChooseBank(state.listBanks),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...[
                            const Text(
                              'Kết quả bán hàng',
                              style: TextStyle(
                                  color: AppColor.BLACK,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            const Text(
                              'hôm nay',
                              style: TextStyle(
                                  color: AppColor.BLACK,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            const SizedBox(height: 24),
                          ],
                          Row(
                            children: [
                              _buildInfoPayment(
                                title: 'Tất cả GD',
                                totalTrans: '0',
                                amount: '0',
                                des: 'Doanh thu',
                              ),
                              _buildInfoPayment(
                                title: 'Giao dịch đã hạch toán',
                                totalTrans: '0',
                                amount: '0',
                                amountColor: AppColor.GREEN,
                                des: 'Doanh thu',
                              ),
                              _buildInfoPayment(
                                title: 'Giao dịch chờ hạch toán',
                                totalTrans: '0',
                                amount: '0',
                                des: 'Doanh thu',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildFilterWidget(),
                          const SizedBox(height: 24),
                          TableTransPaymentWidget(
                              list: state.tranMaps['${state.offset}'] ?? [],
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
                                          color: state.offset <= 0
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 14,
                                      color: state.offset <= 0
                                          ? Colors.grey
                                          : Colors.black,
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
                                        color: !state.isLoadMore
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: !state.isLoadMore
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
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
    if (typeFilter == 4) return 'Tìm kiếm mã điểm bán';
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
        style: const TextStyle(fontSize: 10, color: AppColor.BLUE_TEXT),
      ),
    );
  }

  Widget _buildFilterWidget() {
    return Row(
      children: [
        const Text(
          'Danh sách giao dịch\nthanh toán',
          style: TextStyle(
              color: AppColor.BLACK, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        const SizedBox(width: 24),
        Container(
          width: 200,
          height: 34,
          decoration: BoxDecoration(
            color: AppColor.GREY_BG,
            border: Border.all(color: AppColor.GREY_LIGHT),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            style: const TextStyle(fontSize: 12),
            controller: searchController,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(bottom: 16, left: 12, right: 12),
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
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _onFilter,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColor.BLUE_TEXT.withOpacity(0.25),
            ),
            child: Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.icFilterTrans),
              width: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _onSearch,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColor.BLUE_TEXT,
            ),
            child: Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.icSearchTrans),
              width: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
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

  Widget _buildInfoPayment({
    String title = '',
    String totalTrans = '',
    String amount = '',
    String des = '',
    Color? amountColor,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.GREY_TEXT,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          Text(
            '$totalTrans giao dịch đến',
            style: const TextStyle(
              color: AppColor.BLACK,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          Row(
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: amountColor ?? AppColor.BLUE_TEXT,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const Text(
                ' VND',
                style: TextStyle(
                  color: AppColor.GREY_TEXT,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
          Text(
            des,
            style: const TextStyle(
              color: AppColor.GREY_TEXT,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
