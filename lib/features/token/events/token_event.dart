import 'package:equatable/equatable.dart';

class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object?> get props => [];
}

class TokenEventCheckValid extends TokenEvent {
  const TokenEventCheckValid();

  @override
  List<Object?> get props => [];
}

class TokenFcmUpdateEvent extends TokenEvent {
  const TokenFcmUpdateEvent();

  @override
  List<Object?> get props => [];
}

class TokenEventLogout extends TokenEvent {}
