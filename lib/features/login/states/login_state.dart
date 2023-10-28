import 'package:VietQR/models/info_user_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessfulState extends LoginState {}

class LoginQRSuccessfulState extends LoginState {}

class LoginFailedState extends LoginState {}

class ExistPhoneState extends LoginState {
  final InfoUserDTO infoUserDTO;
  const ExistPhoneState({required this.infoUserDTO});

  @override
  List<Object?> get props => [infoUserDTO];
}

class NotExistPhoneState extends LoginState {
  final ResponseMessageDTO dto;
  const NotExistPhoneState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
