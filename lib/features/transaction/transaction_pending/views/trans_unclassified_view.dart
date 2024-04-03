import 'dart:async';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/transaction_pending/widgets/table_unclassified_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_terminal_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_edit_note_widget.dart';
import 'package:VietQR/features/transaction/widgets/filter_widget.dart';
import 'package:VietQR/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/services/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransUnclassifiedView extends StatefulWidget {
  final BankAccountDTO bank;
  final MerchantRole role;
  final TransactionInputDTO dto;
  final ValueChanged<TransactionInputDTO> callBack;
  final Stream<dynamic> stream;

  const TransUnclassifiedView(
      {super.key,
      required this.bank,
      required this.callBack,
      required this.dto,
      required this.role,
      required this.stream});

  @override
  State<TransUnclassifiedView> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<TransUnclassifiedView> {
  late TransactionBloc bloc;
  late SettingProvider provider;

  MerchantRole role = MerchantRole();

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
    widget.callBack(dto);
    bloc.add(GetTransUnsettledEvent(dto: dto, timeKey: timeKey));
  }

  void loadMore(int offset, bool loadMore) {
    if (_typeFilter == 5) {
      _value = '$_typeStatus';
    }
    TransactionInputDTO dto = TransactionInputDTO(
      bankId: widget.bank.bankId,
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
      bankId: widget.bank.bankId,
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
    widget.callBack.call(dto);
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
      TransactionInputDTO dto = TransactionInputDTO(
        bankId: widget.bank.bankId,
        offset: 0,
        from: _dateFormat.format(_fromDate),
        to: _dateFormat.format(_toDate),
        value: _value,
        type: _typeFilter,
        status: _typeStatus,
      );
      widget.callBack.call(dto);
      bloc.add(UpdateCacheDataEvent(
          timeKey: _typeTime.timeKeyExt.name, clearData: clearData));
    }
  }

  void loadAll({BankAccountDTO? bankDTO}) {
    _typeFilter = widget.dto.type;
    _typeStatus = widget.dto.status;
    _typeTime = widget.dto.typeTime;
    _value = widget.dto.value;
    _fromDate = widget.dto.from.isNotEmpty
        ? _dateFormat.parse(widget.dto.from)
        : _formatFromDate;
    _toDate = widget.dto.to.isNotEmpty
        ? _dateFormat.parse(widget.dto.to)
        : _formatEndDate;

    updateState();

    TransactionInputDTO dto = TransactionInputDTO(
      bankId: widget.bank.bankId,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
    );

    if (bankDTO != null) dto.bankId = bankDTO.bankId;

    _onCallAPi(dto, timeKey: _typeTime.timeKeyExt.name);
  }

  @override
  void initState() {
    super.initState();
    bloc = TransactionBloc();
    provider = Provider.of<SettingProvider>(context, listen: false);
    filterStream = _streamController.stream;
    widget.stream.listen((event) {
      if (event is BankAccountDTO) {
        bloc.add(UpdateBankAccountEvent(event));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAll();
      bloc.add(GetTerminalsEvent(widget.bank.bankId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => bloc,
      child: (!isMobile)
          ? const Material(
              color: AppColor.GREY_BG,
              child: WebMobileBlankWidget(),
            )
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

                if (state.request == TransType.ERROR) {
                  await DialogWidget.instance
                      .openMsgDialog(title: 'Thông báo', msg: state.msg ?? '');
                }

                if (state.request == TransType.GET_TRANS_TRUE) {
                  listTimeKey = [...state.keys];
                  updateState();
                }

                if (state.request == TransType.UPDATE_OFFSET) {
                  loadMore(state.offset, state.isLoadMore);
                }
                if (state.request == TransType.UPDATE_BANK) {
                  loadAll(bankDTO: state.bankDTO);
                  bloc.add(GetTerminalsEvent(state.bankDTO?.bankId ?? ''));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilterWidget(
                      stream: filterStream,
                      terminals: state.terminals,
                      callBack: _onReceive,
                      onSearch: _onSearch,
                      bankId: widget.bank.bankId,
                      isOwner: false,
                      isPending: true,
                    ),
                    const SizedBox(height: 24),
                    CustomPaint(
                      painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
                      size: const Size(double.infinity, 1),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Danh sách GD chờ thanh toán',
                          style: TextStyle(
                              color: AppColor.BLACK,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                        _refreshWidget(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TableUnclassifiedWidget(
                      items: state.isCache
                          ? state.mapLocals[_typeTime.timeKeyExt.name] ?? []
                          : state.maps['${state.offset}'] ?? [],
                      offset: state.offset,
                      isOwner: widget.bank.isOwner,
                      onChooseTerminal: (transDTO) => _onChooseTerminal(
                          state.terminals, state.offset, transDTO),
                      onEditNote: (dto) => _onChooseNote(state.offset, dto),
                      isLoading: state.status == BlocStatus.LOADING,
                      role: widget.role,
                      callBack: (TransRequest value) {},
                    ),
                    _buildPageWidget(state),
                  ],
                );
              },
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
          update: (terminalCode, terminalId) {
            if (terminalCode.isEmpty) return;
            if (widget.role.isUpdateTransRequest) {
              TransRequest dto = TransRequest(
                transactionId: transDTO.transactionId,
                requestType: 0,
                terminalCode: terminalCode,
                terminalId: terminalId,
                merchantId: widget.role.merchantId,
              );
              bloc.add(TransRequestEvent(dto: dto, offset: offset));
            } else {
              bloc.add(
                UpdateTerminalEvent(
                    transactionId: transDTO.transactionId,
                    terminalCode: terminalCode,
                    offset: offset,
                    timeKey: _typeTime.timeKeyExt.name),
              );
            }
          },
        );
      },
    );
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

  Widget _refreshWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: InkWell(
        onTap: () => updateState(),
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