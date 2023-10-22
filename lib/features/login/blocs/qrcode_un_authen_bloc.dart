import 'package:VietQR/features/login/events/qrcode_un_authen_event.dart';
import 'package:VietQR/features/login/repositories/qrcode_un_authen_respository.dart';
import 'package:VietQR/features/login/states/login_state.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction_qr_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRCodeUnUTBloc extends Bloc<QRCodeUnUTEvent, QRCodeUnUTState> {
  QRCodeUnUTBloc() : super(CreateInitialState()) {
    on<QRCodeUnUTCreateQR>(_createQR);
    on<GetTransactionQRBytToken>(_createTransactionQR);
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
