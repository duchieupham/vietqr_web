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

  const GetTransOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
    this.getAll = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore, getAll];
}

class GetTransNotOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool isLoadMore;
  final bool getAll;

  const GetTransNotOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
    this.getAll = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore, getAll];
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

  const GetTransUnsettledEvent({
    required this.dto,
    this.isLoadMore = false,
    this.getAll = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore, getAll];
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

  const UpdateTerminalEvent({
    this.transactionId = '',
    this.terminalCode = '',
    this.offset = 0,
  });

  @override
  List<Object?> get props => [transactionId, terminalCode, offset];
}

class UpdateNoteEvent extends TransactionEvent {
  final TransReceiveDTO dto;
  final int offset;

  const UpdateNoteEvent({
    required this.dto,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [dto, offset];
}

class UpdateCacheDataEvent extends TransactionEvent {
  final bool getAll;

  const UpdateCacheDataEvent(this.getAll);

  @override
  List<Object?> get props => [getAll];
}

class UpdateOffsetEvent extends TransactionEvent {
  final int offset;

  const UpdateOffsetEvent(this.offset);

  @override
  List<Object?> get props => [offset];
}
