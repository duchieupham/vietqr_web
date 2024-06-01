import 'package:VietQR/models/notification_dto.dart';
import 'package:equatable/equatable.dart';

import '../../../models/noti_invoice_dto.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationCountingState extends NotificationState {}

class NotificationCountSuccessState extends NotificationState {
  final int count;

  const NotificationCountSuccessState({
    required this.count,
  });

  @override
  List<Object?> get props => [count];
}

class NotificationInvoiceLoadingState extends NotificationState {}

class NotificationInvoiceFailedState extends NotificationState {}

class NotificationInvoiceSuccessState extends NotificationState {
  final NotificationInvoiceDTO noti;

  const NotificationInvoiceSuccessState({
    required this.noti,
  });

  @override
  List<Object?> get props => [noti];
}

class NotificationCountFailedState extends NotificationState {}

class NotificationGetListSuccessState extends NotificationState {
  final List<NotificationDTO> list;

  const NotificationGetListSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class NotificationFetchSuccessState extends NotificationState {
  final List<NotificationDTO> list;

  const NotificationFetchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class NotificationFetchFailedState extends NotificationState {}

class NotificationGetListFailedState extends NotificationState {}

class NotificationUpdateStatusSuccessState extends NotificationState {}

class NotificationUpdateFailedState extends NotificationState {}
