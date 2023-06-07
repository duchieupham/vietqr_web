import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_information_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ECOMBankState extends Equatable {
  const ECOMBankState();

  @override
  List<Object?> get props => [];
}

class ECOMBankInitialState extends ECOMBankState {}

class ECOMBankLoadingState extends ECOMBankState {}

class ECOMBankLoadingInsertState extends ECOMBankState {}

class ECOMBankGetListSuccessState extends ECOMBankState {
  final List<BankAccountDTO> list;
  final List<Color> colors;

  const ECOMBankGetListSuccessState({required this.list, required this.colors});

  @override
  List<Object?> get props => [list, colors];
}

class ECOMBankGetListFailedState extends ECOMBankState {
  final String message;

  const ECOMBankGetListFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ECOMBankDetailSuccessState extends ECOMBankState {
  final AccountBankDetailDTO dto;

  const ECOMBankDetailSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ECOMBankDetailFailedState extends ECOMBankState {}

//

class ECOMBankCheckExistedState extends ECOMBankState {
  final String msg;

  const ECOMBankCheckExistedState({
    required this.msg,
  });

  @override
  List<Object?> get props => [msg];
}

class ECOMBankCheckNotExistedState extends ECOMBankState {
  final bool isAuthenticated;

  const ECOMBankCheckNotExistedState({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}

class ECOMBankCheckFailedState extends ECOMBankState {}

class ECOMBankInsertUnauthenticatedSuccessState extends ECOMBankState {
  final String bankId;
  final String qr;

  const ECOMBankInsertUnauthenticatedSuccessState({
    required this.bankId,
    required this.qr,
  });

  @override
  List<Object?> get props => [bankId, qr];
}

class ECOMBankInsertUnauthenticatedFailedState extends ECOMBankState {
  final String msg;

  const ECOMBankInsertUnauthenticatedFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

//for request OTP
class ECOMBankReuqestOTPLoadingState extends ECOMBankState {}

class ECOMBankRequestOTPSuccessState extends ECOMBankState {
  final BankCardRequestOTP dto;
  final String requestId;

  const ECOMBankRequestOTPSuccessState({
    required this.dto,
    required this.requestId,
  });

  @override
  List<Object?> get props => [dto, requestId];
}

class ECOMBankRequestOTPFailedState extends ECOMBankState {
  final String message;

  const ECOMBankRequestOTPFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

//
class ECOMBankConfirmOTPLoadingState extends ECOMBankState {}

class ECOMBankConfirmOTPSuccessState extends ECOMBankState {}

class ECOMBankConfirmOTPFailedState extends ECOMBankState {
  final String message;

  const ECOMBankConfirmOTPFailedState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class ECOMBankInsertSuccessfulState extends ECOMBankState {
  final String bankId;
  final String qr;

  const ECOMBankInsertSuccessfulState({required this.bankId, required this.qr});

  @override
  List<Object?> get props => [bankId, qr];
}

class ECOMBankInsertFailedState extends ECOMBankState {
  final String message;

  const ECOMBankInsertFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ECOMBankSearchingNameState extends ECOMBankState {}

class ECOMBankSearchNameSuccessState extends ECOMBankState {
  final BankNameInformationDTO dto;

  const ECOMBankSearchNameSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class ECOMBankSearchNameFailedState extends ECOMBankState {}
