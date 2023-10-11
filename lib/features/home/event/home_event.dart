import 'package:VietQR/models/qr_create_dto.dart';
import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class BankCardEventGetList extends HomeEvent {}

class BankCardGetDetailEvent extends HomeEvent {
  final bool isLoading;
  final String bankId;

  const BankCardGetDetailEvent({
    this.isLoading = true,
    required this.bankId,
  });

  @override
  List<Object?> get props => [isLoading, bankId];
}

class ScanQrEventGetBankType extends HomeEvent {
  final String code;

  const ScanQrEventGetBankType({required this.code});

  @override
  List<Object?> get props => [code];
}

class QREventGenerateList extends HomeEvent {
  final List<QRCreateDTO> list;

  const QREventGenerateList({required this.list});

  @override
  List<Object?> get props => [list];
}

class UpdateEvent extends HomeEvent {}

class LoadDataBankEvent extends HomeEvent {}
