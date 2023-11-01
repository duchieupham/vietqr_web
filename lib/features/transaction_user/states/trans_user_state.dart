import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:equatable/equatable.dart';

class TransUserState extends Equatable {
  const TransUserState();

  @override
  List<Object?> get props => [];
}

class GetListTransactionInitialState extends TransUserState {}

class MerchantLoadingState extends TransUserState {}

class MerchantLoadingActiveFeeState extends TransUserState {}

class GetListTransactionLoadingInitState extends TransUserState {}

class GetListTransactionLoadingListState extends TransUserState {}

class GetListTransactionLoadMoreListState extends TransUserState {}

class GetListTransactionByUserSuccessfulState extends TransUserState {
  final List<TransactionMerchantDTO> list;
  final bool isLoadingPage;
  final bool isLoadMore;
  const GetListTransactionByUserSuccessfulState(
      {required this.list,
      this.isLoadingPage = false,
      this.isLoadMore = false});

  @override
  List<Object?> get props => [list];
}
