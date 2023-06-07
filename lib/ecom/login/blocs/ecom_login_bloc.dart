import 'package:VietQR/ecom/login/events/ecom_login_event.dart';
import 'package:VietQR/ecom/login/repositories/ecom_login_repository.dart';
import 'package:VietQR/ecom/login/states/ecom_login_state.dart';
import 'package:VietQR/features/home/repositories/user_setting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/shared_references/web_socket_helper.dart';

class ECOMLoginBloc extends Bloc<ECOMLoginEvent, ECOMLoginState> {
  ECOMLoginBloc() : super(ECOMLoginInitialState()) {
    on<ECOMLoginEventByPhone>(_login);
  }
}

const ECOMLoginRepository loginRepository = ECOMLoginRepository();
const UserSettingRepository userSettingRepository = UserSettingRepository();
void _login(ECOMLoginEvent event, Emitter emit) async {
  try {
    if (event is ECOMLoginEventByPhone) {
      emit(ECOMLoginLoadingState());
      bool check = await loginRepository.login(event.dto);
      // await userSettingRepository.getGuideWeb(userId)
      if (check) {
        emit(ECOMLoginSuccessfulState());
      } else {
        emit(ECOMLoginFailedState());
      }
    }
  } catch (e) {
    print('Error at login - LoginBloc: $e');
    emit(ECOMLoginFailedState());
  }
}
