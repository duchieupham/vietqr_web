import 'package:VietQR/models/account_card_num_dto.dart';
import 'package:equatable/equatable.dart';

class CardNumEvent extends Equatable {
  const CardNumEvent();

  @override
  List<Object?> get props => [];
}

class CardNumEventGet extends CardNumEvent {
  final String userId;

  const CardNumEventGet({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CardNumEventUpdate extends CardNumEvent {
  final AccountCardNumDTO dto;

  const CardNumEventUpdate({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class CardNumEventCompare extends CardNumEvent {
  final String id;
  final String confirm;

  const CardNumEventCompare({
    required this.id,
    required this.confirm,
  });

  @override
  List<Object?> get props => [id, confirm];
}
