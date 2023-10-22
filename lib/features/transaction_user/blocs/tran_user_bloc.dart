import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/transaction_user/events/tran_user_event.dart';
import 'package:VietQR/features/transaction_user/repositories/trans_user_repository.dart';
import 'package:VietQR/features/transaction_user/states/trans_user_state.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionUserBloc extends Bloc<TransUserEvent, TransUserState> {
  TransactionUserBloc() : super(GetListTransactionInitialState()) {
    on<GetListTransactionByEvent>(_getListTransactionByUser);
  }
}

const TransUserRepository repository = TransUserRepository();

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
