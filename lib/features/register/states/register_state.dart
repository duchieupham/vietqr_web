import 'package:VietQR/models/account_login_dto.dart';
import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final AccountLoginDTO dto;
  const RegisterSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class RegisterFailedState extends RegisterState {
  final String msg;

  const RegisterFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class LoginSuccessState extends RegisterState {}

class LoginFailedState extends RegisterState {}
