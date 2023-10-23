import 'package:VietQR/models/bank_account_remove_dto.dart';
import 'package:VietQR/models/bank_card_insert_dto.dart';
import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_search_dto.dart';
import 'package:VietQR/models/confirm_otp_bank_dto.dart';
import 'package:VietQR/models/register_authentication_dto.dart';
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
  final bool isAuthenticated;

  const BankCheckExistedEvent({
    required this.bankAccount,
    required this.bankTypeId,
    required this.isAuthenticated,
  });

  @override
  List<Object?> get props => [bankAccount, bankTypeId, isAuthenticated];
}

class BankEventInsertUnauthenticated extends BankEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const BankEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventInsert extends BankEvent {
  final BankCardInsertDTO dto;

  const BankEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventRequestOTP extends BankEvent {
  final BankCardRequestOTP dto;

  const BankEventRequestOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventConfirmOTP extends BankEvent {
  final ConfirmOTPBankDTO dto;

  const BankEventConfirmOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventSearchName extends BankEvent {
  final BankNameSearchDTO dto;

  const BankEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventRegisterAuthentication extends BankEvent {
  final RegisterAuthenticationDTO dto;

  const BankEventRegisterAuthentication({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class BankEventRemove extends BankEvent {
  final BankAccountRemoveDTO dto;

  const BankEventRemove({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventUnlink extends BankEvent {
  final BankAccountUnlinkDTO dto;

  const BankEventUnlink({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankEventConfirmUnlinkOTP extends BankEvent {
  final ConfirmOTPBankDTO dto;

  const BankEventConfirmUnlinkOTP({required this.dto});

  @override
  List<Object?> get props => [dto];
}
