import 'package:VietQR/models/wallet_dto.dart';
import 'package:equatable/equatable.dart';

class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitialState extends WalletState {}

class WalletLoadingState extends WalletState {}

class WalletSuccessfulState extends WalletState {
  final WalletDTO walletDTO;
  const WalletSuccessfulState({required this.walletDTO});

  @override
  List<Object?> get props => [walletDTO];
}

class WalletFailedState extends WalletState {
  final String msg;

  const WalletFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
