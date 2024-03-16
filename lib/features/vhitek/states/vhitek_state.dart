import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/store_model.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:equatable/equatable.dart';

class VhitekState extends Equatable {
  const VhitekState();

  @override
  List<Object?> get props => [];
}

class VhitekStateInitialState extends VhitekState {}

class VhitekStateLoadingState extends VhitekState {}

class VhitekLoginLoadingState extends VhitekState {}

class VhitekCheckUserValidSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const VhitekCheckUserValidSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ConfirmStoreSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const ConfirmStoreSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class VhitekCreateUserSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const VhitekCreateUserSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class VhitekActiveSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const VhitekActiveSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class LoginByUserIdSuccessState extends VhitekState {
  final bool result;

  const LoginByUserIdSuccessState({required this.result});

  @override
  List<Object?> get props => [result];
}

class VhitekGetTerminalsSuccessState extends VhitekState {
  final List<TerminalQRDTO> terminals;

  const VhitekGetTerminalsSuccessState({required this.terminals});

  @override
  List<Object?> get props => [terminals];
}
