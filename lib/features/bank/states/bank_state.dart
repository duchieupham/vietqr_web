import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
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

class BankCheckNotExistedState extends BankState {}

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
