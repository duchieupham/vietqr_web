import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/transaction_user/events/tran_user_event.dart';
import 'package:VietQR/features/transaction_user/repositories/trans_user_repository.dart';
import 'package:VietQR/features/transaction_user/states/trans_user_state.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionUserBloc extends Bloc<TransUserEvent, TransUserState> {
  TransactionUserBloc() : super(GetListTransactionInitialState()) {
    on<GetListTransactionByEvent>(_getListTransactionByUser);
    on<UpdateNoteEvent>(_updateNote);
  }
}

const TransUserRepository repository = TransUserRepository();

void _updateNote(TransUserEvent event, Emitter emit) async {
  ResponseMessageDTO result;
  try {
    if (event is UpdateNoteEvent) {
      result = await repository.updateNote(event.param);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(UpdateNoteState());
      } else {
        String msg = ErrorUtils.instance.getErrorMessage(result.message);
        emit(UpdateNoteFailedState(msg));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    String msg =
        ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
    emit(UpdateNoteFailedState(msg));
  }
}

void _getListTransactionByUser(TransUserEvent event, Emitter emit) async {
  List<TransactionMerchantDTO> list = [];
  try {
    if (event is GetListTransactionByEvent) {
      if (event.isLoadingPage) {
        emit(GetListTransactionLoadingInitState());
      } else if (event.isLoadMore) {
        emit(GetListTransactionLoadMoreListState());
      } else {
        emit(GetListTransactionLoadingListState());
      }

      list = await repository.getListTransactionByUser(event.param);
      emit(GetListTransactionByUserSuccessfulState(
          list: list,
          isLoadingPage: event.isLoadingPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(GetListTransactionByUserSuccessfulState(list: list));
  }
}
