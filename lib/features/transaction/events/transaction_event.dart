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
  final String timeKey;

  const GetTransOwnerEvent({required this.dto, this.timeKey = ''});

  @override
  List<Object?> get props => [dto, timeKey];
}

class FetchTransOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool loadMore;
  final bool clickSearch;

  const FetchTransOwnerEvent({
    required this.dto,
    this.loadMore = true,
    this.clickSearch = false,
  });

  @override
  List<Object?> get props => [dto, loadMore, clickSearch];
}

class FetchTransNotOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool loadMore;
  final bool clickSearch;

  const FetchTransNotOwnerEvent({
    required this.dto,
    this.loadMore = true,
    this.clickSearch = false,
  });

  @override
  List<Object?> get props => [dto, loadMore, clickSearch];
}

class GetTransNotOwnerEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final String timeKey;

  const GetTransNotOwnerEvent({required this.dto, this.timeKey = ''});

  @override
  List<Object?> get props => [dto, timeKey];
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
  final String timeKey;

  const GetTransUnsettledEvent({required this.dto, this.timeKey = ''});

  @override
  List<Object?> get props => [dto, timeKey];
}

class FetchTransUnsettledEvent extends TransactionEvent {
  final TransactionInputDTO dto;
  final bool loadMore;
  final bool clickSearch;

  const FetchTransUnsettledEvent({
    required this.dto,
    this.loadMore = true,
    this.clickSearch = false,
  });

  @override
  List<Object?> get props => [dto, loadMore, clickSearch];
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
  final String timeKey;
  final bool clearData;

  const UpdateCacheDataEvent({
    this.timeKey = '',
    this.clearData = false,
  });

  @override
  List<Object?> get props => [timeKey, clearData];
}

class UpdateOffsetEvent extends TransactionEvent {
  final int offset;

  const UpdateOffsetEvent(this.offset);

  @override
  List<Object?> get props => [offset];
}
