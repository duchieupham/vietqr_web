// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:equatable/equatable.dart';

// ignore: constant_identifier_names
enum QrGenerate {
  NONE,
  GET_BANKS,
  GET_BANK_TYPE,
  GET_MERCHANTS,
  QR_GENERATE,
  UN_AUTH_QR_GENERATE,
}

class QRGenerateState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QrGenerate request;
  final List<BankAccountDTO>? listAccountBanks;
  final List<BankTypeDTO>? listBankType;
  final List<TerminalQRDTO>? listTerminal;
  final QRGeneratedDTO? dto;

  const QRGenerateState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QrGenerate.NONE,
    this.listAccountBanks,
    this.listBankType,
    this.listTerminal,
    this.dto,
  });

  QRGenerateState copyWith({
    BlocStatus? status,
    QrGenerate? request,
    String? msg,
    List<BankAccountDTO>? listAccountBanks,
    List<BankTypeDTO>? listBankType,
    List<TerminalQRDTO>? listTerminal,
    QRGeneratedDTO? dto,
  }) {
    return QRGenerateState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listAccountBanks: listAccountBanks ?? this.listAccountBanks,
      listBankType: listBankType ?? this.listBankType,
      listTerminal: listTerminal ?? this.listTerminal,
      dto: dto ?? this.dto,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        listAccountBanks,
        listBankType,
        listTerminal,
        dto,
      ];
}
