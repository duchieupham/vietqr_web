import 'package:equatable/equatable.dart';

class InformationUserState extends Equatable {
  const InformationUserState();

  @override
  List<Object?> get props => [];
}

class InformationUserInitialState extends InformationUserState {}

class InformationUserLoadingState extends InformationUserState {}

class InformationUserSuccessfulState extends InformationUserState {}

class InformationUserFailedState extends InformationUserState {
  final String msg;

  const InformationUserFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class InformationUserPasswordSuccessfulState extends InformationUserState {}

class InformationUserPasswordFailedState extends InformationUserState {
  final String msg;

  const InformationUserPasswordFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class InformationUserAvatarSuccessState extends InformationUserState {}

class InformationUserAvatarFailedState extends InformationUserState {
  final String message;

  const InformationUserAvatarFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserDeActiveSuccessState extends InformationUserState {}

class UserDeActiveFailedState extends InformationUserState {
  final String message;

  const UserDeActiveFailedState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
