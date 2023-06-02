import 'package:VietQR/features/login/events/qrcode_un_authen_event.dart';
import 'package:VietQR/features/login/repositories/qrcode_un_authen_respository.dart';
import 'package:VietQR/features/login/states/login_state.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRCodeUnUTBloc extends Bloc<QRCodeUnUTEvent, QRCodeUnUTState> {
  QRCodeUnUTBloc() : super(CreateInitialState()) {
    on<QRCodeUnUTCreateQR>(_createQR);
  }
}

const QRCodeUnUTRepository _repository = QRCodeUnUTRepository();

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
