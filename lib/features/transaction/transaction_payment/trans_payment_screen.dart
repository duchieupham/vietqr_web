import 'dart:async';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/layouts/dialog/choose_bank_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_terminal_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_edit_note_widget.dart';
import 'package:VietQR/features/transaction/widgets/filter_widget.dart';
import 'package:VietQR/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:VietQR/features/transaction/widgets/table_trans_widget.dart';
import 'package:VietQR/features/transaction/widgets/trans_header_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class TransactionPaymentView extends StatefulWidget {
  const TransactionPaymentView({super.key});

  @override
  State<TransactionPaymentView> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<TransactionPaymentView> {
  late TransactionBloc bloc;

  final _streamController = StreamController<bool>.broadcast();
  late Stream<bool> filterStream;

  double get width => MediaQuery.of(context).size.width;

  bool get isMobile => (PlatformUtils.instance.resizeWhen(width, 650));

  final _controller = TextEditingController();

  /// 3,4,9 value = "" => get all trans
  int _typeFilter = 9;
  int _typeStatus = 0;
  int _typeTime = 1;
  String _value = '';
  String _terminalCode = '';
  String _bankId = '';
  bool _isOwner = false;

  List<String> listTimeKey = [];

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  DateFormat get _dateFormat => DateFormat('yyyy-MM-dd HH:mm:ss');

  DateFormat get _dateFormatShow => DateFormat('dd-MM-yyyy HH:mm:ss');

  DateTime get now =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get _formatFromDate => now.subtract(const Duration(days: 7));

  DateTime get _formatEndDate => _formatFromDate
      .add(const Duration(days: 8))
      .subtract(const Duration(seconds: 1));

  String get timeValue {
    if (_typeTime == 1) return 'Hôm nay (mặc định)';
    if (_typeTime == 2) return '7 ngày gần nhất';
    if (_typeTime == 3) return '1 tháng gần đây';
    if (_typeTime == 4) return '3 tháng gần đây';
    return 'Từ ${_dateFormatShow.format(_fromDate)} - đến ${_dateFormatShow.format(_toDate)}';
  }

  void _onCallAPi(TransactionInputDTO dto, {String timeKey = ''}) {
    if (_isOwner) {
      bloc.add(GetTransOwnerEvent(dto: dto, timeKey: timeKey));
    } else {
      bloc.add(GetTransNotOwnerEvent(dto: dto, timeKey: timeKey));
    }
  }

  void getTotalTransByDay() {
    String from = _dateFormat.format(now);
    String to = _dateFormat.format(
        now.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)));

    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      from: from,
      to: to,
      terminalCode: _terminalCode,
    );
    bloc.add(GetTotalTransEvent(dto: dto));
  }

  void loadMore(int offset, bool loadMore) {
    if (_typeFilter == 5) {
      _value = '$_typeStatus';
    }
    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      offset: offset,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
      value: _value,
      type: _typeFilter,
      status: _typeStatus,
      terminalCode: _terminalCode,
    );

    if (_isOwner) {
      bloc.add(FetchTransOwnerEvent(dto: dto, loadMore: loadMore));
    } else {
      bloc.add(FetchTransNotOwnerEvent(dto: dto, loadMore: loadMore));
    }
  }

  void _onSearch(int time) {
    _typeTime = time;
    updateState();

    int type = _typeFilter;
    if (type == 5) {
      _value = '$_typeStatus';
      _controller.clear();
    }
    if (_typeFilter == 9 && _value.isNotEmpty) {
      type = 1;
    }

    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      offset: 0,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
      value: _value,
      type: type,
      status: _typeStatus,
      terminalCode: _terminalCode,
    );

    if (_typeFilter == 9 && _value.isEmpty) {
      _onCallAPi(dto, timeKey: _typeTime.timeKeyExt.name);
      return;
    }
    if (_isOwner) {
      bloc.add(
          FetchTransOwnerEvent(dto: dto, loadMore: true, clickSearch: true));
    } else {
      if (_typeFilter == 4) dto.type = 9;

      bloc.add(
          FetchTransNotOwnerEvent(dto: dto, loadMore: true, clickSearch: true));
    }
  }

  _onReceive(
      int? type,
      int? time,
      int? status,
      String? search,
      String? terminalCode,
      DateTime? fromDate,
      DateTime? toDate,
      bool clearData) {
    _typeFilter = type ?? _typeFilter;
    _typeTime = time ?? _typeTime;
    _typeStatus = status ?? _typeStatus;
    _value = search ?? _value;
    _fromDate = fromDate ?? _fromDate;
    _toDate = toDate ?? _toDate;
    _terminalCode = terminalCode ?? _terminalCode;
    updateState();

    if (clearData) {
      bloc.add(UpdateCacheDataEvent(
          timeKey: _typeTime.timeKeyExt.name, clearData: clearData));
    }
  }

  void loadAll() {
    _fromDate = _formatFromDate;
    _toDate = _formatEndDate;
    updateState();

    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
      terminalCode: _terminalCode,
    );

    _onCallAPi(dto, timeKey: _typeTime.timeKeyExt.name);
  }

  @override
  void initState() {
    super.initState();
    bloc = TransactionBloc();
    filterStream = _streamController.stream;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetListBankEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => bloc,
      child: Material(
        color: AppColor.BLUE_BGR,
        child: (!isMobile)
            ? const WebMobileBlankWidget()
            : BlocConsumer<TransactionBloc, TransactionState>(
                listener: (context, state) async {
                  if (state.request == TransType.UPDATE_TERMINAL ||
                      state.request == TransType.UPDATE_NOTE) {
                    Fluttertoast.showToast(
                      msg: 'Cập nhật thành công',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).hintColor,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    );
                  }

                  if (state.request == TransType.UPDATE_BANK) {
                    bloc.add(GetTerminalsEvent(_bankId));
                    getTotalTransByDay();
                  }

                  if (state.request == TransType.GET_BANKS) {
                    bloc.add(GetTerminalsEvent(state.bankDTO?.bankId ?? ''));

                    setState(() {
                      _bankId = state.bankDTO?.bankId ?? '';
                      _isOwner = state.bankDTO?.isOwner ?? false;
                    });

                    // html.window.history.pushState(
                    //     null,
                    //     '/transactions?type=0?bankId=$_bankId',
                    //     '/transactions?type=0?bankId=$_bankId');

                    html.window.history.pushState(
                        null, '/transactions/list', '/transactions/list');
                    getTotalTransByDay();
                    loadAll();
                  }

                  if (state.request == TransType.ERROR) {
                    await DialogWidget.instance.openMsgDialog(
                        title: 'Thông báo', msg: state.msg ?? '');
                  }

                  if (state.request == TransType.GET_TRANS_TRUE) {
                    listTimeKey = [...state.keys];
                    updateState();
                  }

                  if (state.request == TransType.UPDATE_OFFSET) {
                    loadMore(state.offset, state.isLoadMore);
                  }
                },
                builder: (context, state) {
                  return TransHeaderWidget(
                    title: 'Giao dịch thanh toán',
                    dto: state.bankDTO,
                    onTap: () => _onChooseBank(state.listBanks),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kết quả bán hàng hôm nay',
                                style: TextStyle(
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildInfoPayment(
                                    title: 'Tất cả GD',
                                    totalTrans:
                                        '${state.totalTransDTO?.totalTrans ?? ''}',
                                    amount:
                                        state.totalTransDTO?.getCashIn ?? '',
                                    des: 'Doanh thu',
                                  ),
                                  _buildInfoPayment(
                                    title: 'Giao dịch đã hạch toán',
                                    totalTrans:
                                        '${state.totalTransDTO?.totalSettled ?? ''}',
                                    amount:
                                        state.totalTransDTO?.getCashSettled ??
                                            '',
                                    amountColor: AppColor.GREEN,
                                    des: 'Doanh thu',
                                  ),
                                  _buildInfoPayment(
                                    title: 'Giao dịch chờ hạch toán',
                                    totalTrans:
                                        '${state.totalTransDTO?.totalUnsettled ?? ''}',
                                    amount:
                                        state.totalTransDTO?.getCashUnsettled ??
                                            '',
                                    des: 'Doanh thu',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomPaint(
                            painter: HorizontalDashedLine(
                                dashWidth: 5, dashSpace: 3),
                            size: const Size(double.infinity, 1),
                          ),
                          const SizedBox(height: 16),
                          FilterWidget(
                            dto: state.bankDTO,
                            stream: filterStream,
                            callBack: _onReceive,
                            onSearch: _onSearch,
                            terminals: state.terminals,
                            bankId: _bankId,
                            isOwner: _isOwner,
                          ),
                          const SizedBox(height: 24),
                          CustomPaint(
                            painter: HorizontalDashedLine(
                                dashWidth: 5, dashSpace: 3),
                            size: const Size(double.infinity, 1),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Danh sách GD thanh toán',
                                style: TextStyle(
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                              _refreshWidget(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TableTransWidget(
                            list: state.isCache
                                ? state.mapLocals[_typeTime.timeKeyExt.name] ??
                                    []
                                : state.maps['${state.offset}'] ?? [],
                            offset: state.offset,
                            isOwner: state.bankDTO?.isOwner ?? false,
                            onChooseTerminal: (transDTO) => _onChooseTerminal(
                                state.terminals, state.offset, transDTO),
                            onEditNote: (dto) =>
                                _onChooseNote(state.offset, dto),
                            isLoading: state.status == BlocStatus.LOADING,
                          ),
                          _buildPageWidget(state),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  ///
  void _onChooseTerminal(
      List<TerminalQRDTO> list, int offset, TransReceiveDTO transDTO) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogChooseTerminalWidget(
          terminals: list,
          transDTO: transDTO,
          update: (value, terminalId) {
            if (value.isEmpty) return;
            bloc.add(
              UpdateTerminalEvent(
                  transactionId: transDTO.transactionId,
                  terminalCode: value,
                  offset: offset,
                  timeKey: _typeTime.timeKeyExt.name),
            );
          },
        );
      },
    );
  }

  void _onChooseBank(List<BankAccountDTO> list) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ChooseBankWidget(banks: list);
      },
    );

    if (data != null && data is BankAccountDTO) {
      _streamController.add(true);
      bloc.add(UpdateBankAccountEvent(data));
      html.window.history
          .pushState(null, '/transactions/list', '/transactions/list');
      _bankId = data.bankId;
      _isOwner = data.isOwner;
      loadAll();
    }
  }

  ///
  void _onChooseNote(int offset, TransReceiveDTO dto) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogUpdateNoteWidget(
          dto: dto,
          update: (value) {
            bloc.add(
              UpdateNoteEvent(
                  dto: value,
                  offset: offset,
                  timeKey: _typeTime.timeKeyExt.name),
            );
          },
        );
      },
    );
  }

  Widget _buildPageWidget(TransactionState state) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: 60,
      child: Row(
        children: [
          Text('Trang ${state.offset + 1}'),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              int offset = state.offset;
              if (offset <= 0) return;
              offset = offset - 1;
              bloc.add(UpdateOffsetEvent(offset));
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
              bloc.add(UpdateOffsetEvent(offset));
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
    );
  }

  Widget _buildInfoPayment(
      {String title = '',
      String totalTrans = '',
      String amount = '',
      String des = '',
      Color? amountColor}) {
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

  Widget _refreshWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: InkWell(
        onTap: () => _onSearch(1),
        child: Container(
          width: 180,
          height: 34,
          // margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 0.5),
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.refresh,
                color: AppColor.BLUE_TEXT,
                size: 16,
              ),
              Padding(padding: EdgeInsets.only(left: 5)),
              Text(
                'Cập nhật danh sách GD',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    if (_streamController.hasListener) {
      _streamController.close();
    }
    super.dispose();
  }
}
