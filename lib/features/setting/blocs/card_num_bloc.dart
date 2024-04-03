import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/setting/events/card_num_event.dart';
import 'package:VietQR/features/setting/repositories/card_num_repository.dart';
import 'package:VietQR/features/setting/states/card_num_state.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardNumBloc extends Bloc<CardNumEvent, CardNumState> {
  CardNumBloc() : super(CardNumInitialState()) {
    on<CardNumEventGet>(_getCardNumber);
    on<CardNumEventUpdate>(_updateCardNumber);
    on<CardNumEventCompare>(_compare);
  }
}

const CardNumRepository _cardNumRepository = CardNumRepository();

void _getCardNumber(CardNumEvent event, Emitter emit) async {
  try {
    if (event is CardNumEventGet) {
      ResponseMessageDTO result =
          await _cardNumRepository.getCardNumberByUserId(event.userId);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(CardNumGetSuccessState(cardNumber: result.message));
      } else {
        emit(CardNumGetFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(CardNumGetFailedState());
  }
}

void _updateCardNumber(CardNumEvent event, Emitter emit) async {
  try {
    if (event is CardNumEventUpdate) {
      ResponseMessageDTO result =
          await _cardNumRepository.updateCardNumber(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(CardNumUpdateSuccessState());
      } else {
        emit(CardNumUpdateFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(CardNumUpdateFailedState());
  }
}

void _compare(CardNumEvent event, Emitter emit) async {
  try {
    if (event is CardNumEventCompare) {
      if (event.id.trim() == event.confirm.trim()) {
        emit(CardNumCompareSuccessState());
      } else {
        emit(CardNumCompareFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(CardNumCompareFailedState());
  }
}
