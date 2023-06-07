import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:equatable/equatable.dart';

class QRCodeUnUTState extends Equatable {
  const QRCodeUnUTState();

  @override
  List<Object?> get props => [];
}

class CreateInitialState extends QRCodeUnUTState {}

class CreateQRLoadingState extends QRCodeUnUTState {}

class CreateSuccessfulState extends QRCodeUnUTState {
  final QRGeneratedDTO dto;

  const CreateSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CreateFailedState extends QRCodeUnUTState {}
