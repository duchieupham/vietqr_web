import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction_qr_dto.dart';
import 'package:VietQR/models/vcard_generated_dto.dart';
import 'package:equatable/equatable.dart';

class QRCodeUnUTState extends Equatable {
  const QRCodeUnUTState();

  @override
  List<Object?> get props => [];
}

class CreateInitialState extends QRCodeUnUTState {}

class CreateQRLoadingState extends QRCodeUnUTState {}

class CreateVcardLoadingState extends QRCodeUnUTState {}

class CreateSuccessfulState extends QRCodeUnUTState {
  final QRGeneratedDTO dto;

  const CreateSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CreateVcardSuccessfulState extends QRCodeUnUTState {
  final VcardGenerateDto dto;

  const CreateVcardSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CreateFailedState extends QRCodeUnUTState {}

class CreateTransactionQRSuccessfulState extends QRCodeUnUTState {
  final TransactionQRDTO dto;

  const CreateTransactionQRSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CancelQRSuccessState extends QRCodeUnUTState {}

class CancelQRFailedState extends QRCodeUnUTState {
  final String msg;

  const CancelQRFailedState(this.msg);

  @override
  List<Object?> get props => [msg];
}
