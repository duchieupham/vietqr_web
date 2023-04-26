import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
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

class BankCheckExistedEvent extends BankEvent {
  final String bankAccount;
  final String bankTypeId;

  const BankCheckExistedEvent({
    required this.bankAccount,
    required this.bankTypeId,
  });

  @override
  List<Object?> get props => [bankAccount, bankTypeId];
}

class BankEventInsertUnauthenticated extends BankEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const BankEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}
