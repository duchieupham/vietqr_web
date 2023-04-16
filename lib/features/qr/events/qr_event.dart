import 'package:VietQR/models/qr_create_dto.dart';
import 'package:equatable/equatable.dart';

class QREvent extends Equatable {
  const QREvent();

  @override
  List<Object?> get props => [];
}

class QREventGenerate extends QREvent {
  final QRCreateDTO dto;

  const QREventGenerate({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
