import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/logout/events/log_out_event.dart';
import 'package:VietQR/features/logout/repositories/log_out_repository.dart';
import 'package:VietQR/features/logout/states/log_out_state.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc() : super(LogoutInitialState()) {
    on<LogoutEventSubmit>(_logOutSubmit);
  }
}

const LogoutRepository logoutRepository = LogoutRepository();

void _logOutSubmit(LogoutEvent event, Emitter emit) async {
  try {
    if (event is LogoutEventSubmit) {
      emit(LogoutLoadingState());
      bool check = await logoutRepository.logout();
      if (check) {
        emit(LogoutSuccessfulState());
        Session.instance.clearData();
        WebSocketHelper.instance.closeListenTransaction();
      } else {
        emit(LogoutFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(LogoutFailedState());
  }
}
