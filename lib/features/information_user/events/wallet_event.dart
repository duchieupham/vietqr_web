import 'package:equatable/equatable.dart';

class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class WalletGetInfoEvent extends WalletEvent {}
