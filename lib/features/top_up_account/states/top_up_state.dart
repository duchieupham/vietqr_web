import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:equatable/equatable.dart';

class TopUpState extends Equatable {
  const TopUpState();

  @override
  List<Object?> get props => [];
}

class TopUpInitialState extends TopUpState {}

class TopUpLoadingState extends TopUpState {}

class TopUpGetInfoSuccessState extends TopUpState {
  final AccountInformationDTO dto;

  const TopUpGetInfoSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class TopUpSuccessState extends TopUpState {
  final AccountInformationDTO dto;

  const TopUpSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class QTopUpGenerateFailedState extends TopUpState {}
