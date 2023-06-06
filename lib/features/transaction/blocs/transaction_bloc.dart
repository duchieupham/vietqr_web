import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/repositories/transaction_repository.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_receive_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<TransactionEventGetList>(_getTransactions);
    on<TransactionEventFetch>(_fetchTransactions);
    on<TransactionEventGetDetail>(_getDetail);
  }
}

const TransactionRepository _transactionRepository = TransactionRepository();

void _getTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventGetList) {
      emit(TransactionLoadingState());
      final List<RelatedTransactionReceiveDTO> result =
          await _transactionRepository.getTransactionByBankId(event.dto);
      emit(TransactionGetListSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionGetListFailedState());
  }
}

void _fetchTransactions(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventFetch) {
      emit(TransactionLoadingState());
      final List<RelatedTransactionReceiveDTO> result =
          await _transactionRepository.getTransactionByBankId(event.dto);
      emit(TransactionFetchSuccessState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionFetchFailedState());
  }
}

void _getDetail(TransactionEvent event, Emitter emit) async {
  try {
    if (event is TransactionEventGetDetail) {
      emit(TransactionDetailLoadingState());
      TransactionReceiveDTO dto =
          await _transactionRepository.getTransactionDetail(event.id);
      emit(TransactionDetailSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TransactionDetailFailedState());
  }
}
