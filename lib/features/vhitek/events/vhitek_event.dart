import 'package:equatable/equatable.dart';

class VhitekEvent extends Equatable {
  const VhitekEvent();

  @override
  List<Object?> get props => [];
}

class GetTerminalsEvent extends VhitekEvent {
  final String bankId;

  const GetTerminalsEvent(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class ConfirmStoreEvent extends VhitekEvent {
  final String terminalId;
  final String midCode;

  const ConfirmStoreEvent({
    required this.terminalId,
    required this.midCode,
  });

  @override
  List<Object?> get props => [terminalId, midCode];
}

class CheckUserValidEvent extends VhitekEvent {
  final String email;

  const CheckUserValidEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class CreateUserEvent extends VhitekEvent {
  final Map<String, dynamic> param;

  const CreateUserEvent({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}

class ActiveEvent extends VhitekEvent {
  final Map<String, dynamic> param;

  const ActiveEvent({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}

class LoginByUserIdEvent extends VhitekEvent {
  final String userId;

  const LoginByUserIdEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
