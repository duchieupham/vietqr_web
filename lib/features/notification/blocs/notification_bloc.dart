import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/notification/events/notification_event.dart';
import 'package:VietQR/features/notification/repositories/notification_repository.dart';
import 'package:VietQR/features/notification/states/notification_state.dart';
import 'package:VietQR/models/notification_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitialState()) {
    on<NotificationGetCounterEvent>(_getCounter);
    on<NotificationGetListEvent>(_getNotifications);
    on<NotificationFetchEvent>(_fetchNotifications);
    on<NotificationUpdateStatusEvent>(_updateNotificationStatus);
  }
}

NotificationRepository notificationRepository = const NotificationRepository();

void _getCounter(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationGetCounterEvent) {
      emit(NotificationCountingState());
      int counter = await notificationRepository.getCounter(event.userId);
      emit(NotificationCountSuccessState(count: counter));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(NotificationCountFailedState());
  }
}

void _getNotifications(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationGetListEvent) {
      List<NotificationDTO> list =
          await notificationRepository.getNotificationsByUserId(event.dto);
      emit(NotificationGetListSuccessState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(NotificationGetListFailedState());
  }
}

void _fetchNotifications(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationFetchEvent) {
      List<NotificationDTO> list =
          await notificationRepository.getNotificationsByUserId(event.dto);
      emit(NotificationFetchSuccessState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(NotificationFetchFailedState());
  }
}

void _updateNotificationStatus(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationUpdateStatusEvent) {
      bool check =
          await notificationRepository.updateNotificationStatus(event.userId);
      if (check) {
        emit(NotificationUpdateStatusSuccessState());
      } else {
        emit(NotificationUpdateFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(NotificationUpdateFailedState());
  }
}
