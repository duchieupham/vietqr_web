import 'package:VietQR/features/login/blocs/login_bloc.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/models/account_login_method_dto.dart';
import 'package:VietQR/models/code_login_dto.dart';
import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEventByPhone extends LoginEvent {
  final AccountLoginDTO dto;
  const LoginEventByPhone({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class LoginEventByCardNumber extends LoginEvent {
  final AccountLoginMethodDTO dto;

  const LoginEventByCardNumber({required this.dto});

  @override
  List<Object?> get props => [dto];
}

// class LoginEventGetUserInformation extends LoginEvent {
//   final String userId;

//   const LoginEventGetUserInformation({required this.userId});

//   @override
//   List<Object?> get props => [userId];
// }

class LoginEventInsertCode extends LoginEvent {
  final String code;
  final LoginBloc loginBloc;

  const LoginEventInsertCode({required this.code, required this.loginBloc});

  @override
  List<Object?> get props => [code, loginBloc];
}

class LoginEventListen extends LoginEvent {
  final String code;
  final LoginBloc loginBloc;

  const LoginEventListen({required this.code, required this.loginBloc});

  @override
  List<Object?> get props => [code, loginBloc];
}

class LoginEventReceived extends LoginEvent {
  final CodeLoginDTO dto;

  const LoginEventReceived({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class LoginEventUpdateCode extends LoginEvent {
  final String code;
  final String userId;

  const LoginEventUpdateCode({required this.code, required this.userId});

  @override
  List<Object?> get props => [code, userId];
}

class CheckExistPhone extends LoginEvent {
  final String phone;

  const CheckExistPhone({required this.phone});

  @override
  List<Object?> get props => [phone];
}
class LoginQREvent extends LoginEvent {
  final String userId;

  const LoginQREvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}