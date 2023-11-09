import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/vhitek/events/vhitek_event.dart';
import 'package:VietQR/features/vhitek/responsitory/vhitek_responesitory.dart';
import 'package:VietQR/features/vhitek/states/vhitek_state.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VhitekBloc extends Bloc<VhitekEvent, VhitekState> {
  VhitekBloc() : super(VhitekStateInitialState()) {
    on<CheckUserValidEvent>(_checkUserValid);
    on<CreateUserEvent>(_createUser);
    on<ActiveEvent>(_active);
  }
}

VhitekRepository _vhitekRepository = const VhitekRepository();

void _checkUserValid(VhitekEvent event, Emitter emit) async {
  try {
    if (event is CheckUserValidEvent) {
      emit(VhitekStateLoadingState());
      final ResponseMessageDTO result =
          await _vhitekRepository.checkValidUser(event.email);
      emit(VhitekCheckUserValidSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _createUser(VhitekEvent event, Emitter emit) async {
  try {
    if (event is CreateUserEvent) {
      emit(VhitekStateLoadingState());
      final ResponseMessageDTO result =
          await _vhitekRepository.createUser(event.param);

      emit(VhitekCreateUserSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _active(VhitekEvent event, Emitter emit) async {
  try {
    if (event is ActiveEvent) {
      emit(VhitekStateLoadingState());
      print(event.param);
      final ResponseMessageDTO result =
          await _vhitekRepository.active(event.param);
      emit(VhitekActiveSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}
