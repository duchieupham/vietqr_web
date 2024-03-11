import 'package:VietQR/models/bank_account_dto.dart';
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
