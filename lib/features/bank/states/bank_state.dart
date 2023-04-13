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
