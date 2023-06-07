import 'package:VietQR/models/bank_card_insert_dto.dart';
import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_search_dto.dart';
import 'package:VietQR/models/confirm_otp_bank_dto.dart';
import 'package:equatable/equatable.dart';

class ECOMBankEvent extends Equatable {
  const ECOMBankEvent();

  @override
  List<Object?> get props => [];
}

class ECOMBankEventGetList extends ECOMBankEvent {
  final String userId;

  const ECOMBankEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ECOMBankEventGetDetail extends ECOMBankEvent {
  final String bankId;

  const ECOMBankEventGetDetail({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class ECOMBankCheckExistedEvent extends ECOMBankEvent {
  final String bankAccount;
  final String bankTypeId;
  final bool isAuthenticated;

  const ECOMBankCheckExistedEvent({
    required this.bankAccount,
    required this.bankTypeId,
    required this.isAuthenticated,
  });

  @override
  List<Object?> get props => [bankAccount, bankTypeId, isAuthenticated];
}

class ECOMBankEventInsertUnauthenticated extends ECOMBankEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const ECOMBankEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ECOMBankEventInsert extends ECOMBankEvent {
  final BankCardInsertDTO dto;

  const ECOMBankEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ECOMBankEventRequestOTP extends ECOMBankEvent {
  final BankCardRequestOTP dto;

  const ECOMBankEventRequestOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ECOMBankEventConfirmOTP extends ECOMBankEvent {
  final ConfirmOTPBankDTO dto;

  const ECOMBankEventConfirmOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ECOMBankEventSearchName extends ECOMBankEvent {
  final BankNameSearchDTO dto;

  const ECOMBankEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}
