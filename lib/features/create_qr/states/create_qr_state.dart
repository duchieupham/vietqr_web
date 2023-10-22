import 'dart:ui';

import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:equatable/equatable.dart';

class CreateQRState extends Equatable {
  const CreateQRState();

  @override
  List<Object?> get props => [];
}

class CreateQRInitialState extends CreateQRState {}

class GetListBankAccountSuccessfulState extends CreateQRState {
  final List<BankAccountDTO> list;
  final List<Color> colors;
  const GetListBankAccountSuccessfulState({
    required this.list,
    required this.colors,
  });

  @override
  List<Object?> get props => [list, colors];
}

class BankDetailSuccessState extends CreateQRState {
  final AccountBankDetailDTO dto;

  const BankDetailSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BankDetailFailedState extends CreateQRState {}

class QRGenerateLoadingState extends CreateQRState {}

class QRGenerateSuccessState extends CreateQRState {
  final QRGeneratedDTO dto;

  const QRGenerateSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QRGenerateFailedState extends CreateQRState {}
