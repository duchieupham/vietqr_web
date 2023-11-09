import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/features/login/events/qrcode_un_authen_event.dart';
import 'package:VietQR/features/login/repositories/qrcode_un_authen_respository.dart';
import 'package:VietQR/features/login/states/login_state.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/transaction_qr_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRCodeUnUTBloc extends Bloc<QRCodeUnUTEvent, QRCodeUnUTState> {
  QRCodeUnUTBloc() : super(CreateInitialState()) {
    on<QRCodeUnUTCreateQR>(_createQR);
    on<GetTransactionQRBytToken>(_createTransactionQR);
    on<QRGenerateCancelEvent>(_cancelQR);
  }
}

const QRCodeUnUTRepository _repository = QRCodeUnUTRepository();

void _cancelQR(QRCodeUnUTEvent event, Emitter emit) async {
  try {
    if (event is QRGenerateCancelEvent) {
      emit(CreateQRLoadingState());
      final ResponseMessageDTO result = await _repository.cancelQR(event.token);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(CancelQRSuccessState());
      } else {
        String msg = ErrorUtils.instance.getErrorMessage(result.message);
        emit(CancelQRFailedState(msg));
      }
    }
  } catch (e) {
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    String msg =
        ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
    emit(CancelQRFailedState(msg));
  }
}

void _createQR(QRCodeUnUTEvent event, Emitter emit) async {
  try {
    if (event is QRCodeUnUTCreateQR) {
      emit(CreateQRLoadingState());
      final QRGeneratedDTO result = await _repository.generateQR(event.data);
      emit(CreateSuccessfulState(dto: result));
    }
  } catch (e) {
    print('Error at login - LoginBloc: $e');
    emit(LoginFailedState());
  }
}

void _createTransactionQR(QRCodeUnUTEvent event, Emitter emit) async {
  TransactionQRDTO result = const TransactionQRDTO();
  try {
    if (event is GetTransactionQRBytToken) {
      emit(CreateQRLoadingState());
      final TransactionQRDTO result =
          await _repository.getTransactionQR(event.token);
      emit(CreateTransactionQRSuccessfulState(dto: result));
    }
  } catch (e) {
    print('Error at login - _createTransactionQR: $e');
    emit(CreateFailedState());
  }
}
