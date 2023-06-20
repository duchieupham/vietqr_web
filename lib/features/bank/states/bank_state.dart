import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_information_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class BankState extends Equatable {
  const BankState();

  @override
  List<Object?> get props => [];
}

class BankInitialState extends BankState {}

class BankLoadingState extends BankState {}

class BankLoadingInsertState extends BankState {}

class BankGetListSuccessState extends BankState {
  final List<BankAccountDTO> list;
  final List<Color> colors;

  const BankGetListSuccessState({required this.list, required this.colors});

  @override
  List<Object?> get props => [list, colors];
}

class BankGetListFailedState extends BankState {
  final String message;

  const BankGetListFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankDetailSuccessState extends BankState {
  final AccountBankDetailDTO dto;

  const BankDetailSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankDetailFailedState extends BankState {}

//

class BankCheckExistedState extends BankState {
  final String msg;

  const BankCheckExistedState({
    required this.msg,
  });

  @override
  List<Object?> get props => [msg];
}

class BankCheckNotExistedState extends BankState {
  final bool isAuthenticated;

  const BankCheckNotExistedState({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}

class BankCheckFailedState extends BankState {}

class BankInsertUnauthenticatedSuccessState extends BankState {
  final String bankId;
  final String qr;

  const BankInsertUnauthenticatedSuccessState({
    required this.bankId,
    required this.qr,
  });

  @override
  List<Object?> get props => [bankId, qr];
}

class BankInsertUnauthenticatedFailedState extends BankState {
  final String msg;

  const BankInsertUnauthenticatedFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

//for request OTP
class BankReuqestOTPLoadingState extends BankState {}

class BankRequestOTPSuccessState extends BankState {
  final BankCardRequestOTP dto;
  final String requestId;

  const BankRequestOTPSuccessState({
    required this.dto,
    required this.requestId,
  });

  @override
  List<Object?> get props => [dto, requestId];
}

class BankRequestOTPFailedState extends BankState {
  final String message;

  const BankRequestOTPFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class BankConfirmOTPLoadingState extends BankState {}

class BankConfirmOTPSuccessState extends BankState {}

class BankConfirmOTPFailedState extends BankState {
  final String message;

  const BankConfirmOTPFailedState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class BankInsertSuccessfulState extends BankState {
  final String bankId;
  final String qr;

  const BankInsertSuccessfulState({required this.bankId, required this.qr});

  @override
  List<Object?> get props => [bankId, qr];
}

class BankInsertFailedState extends BankState {
  final String message;

  const BankInsertFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankSearchingNameState extends BankState {}

class BankSearchNameSuccessState extends BankState {
  final BankNameInformationDTO dto;

  const BankSearchNameSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class BankSearchNameFailedState extends BankState {
  final String msg;
  const BankSearchNameFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class BankUpdateAuthenticateSuccessState extends BankState {}

class BankUpdateAuthenticateFailedState extends BankState {
  final String msg;

  const BankUpdateAuthenticateFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class BankRemoveLoadingState extends BankState {}

class BankRemoveSuccessState extends BankState {}

class BankRemoveFailedState extends BankState {
  final String message;

  const BankRemoveFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class BankUnlinkLoadingState extends BankState {}

class BankUnlinkSuccessState extends BankState {
  final String requestId;

  const BankUnlinkSuccessState({
    required this.requestId,
  });

  @override
  List<Object?> get props => [requestId];
}

class BankUnlinkFailedState extends BankState {
  final String msg;

  const BankUnlinkFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
