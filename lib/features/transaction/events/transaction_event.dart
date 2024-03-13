import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:equatable/equatable.dart';

class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class GetTransOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool isLoadMore;
  final bool getAll;
  final String timeKey;

  const GetTransOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
    this.getAll = false,
    this.timeKey = '',
  });

  @override
  List<Object?> get props => [dto, isLoadMore, getAll, timeKey];
}

class GetTransNotOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool isLoadMore;
  final bool getAll;
  final String timeKey;

  const GetTransNotOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
    this.getAll = false,
    this.timeKey = '',
  });

  @override
  List<Object?> get props => [dto, isLoadMore, getAll, timeKey];
}

class GetTransUnsettledNotOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool isLoadMore;

  const GetTransUnsettledNotOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore];
}

class GetTransUnsettledEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool isLoadMore;
  final bool getAll;
  final String timeKey;

  const GetTransUnsettledEvent({
    required this.dto,
    this.isLoadMore = false,
    this.getAll = false,
    this.timeKey = '',
  });

  @override
  List<Object?> get props => [dto, isLoadMore, getAll, timeKey];
}

class GetListBankEvent extends TransactionEvent {}

class UpdateBankAccountEvent extends TransactionEvent {
  final BankAccountDTO dto;

  const UpdateBankAccountEvent(this.dto);

  @override
  List<Object?> get props => [dto];
}

class GetTerminalsEvent extends TransactionEvent {
  final String bankId;

  const GetTerminalsEvent(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class UpdateTerminalEvent extends TransactionEvent {
  final String transactionId;
  final String terminalCode;
  final int offset;
  final String timeKey;

  const UpdateTerminalEvent({
    this.transactionId = '',
    this.terminalCode = '',
    this.offset = 0,
    this.timeKey = '',
  });

  @override
  List<Object?> get props => [transactionId, terminalCode, offset, timeKey];
}

class UpdateNoteEvent extends TransactionEvent {
  final TransReceiveDTO dto;
  final int offset;
  final String timeKey;

  const UpdateNoteEvent({
    required this.dto,
    this.offset = 0,
    this.timeKey = '',
  });

  @override
  List<Object?> get props => [dto, offset, timeKey];
}

class UpdateCacheDataEvent extends TransactionEvent {
  final bool getAll;
  final String timeKey;

  const UpdateCacheDataEvent({this.getAll = true, this.timeKey = ''});

  @override
  List<Object?> get props => [getAll, timeKey];
}

class UpdateOffsetEvent extends TransactionEvent {
  final int offset;

  const UpdateOffsetEvent(this.offset);

  @override
  List<Object?> get props => [offset];
}
