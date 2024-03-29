// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/total_trans_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
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
  UPDATE_CACHE_CALL,
  UPDATE_OFFSET,
  APPROVE_TRANS,
  CLOSE_TRANS,
  GET_TOTAL,
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
      case 2:
        return TimeKey.DAY;
      case 1:
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
  final Map<String, List<TransReceiveDTO>> maps;
  final Map<String, List<TransReceiveDTO>> mapLocals;
  final TransactionDTO? transactionDTO;
  final List<TerminalQRDTO> terminals;
  final bool isCache;
  final List<String> keys;
  final TransactionInputDTO? transInput;
  final bool isLoading;
  final TotalTransDTO? totalTransDTO;

  const TransactionState({
    this.status = BlocStatus.NONE,
    this.request = TransType.NONE,
    this.msg,
    this.offset = 0,
    this.bankDTO,
    this.isLoadMore = true,
    this.isCache = false,
    this.transInput,
    this.maps = const {},
    this.mapLocals = const {},
    this.listBanks = const [],
    this.listTrans = const [],
    this.terminals = const [],
    this.keys = const [],
    this.transactionDTO,
    this.isLoading = true,
    this.totalTransDTO,
  });

  TransactionState copyWith({
    BlocStatus? status,
    String? msg,
    TransType? request,
    List<BankAccountDTO>? listBanks,
    List<TransReceiveDTO>? listTrans,
    BankAccountDTO? bankDTO,
    bool? isLoadMore,
    bool? isLoading,
    bool? isCache,
    bool? isEmpty,
    int? offset,
    List<TerminalQRDTO>? terminals,
    Map<String, List<TransReceiveDTO>>? maps,
    Map<String, List<TransReceiveDTO>>? mapLocals,
    List<String>? keys,
    TransactionInputDTO? transInput,
    TransactionDTO? transactionDTO,
    TotalTransDTO? totalTransDTO,
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
      isCache: isCache ?? this.isCache,
      maps: maps ?? this.maps,
      mapLocals: mapLocals ?? this.mapLocals,
      terminals: terminals ?? this.terminals,
      keys: keys ?? this.keys,
      transInput: transInput ?? this.transInput,
      transactionDTO: transactionDTO ?? this.transactionDTO,
      isLoading: isLoading ?? this.isLoading,
      totalTransDTO: totalTransDTO ?? this.totalTransDTO,
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
        maps,
        mapLocals,
        terminals,
        isCache,
        keys,
        transInput,
        transactionDTO,
        isLoading,
        totalTransDTO,
      ];
}
