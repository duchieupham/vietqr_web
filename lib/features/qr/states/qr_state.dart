import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:equatable/equatable.dart';

class QRState extends Equatable {
  const QRState();

  @override
  List<Object?> get props => [];
}

class QRInitialState extends QRState {}

class QRLoadingState extends QRState {}

class QRGenerateSuccessState extends QRState {
  final QRGeneratedDTO dto;

  const QRGenerateSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QRGenerateFailedState extends QRState {}
