import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/models/transaction_branch_input_dto.dart';
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

  const GetTransOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore];
}

class GetTransNotOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool isLoadMore;

  const GetTransNotOwnerEvent({
    required this.dto,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore];
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

  const GetTransUnsettledEvent({
    required this.dto,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [dto, isLoadMore];
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
  final String transactionId;
  final String note;
  final int offset;

  const UpdateNoteEvent({
    this.transactionId = '',
    this.note = '',
    this.offset = 0,
  });

  @override
  List<Object?> get props => [transactionId, note, offset];
}
