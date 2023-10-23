import 'package:VietQR/models/qr_create_dto.dart';
import 'package:equatable/equatable.dart';

class CreateQREvent extends Equatable {
  const CreateQREvent();

  @override
  List<Object?> get props => [];
}

class GetListBankAccount extends CreateQREvent {}

class BankEventGetDetail extends CreateQREvent {
  final String bankId;

  const BankEventGetDetail({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class QREventGenerate extends CreateQREvent {
  final QRCreateDTO dto;

  const QREventGenerate({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
