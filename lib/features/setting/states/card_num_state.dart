import 'package:equatable/equatable.dart';

class CardNumState extends Equatable {
  const CardNumState();

  @override
  List<Object?> get props => [];
}

class CardNumInitialState extends CardNumState {}

class CardNumLoadingState extends CardNumState {}

class CardNumGetSuccessState extends CardNumState {
  final String cardNumber;

  const CardNumGetSuccessState({required this.cardNumber});

  @override
  List<Object?> get props => [cardNumber];
}

class CardNumGetFailedState extends CardNumState {}

class CardNumUpdateSuccessState extends CardNumState {}

class CardNumUpdateFailedState extends CardNumState {}

class CardNumCompareSuccessState extends CardNumState {}

class CardNumCompareFailedState extends CardNumState {}
