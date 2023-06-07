import 'package:VietQR/models/notification_input_dto.dart';
import 'package:equatable/equatable.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationGetListEvent extends NotificationEvent {
  final NotificationInputDTO dto;

  const NotificationGetListEvent({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class NotificationFetchEvent extends NotificationEvent {
  final NotificationInputDTO dto;

  const NotificationFetchEvent({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class NotificationUpdateStatusEvent extends NotificationEvent {
  final String userId;

  const NotificationUpdateStatusEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class NotificationGetCounterEvent extends NotificationEvent {
  final String userId;

  const NotificationGetCounterEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
