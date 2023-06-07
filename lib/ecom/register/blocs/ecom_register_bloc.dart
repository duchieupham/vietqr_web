import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/ecom/login/repositories/ecom_login_repository.dart';
import 'package:VietQR/ecom/register/events/ecom_register_event.dart';
import 'package:VietQR/ecom/register/repositories/ecom_register_repository.dart';
import 'package:VietQR/ecom/register/states/ecom_register_state.dart';
import 'package:VietQR/features/register/events/register_event.dart';
import 'package:VietQR/features/register/repositories/register_repository.dart';
import 'package:VietQR/features/register/states/register_state.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ECOMRegisterBloc extends Bloc<ECOMRegisterEvent, ECOMRegisterState> {
  ECOMRegisterBloc() : super(ECOMRegisterInitialState()) {
    on<ECOMRegisterEventSubmit>(_register);
  }
}

const ECOMRegisterRepository registerRepository = ECOMRegisterRepository();
const ECOMLoginRepository loginRepository = ECOMLoginRepository();
void _register(ECOMRegisterEvent event, Emitter emit) async {
  try {
    if (event is ECOMRegisterEventSubmit) {
      emit(ECOMRegisterLoadingState());
      ResponseMessageDTO responseMessageDTO =
          await registerRepository.register(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        bool check = await loginRepository.login(event.dto);
        if (check) {
          emit(ECOMRegisterSuccessState());
        } else {
          String msg =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(ECOMRegisterFailedState(msg: msg));
        }
      } else {
        String msg =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(ECOMRegisterFailedState(msg: msg));
      }
    }
  } catch (e) {
    print('Error at register - RegisterBloc: $e');
    emit(const ECOMRegisterFailedState(
        msg: 'Không thể đăng ký. Vui lòng kiểm tra lại kết nối.'));
  }
}
