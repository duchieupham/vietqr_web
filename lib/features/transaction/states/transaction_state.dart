// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:equatable/equatable.dart';

enum TransType {
  NONE,
  GET_BANKS,
  GET_TRANS_TRUE,
  UPDATE_BANK,
  LIST_TERMINAL,
  UPDATE_TERMINAL,
  UPDATE_NOTE,
  UPDATE_CACHE,
  UPDATE_OFFSET,
  DAY,
  MONTH,
  SEVEN_DAY,
  THREE_MONTH,
  ERROR,
}

enum TimeKey {
  DAY,
  MONTH,
  SEVEN_DAY,
  THREE_MONTH,
  NONE,
}

extension TimeKeyExt on int {
  TimeKey get timeKeyExt {
    switch (this) {
      case 1:
        return TimeKey.DAY;
      case 2:
        return TimeKey.SEVEN_DAY;
      case 3:
        return TimeKey.MONTH;
      case 4:
        return TimeKey.THREE_MONTH;
      default:
        return TimeKey.NONE;
    }
  }
}

class TransactionState extends Equatable {
  final BlocStatus status;
  final TransType request;
  final String? msg;
  final int offset;
  final List<BankAccountDTO> listBanks;
  final List<TransReceiveDTO> listTrans;
  final BankAccountDTO? bankDTO;
  final bool isLoadMore;
  final Map<String, List<TransReceiveDTO>> tranMaps;
  final Map<String, List<TransReceiveDTO>> tranMapsDefault;
  final List<TerminalQRDTO> listTerminals;
  final bool getAll;
  final List<String> listTimeKey;

  const TransactionState({
    this.status = BlocStatus.NONE,
    this.request = TransType.NONE,
    this.msg,
    this.offset = 0,
    required this.listBanks,
    required this.listTrans,
    required this.listTerminals,
    required this.listTimeKey,
    this.bankDTO,
    required this.tranMaps,
    required this.tranMapsDefault,
    this.isLoadMore = true,
    this.getAll = false,
  });

  TransactionState copyWith({
    BlocStatus? status,
    String? msg,
    TransType? request,
    List<BankAccountDTO>? listBanks,
    List<TransReceiveDTO>? listTrans,
    BankAccountDTO? bankDTO,
    bool? isLoadMore,
    bool? getAll,
    bool? isEmpty,
    int? offset,
    List<TerminalQRDTO>? listTerminals,
    Map<String, List<TransReceiveDTO>>? tranMaps,
    Map<String, List<TransReceiveDTO>>? tranMapsDefault,
    List<String>? listTimeKey,
  }) {
    return TransactionState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      offset: offset ?? this.offset,
      listBanks: listBanks ?? this.listBanks,
      listTrans: listTrans ?? this.listTrans,
      bankDTO: bankDTO ?? this.bankDTO,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      getAll: getAll ?? this.getAll,
      tranMaps: tranMaps ?? this.tranMaps,
      tranMapsDefault: tranMapsDefault ?? this.tranMapsDefault,
      listTerminals: listTerminals ?? this.listTerminals,
      listTimeKey: listTimeKey ?? this.listTimeKey,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        offset,
        listBanks,
        listTrans,
        bankDTO,
        isLoadMore,
        tranMaps,
        tranMapsDefault,
        listTerminals,
        getAll,
        listTimeKey,
      ];
}
