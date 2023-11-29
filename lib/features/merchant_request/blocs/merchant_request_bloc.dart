import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/merchant_request/events/merchant_request_event.dart';
import 'package:VietQR/features/merchant_request/repositories/merchant_rq_repository.dart';
import 'package:VietQR/features/merchant_request/states/merchant_request_state.dart';
import 'package:VietQR/models/generate_username_pass_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MerchantRequestBloc
    extends Bloc<MerchantRequestEvent, MerchantRequestState> {
  MerchantRequestBloc() : super(MerchantInitialState()) {
    on<ClearState>(_clearState);
    on<InsertMerchantEvent>(_insert);
    on<GetTokenEvent>(_getToken);
    on<CheckValidMerchantName>(_checkValidMerchantName);
    on<GenerateUserNamePass>(_generateUsernamePass);
  }
}

const MerchantRQRepository merchantRQRepository = MerchantRQRepository();
void _clearState(MerchantRequestEvent event, Emitter emit) async {
  if (event is ClearState) {
    emit(MerchantInitialState());
  }
}

void _insert(MerchantRequestEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is InsertMerchantEvent) {
      emit(MerchantLoadingState());
      result = await merchantRQRepository.insert(event.param);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(InsertSuccessfulState(dto: result));
      } else {
        emit(InsertFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    String msg =
        ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
    emit(InsertFailedState(dto: responseMessageDTO));
  }
}

void _checkValidMerchantName(MerchantRequestEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is CheckValidMerchantName) {
      emit(CheckValidMerchantNameLoadingState());
      result = await merchantRQRepository.checkValidMerchantName(event.param);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(CheckValidNameSuccessfulState(dto: result));
      } else {
        String msg = ErrorUtils.instance.getErrorMessage(result.message);
        emit(CheckValidNameFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    String msg =
        ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
    emit(CheckValidNameFailedState(dto: responseMessageDTO));
  }
}

void _generateUsernamePass(MerchantRequestEvent event, Emitter emit) async {
  GenerateUserNamePassDto result = const GenerateUserNamePassDto();
  try {
    if (event is GenerateUserNamePass) {
      emit(GenerateNamePassLoadingState());
      result = await merchantRQRepository.generateUsernamePassword(event.param);
      emit(GenerateNamePassSuccessfulState(dto: result));
    }
  } catch (e) {
    emit(GenerateNamePassSuccessfulState(dto: result));
  }
}

void _getToken(MerchantRequestEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO();
  try {
    if (event is GetTokenEvent) {
      emit(NewConnectGetTokenLoadingState());
      result = await merchantRQRepository.getToken(event.param);
      if (result.status == "SUCCESS") {
        emit(GetTokenSuccessfulState(dto: result));
      } else {
        emit(GetTokenFailedState(dto: result));
      }
    }
  } catch (e) {
    print('Error at new connect- _getToken: $e');
    emit(GetTokenFailedState(dto: result));
  }
}
