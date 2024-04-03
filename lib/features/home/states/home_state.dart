import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final BankType request;
  final String? bankAccount;
  final List<BankAccountDTO> listBanks;
  final List<Color> colors;
  final BankTypeDTO? bankTypeDTO;
  final AccountBankDetailDTO? bankDetailDTO;
  final List<BankTypeDTO> listBankTypeDTO;
  final TypeQR typeQR;
  final String? barCode;

  const HomeState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = BankType.NONE,
    this.typeQR = TypeQR.NONE,
    this.bankAccount,
    this.bankTypeDTO,
    this.bankDetailDTO,
    this.barCode,
    required this.listBanks,
    required this.colors,
    required this.listBankTypeDTO,
  });

  HomeState copyWith({
    BlocStatus? status,
    BankType? request,
    String? msg,
    List<BankAccountDTO>? listBanks,
    List<Color>? colors,
    String? bankAccount,
    List<BankTypeDTO>? listBankTypeDTO,
    BankTypeDTO? bankTypeDTO,
    AccountBankDetailDTO? bankDetailDTO,
    TypeQR? typeQR,
    String? barCode,
  }) {
    return HomeState(
      status: status ?? this.status,
      request: request ?? this.request,
      typeQR: typeQR ?? this.typeQR,
      msg: msg ?? this.msg,
      barCode: barCode ?? this.barCode,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      listBanks: listBanks ?? this.listBanks,
      colors: colors ?? this.colors,
      listBankTypeDTO: listBankTypeDTO ?? this.listBankTypeDTO,
      bankDetailDTO: bankDetailDTO ?? this.bankDetailDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        bankAccount,
        colors,
        listBanks,
        typeQR,
        barCode,
        bankDetailDTO,
      ];
}
