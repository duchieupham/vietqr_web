import 'package:VietQR/models/account_is_merchant.dart';
import 'package:VietQR/models/active_fee_dto.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:equatable/equatable.dart';

class MerchantState extends Equatable {
  const MerchantState();

  @override
  List<Object?> get props => [];
}

class MerchantInitialState extends MerchantState {}

class MerchantLoadingState extends MerchantState {}

class MerchantLoadingActiveFeeState extends MerchantState {}

class MerchantLoadingInitState extends MerchantState {}

class MerchantCheckAccountIsMerchantSuccessfulState extends MerchantState {
  final AccountIsMerchantDTO dto;

  const MerchantCheckAccountIsMerchantSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class MerchantGetMerchantFeeSuccessfulState extends MerchantState {
  final List<ActiveFeeDTO> list;
  final bool isLoadingPage;

  const MerchantGetMerchantFeeSuccessfulState(
      {required this.list, this.isLoadingPage = false});

  @override
  List<Object?> get props => [list];
}

class MerchantLoadingListState extends MerchantState {}

class MerchantLoadMoreListState extends MerchantState {}

class MerchantGetListByUserSuccessfulState extends MerchantState {
  final List<TransactionMerchantDTO> list;
  final bool isLoadingPage;
  const MerchantGetListByUserSuccessfulState(
      {required this.list, this.isLoadingPage = false});

  @override
  List<Object?> get props => [list];
}

class MerchantGetListByMerchantSuccessfulState extends MerchantState {
  final List<TransactionMerchantDTO> list;
  final bool isLoadingPage;

  final bool isLoadMore;
  const MerchantGetListByMerchantSuccessfulState(
      {required this.list,
      this.isLoadingPage = false,
      this.isLoadMore = false});

  @override
  List<Object?> get props => [list];
}
