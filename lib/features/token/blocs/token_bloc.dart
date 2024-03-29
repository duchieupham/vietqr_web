import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/logout/repositories/log_out_repository.dart';
import 'package:VietQR/features/token/events/token_event.dart';
import 'package:VietQR/features/token/repositories/token_repository.dart';
import 'package:VietQR/features/token/states/token_state.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc() : super(TokenInitialState()) {
    on<TokenEventCheckValid>(_checkValidToken);
    // on<TokenFcmUpdateEvent>(_updateFcmToken);
    on<GetAccountSettingEvent>(_getAccountSetting);
    on<TokenEventLogout>(_logout);
  }
}

const TokenRepository tokenRepository = TokenRepository();
const LogoutRepository logoutRepository = LogoutRepository();

void _logout(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenEventLogout) {
      emit(TokenCheckingState());
      bool check = await logoutRepository.logout();
      if (check) {
        emit(TokenExpiredLogoutState());
        Session.instance.clearData();
        WebSocketHelper.instance.closeListenTransaction();
      } else {
        emit(TokenLogoutFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenLogoutFailedState());
  }
}

void _checkValidToken(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenEventCheckValid) {
      emit(TokenCheckingState());
      int check = await tokenRepository.checkValidToken();
      if (check == 0) {
        emit(TokenInvalidState());
      } else if (check == 1) {
        emit(TokenValidState());
      } else if (check == 2) {
        emit(SystemMaintainState());
      } else if (check == 3) {
        emit(SystemConnectionFailedState());
      } else if (check == 4) {
        emit(TokenExpiredState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenInvalidState());
  }
}

void _getAccountSetting(TokenEvent event, Emitter emit) async {
  try {
    if (event is TokenEventCheckValid) {
      emit(TokenCheckingState());
      int result = await tokenRepository.getAccountSetting();
      emit(GetAccountSettingSuccess(result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TokenInvalidState());
  }
}

// void _updateFcmToken(TokenEvent event, Emitter emit) async {
//   try {
//     if (event is TokenFcmUpdateEvent) {
//       bool check = await tokenRepository.updateFcmToken();
//       if (check) {
//         emit(TokenFcmUpdateSuccessState());
//       } else {
//         emit(TokenFcmUpdateFailedState());
//       }
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TokenFcmUpdateFailedState());
//   }
// }
