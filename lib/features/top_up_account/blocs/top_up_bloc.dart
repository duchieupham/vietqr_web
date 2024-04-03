import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/qr/events/qr_event.dart';
import 'package:VietQR/features/qr/repositories/qr_repository.dart';
import 'package:VietQR/features/qr/states/qr_state.dart';
import 'package:VietQR/features/top_up_account/events/top_up_event.dart';
import 'package:VietQR/features/top_up_account/repositories/top_up_repository.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/top_up_state.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  TopUpBloc() : super(TopUpInitialState()) {
    on<TopUpEventGetInfoAccount>(_getInfoUser);
  }
}

TopUpRepository _topUpRepository = const TopUpRepository();

void _getInfoUser(TopUpEvent event, Emitter emit) async {
  try {
    if (event is TopUpEventGetInfoAccount) {
      emit(TopUpLoadingState());
      final AccountInformationDTO result =
          await _topUpRepository.getInfomation(event.phoneNumber);
      emit(TopUpGetInfoSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}
