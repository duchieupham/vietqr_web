import 'package:equatable/equatable.dart';

class TransUserEvent extends Equatable {
  const TransUserEvent();

  @override
  List<Object?> get props => [];
}

class GetListTransactionByEvent extends TransUserEvent {
  final Map<String, dynamic> param;
  final bool isLoadingPage;
  final bool isLoadMore;
  const GetListTransactionByEvent({
    required this.param,
    this.isLoadingPage = false,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [param];
}
