import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:equatable/equatable.dart';

class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionEventGetList extends TransactionEvent {
  final TransactionInputDTO dto;

  const TransactionEventGetList({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventFetch extends TransactionEvent {
  final TransactionInputDTO dto;

  const TransactionEventFetch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
