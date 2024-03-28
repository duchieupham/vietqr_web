import 'dart:async';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_bank_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_terminal_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_edit_note_widget.dart';
import 'package:VietQR/features/transaction/widgets/filter_widget.dart';
import 'package:VietQR/layouts/horizontal_dashedline_painter.dart';
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

class TransUnclassifiedView extends StatefulWidget {
  const TransUnclassifiedView({super.key});

  @override
  State<TransUnclassifiedView> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<TransUnclassifiedView> {
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
    bloc.add(GetTransUnsettledEvent(dto: dto, timeKey: timeKey));
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
    );

    bloc.add(FetchTransUnsettledEvent(dto: dto, loadMore: loadMore));
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
    );

    if (_typeFilter == 9 && _value.isEmpty) {
      _onCallAPi(dto, timeKey: _typeTime.timeKeyExt.name);
      return;
    }
    bloc.add(
        FetchTransUnsettledEvent(dto: dto, loadMore: true, clickSearch: true));
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
        color: AppColor.GREY_BG,
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
                  }

                  if (state.request == TransType.GET_BANKS) {
                    bloc.add(GetTerminalsEvent(state.bankDTO?.bankId ?? ''));

                    setState(() {
                      _bankId = state.bankDTO?.bankId ?? '';
                      _isOwner = state.bankDTO?.isOwner ?? false;
                    });

                    html.window.history.pushState(
                        null,
                        '/transactions?type=1?bankId=$_bankId',
                        '/transactions?type=1?bankId=$_bankId');

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
                    title: 'Giao dịch chờ xác nhận',
                    dto: state.bankDTO,
                    onTap: () => _onChooseBank(state.listBanks),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilterWidget(
                            stream: filterStream,
                            terminals: state.terminals,
                            callBack: _onReceive,
                            onSearch: _onSearch,
                            bankId: _bankId,
                            isOwner: false,
                            isPending: true,
                          ),
                          const SizedBox(height: 24),
                          CustomPaint(
                            painter: HorizontalDashedLinePainter(
                                dashWidth: 5, dashSpace: 3),
                            size: const Size(double.infinity, 1),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Danh sách GD chờ thanh toán',
                            style: TextStyle(
                                color: AppColor.BLACK,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
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
          update: (value) {
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
        return DialogChooseBankWidget(banks: list);
      },
    );

    if (data != null && data is BankAccountDTO) {
      _streamController.add(true);
      bloc.add(UpdateBankAccountEvent(data));
      html.window.history.pushState(
          null,
          '/transactions?type=0?bankId=$_bankId',
          '/transactions?type=0?bankId=${data.bankId}');
      _bankId = data.bankId;
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
