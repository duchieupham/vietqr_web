import 'package:equatable/equatable.dart';

class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

class BankEventGetList extends BankEvent {
  final String userId;

  const BankEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BankEventGetDetail extends BankEvent {
  final String bankId;

  const BankEventGetDetail({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}
