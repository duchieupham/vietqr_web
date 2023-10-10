import 'package:equatable/equatable.dart';

class MerchantEvent extends Equatable {
  const MerchantEvent();

  @override
  List<Object?> get props => [];
}

class CheckAccountIsMerchantEvent extends MerchantEvent {}

class GetMerchantFeeEvent extends MerchantEvent {
  final String customerSyncId;
  final String month;
  final bool isLoadingPage;
  const GetMerchantFeeEvent(
      {required this.customerSyncId,
      required this.month,
      this.isLoadingPage = false});

  @override
  List<Object?> get props => [customerSyncId, month];
}

class GetListTransactionByUserEvent extends MerchantEvent {
  final Map<String, dynamic> param;
  final bool isLoadingPage;

  const GetListTransactionByUserEvent({
    required this.param,
    this.isLoadingPage = false,
  });

  @override
  List<Object?> get props => [param];
}

class GetListTransactionByMerchantEvent extends MerchantEvent {
  final Map<String, dynamic> param;
  final bool isLoadingPage;
  final bool isLoadMore;
  const GetListTransactionByMerchantEvent({
    required this.param,
    this.isLoadingPage = false,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [param];
}
