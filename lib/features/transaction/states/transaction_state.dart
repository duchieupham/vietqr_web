import 'package:VietQR/models/business_detail_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_receive_dto.dart';
import 'package:equatable/equatable.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionGetListSuccessState extends TransactionState {
  final List<RelatedTransactionReceiveDTO> list;

  const TransactionGetListSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class TransactionGetListFailedState extends TransactionState {}

class TransactionFetchSuccessState extends TransactionState {
  final List<RelatedTransactionReceiveDTO> list;

  const TransactionFetchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class TransactionFetchFailedState extends TransactionState {}

class TransactionDetailLoadingState extends TransactionState {}

class TransactionDetailSuccessState extends TransactionState {
  final TransactionReceiveDTO dto;

  const TransactionDetailSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionDetailFailedState extends TransactionState {}

class TransactionGetListBranchSuccessState extends TransactionState {
  final List<BusinessTransactionDTO> list;

  const TransactionGetListBranchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class TransactionFetchBranchSuccessState extends TransactionState {
  final List<BusinessTransactionDTO> list;

  const TransactionFetchBranchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}
