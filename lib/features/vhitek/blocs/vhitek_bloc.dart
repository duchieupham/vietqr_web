import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/transaction/repositories/transaction_repository.dart';
import 'package:VietQR/features/vhitek/events/vhitek_event.dart';
import 'package:VietQR/features/vhitek/responsitory/vhitek_responesitory.dart';
import 'package:VietQR/features/vhitek/states/vhitek_state.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VhitekBloc extends Bloc<VhitekEvent, VhitekState> {
  VhitekBloc() : super(VhitekStateInitialState()) {
    on<CheckUserValidEvent>(_checkUserValid);
    on<CreateUserEvent>(_createUser);
    on<ActiveEvent>(_active);
    on<LoginByUserIdEvent>(_loginByUserId);
    on<GetTerminalsEvent>(_getTerminals);
    on<ConfirmStoreEvent>(_confirmStore);
  }
}

VhitekRepository _vhitekRepository = const VhitekRepository();
TransactionRepository repository = TransactionRepository();

void _getTerminals(VhitekEvent event, Emitter emit) async {
  try {
    if (event is GetTerminalsEvent) {
      emit(VhitekStateInitialState());
      List<TerminalQRDTO> list = await repository.getTerminals(event.bankId);

      list = [...list];

      emit(VhitekGetTerminalsSuccessState(terminals: list));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _confirmStore(VhitekEvent event, Emitter emit) async {
  try {
    if (event is ConfirmStoreEvent) {
      emit(VhitekStateLoadingState());
      final ResponseMessageDTO result =
          await _vhitekRepository.confirmStore(event.terminalId, event.midCode);
      emit(ConfirmStoreSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

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

      final ResponseMessageDTO result =
          await _vhitekRepository.active(event.param);
      emit(VhitekActiveSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _loginByUserId(VhitekEvent event, Emitter emit) async {
  try {
    if (event is LoginByUserIdEvent) {
      emit(VhitekLoginLoadingState());
      bool result = await _vhitekRepository.loginByUserId(event.userId);
      emit(LoginByUserIdSuccessState(result: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}
