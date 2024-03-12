// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
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
  ERROR,
}

class TransactionState extends Equatable {
  final BlocStatus status;
  final TransType request;
  final String? msg;
  final int offset;
  final List<BankAccountDTO> listBanks;
  final List<RelatedTransactionReceiveDTO> listTrans;
  final BankAccountDTO? bankDTO;
  final bool isLoadMore;
  final Map<String, List<RelatedTransactionReceiveDTO>> tranMaps;
  final List<TerminalQRDTO> listTerminals;

  const TransactionState({
    this.status = BlocStatus.NONE,
    this.request = TransType.NONE,
    this.msg,
    this.offset = 0,
    required this.listBanks,
    required this.listTrans,
    required this.listTerminals,
    this.bankDTO,
    required this.tranMaps,
    this.isLoadMore = true,
  });

  TransactionState copyWith({
    BlocStatus? status,
    String? msg,
    TransType? request,
    List<BankAccountDTO>? listBanks,
    List<RelatedTransactionReceiveDTO>? listTrans,
    BankAccountDTO? bankDTO,
    bool? isLoadMore,
    bool? isEmpty,
    int? offset,
    List<TerminalQRDTO>? listTerminals,
    Map<String, List<RelatedTransactionReceiveDTO>>? tranMaps,
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
      tranMaps: tranMaps ?? this.tranMaps,
      listTerminals: listTerminals ?? this.listTerminals,
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
        listTerminals,
      ];
}
