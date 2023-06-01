import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/qr/events/qr_event.dart';
import 'package:VietQR/features/qr/repositories/qr_repository.dart';
import 'package:VietQR/features/qr/states/qr_state.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRBloc extends Bloc<QREvent, QRState> {
  QRBloc() : super(QRInitialState()) {
    on<QREventGenerate>(_generateQR);
  }
}

QRRepository _qrRepository = const QRRepository();

void _generateQR(QREvent event, Emitter emit) async {
  try {
    if (event is QREventGenerate) {
      emit(QRLoadingState());
      final QRGeneratedDTO result = await _qrRepository.generateQR(event.dto);
      emit(QRGenerateSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}
