import 'package:equatable/equatable.dart';

class QRCreateEvent extends Equatable {
  const QRCreateEvent();
  @override
  List<Object?> get props => [];
}

class GetListBankAccount extends QRCreateEvent {}

class GetListBankType extends QRCreateEvent {}

class GetListTerminalEvent extends QRCreateEvent {
  final String? bankId;

  const GetListTerminalEvent({this.bankId});
  @override
  List<Object?> get props => [bankId];
}

class QRGenerateEvent extends QRCreateEvent {
  final String bankId;
  final String amount;
  final String content;
  final String? terminalCode;
  final String? orderId;

  const QRGenerateEvent({
    required this.bankId,
    required this.amount,
    required this.content,
    this.terminalCode,
    this.orderId,
  });
  @override
  List<Object?> get props => [bankId, amount, content, terminalCode, orderId];
}

class UnAuthQRGenerateEvent extends QRCreateEvent {
  final String bankAccount;
  final String bankCode;
  final String userBankName;
  final String? amount;
  final String? content;

  const UnAuthQRGenerateEvent({
    required this.bankAccount,
    required this.bankCode,
    required this.userBankName,
    this.amount,
    this.content,
  });
  @override
  List<Object?> get props =>
      [bankAccount, bankCode, userBankName, amount, content];
}
