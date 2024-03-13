import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/web_mobile_blank_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_bank_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_terminal_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_edit_note_widget.dart';
import 'package:VietQR/features/transaction/widgets/dialog_trans_payment_widget.dart';
import 'package:VietQR/features/transaction/widgets/table_trans_payment_widget.dart';
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

class TransactionAccountingView extends StatefulWidget {
  const TransactionAccountingView({super.key});

  @override
  State<TransactionAccountingView> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<TransactionAccountingView> {
  late TransactionBloc bloc;

  double get width => MediaQuery.of(context).size.width;

  bool get isMobile => (PlatformUtils.instance.resizeWhen(width, 650));

  final searchController = TextEditingController();

  /// 3,4,9 value = "" => get all trans
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
          '/transactions?type=1?bankId=$_bankId',
          '/transactions?type=1?bankId=${data.bankId}');
      setState(() {
        _bankId = data.bankId;
      });
      loadAll(isFirst: true);
    }
  }

  void loadMore(int offset, bool getAll) {
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
    bloc.add(
        GetTransUnsettledEvent(dto: dto, isLoadMore: true, getAll: getAll));
  }

  void _onSearch() {
    if (typeFilter == 9 && typeTime == 1) return;

    int type = typeFilter;

    if (typeFilter == 5) {
      _value = '$statusFilter';
      searchController.clear();
    }
    if (typeFilter == 9 && _value.isNotEmpty) {
      type = 4;
    }

    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      offset: 0,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
      value: _value,
      type: type,
      status: statusFilter,
    );
    bloc.add(GetTransUnsettledEvent(dto: dto));
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

  void _onChooseTerminal(
    List<TerminalQRDTO> list,
    int offset,
    String transactionId,
    String terminalCode,
  ) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogChooseTerminalWidget(
          terminals: list,
          terminalCode: terminalCode,
          update: (dto) {
            bloc.add(UpdateTerminalEvent(
              transactionId: transactionId,
              terminalCode: dto.terminalCode,
              offset: offset,
            ));
          },
        );
      },
    );
  }

  void _onChooseNote(int offset, TransReceiveDTO dto) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogUpdateNoteWidget(
          dto: dto,
          update: (value) {
            bloc.add(UpdateNoteEvent(dto: value, offset: offset));
          },
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

    if (type == 5 || type == 9) _onSearch();
  }

  void _onClearFilter() {
    setState(() {
      _value = '';
      searchController.clear();
      typeFilter = 9;
      statusFilter = 0;
      typeTime = 1;
      _fromDate = _formatFromDate(DateTime.now());
      _toDate = _endDate(DateTime.now());
    });
    bloc.add(const UpdateCacheDataEvent(true));
  }

  void _onClear() {
    setState(() {
      _value = '';
      searchController.clear();
    });
    bloc.add(const UpdateCacheDataEvent(true));
  }

  void loadAll({bool isFirst = false}) {
    TransactionInputDTO dto = TransactionInputDTO(
      bankId: _bankId,
      from: _dateFormat.format(_fromDate),
      to: _dateFormat.format(_toDate),
    );

    if (isFirst) {
      dto.from = _dateFormat.format(_formatFromDate(DateTime.now()));
      dto.to = _dateFormat.format(_endDate(DateTime.now()));
    }

    if (_isOwner) {
      bloc.add(GetTransOwnerEvent(dto: dto, getAll: isFirst));
    } else {
      bloc.add(GetTransNotOwnerEvent(dto: dto, getAll: isFirst));
    }
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
                  if (state.request == TransType.UPDATE_TERMINAL ||
                      state.request == TransType.UPDATE_NOTE) {
                    Navigator.pop(context);
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

                    loadAll(isFirst: true);
                  }
                },
                builder: (context, state) {
                  return TransHeaderWidget(
                    title: 'Giao dịch chờ xác nhận',
                    dto: state.bankDTO,
                    onTap: () => _onChooseBank(state.listBanks),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFilterWidget(),
                        const SizedBox(height: 24),
                        TableTransPaymentWidget(
                          list: state.getAll
                              ? state.tranMapsDefault['${state.offset}'] ?? []
                              : state.tranMaps['${state.offset}'] ?? [],
                          offset: state.offset,
                          isOwner: state.bankDTO?.isOwner ?? false,
                          onChooseTerminal: (transactionId, terminalCode) =>
                              _onChooseTerminal(state.listTerminals,
                                  state.offset, transactionId, terminalCode),
                          onEditNote: (dto) => _onChooseNote(state.offset, dto),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          height: 100,
                          child: Row(
                            children: [
                              Text('Trang ${state.offset + 1}'),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  int offset = state.offset;
                                  if (offset <= 0) return;
                                  offset = offset - 1;
                                  loadMore(offset, state.getAll);
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
                                  loadMore(offset, state.getAll);
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
                              Expanded(
                                child: Visibility(
                                  visible: state.status == BlocStatus.LOADING,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  String get statusValue => statusFilter == 1
      ? 'Thành công'
      : statusFilter == 0
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
    return 'Tìm kiếm theo mã điểm bán';
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
        ...[
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
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.close, size: 18),
                        ),
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
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
        const SizedBox(width: 8),
        GestureDetector(
          onTap: typeFilter != 5 ? _onSearch : null,
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
                'Tìm kiếm theo',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Wrap(
                    children: [
                      if (typeFilter == 9)
                        _buildFilterWith('Tất cả (mặc định)'),
                      _buildFilterWith('Thời gian: $timeValue'),
                      if (typeFilter == 1)
                        _buildFilterWith(
                            'Mã giao dịch: ${searchController.text}'),
                      if (typeFilter == 3)
                        _buildFilterWith('Nội dung: ${searchController.text}'),
                      if (typeFilter == 5)
                        _buildFilterWith('Trạng thái: $statusValue'),
                      if (typeFilter == 2)
                        _buildFilterWith(
                            'Mã đơn hàng: ${searchController.text}'),
                      if (typeFilter == 4)
                        _buildFilterWith(
                            'Mã điểm bán: ${searchController.text}'),
                    ],
                  ),
                  if (typeFilter != 9 || typeTime != 1)
                    GestureDetector(
                      onTap: _onClearFilter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(right: 8, bottom: 4),
                        child: Row(
                          children: const [
                            Icon(Icons.remove_circle_outline,
                                color: AppColor.BLUE_TEXT, size: 18),
                            SizedBox(width: 4),
                            Text('Xoá bộ lọc',
                                style: TextStyle(
                                    fontSize: 11, color: AppColor.BLUE_TEXT)),
                          ],
                        ),
                      ),
                    ),
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
          height: 30,
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}
