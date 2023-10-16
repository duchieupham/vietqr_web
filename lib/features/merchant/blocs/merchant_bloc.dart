import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/repositories/merchant_repository.dart';
import 'package:VietQR/features/merchant/states/merchant_state.dart';
import 'package:VietQR/models/account_is_merchant.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/active_fee_dto.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  MerchantBloc() : super(MerchantInitialState()) {
    on<CheckAccountIsMerchantEvent>(_checkAccountIsMerchant);
    on<GetMerchantFeeEvent>(_getMerchantFee);
    on<GetListTransactionByUserEvent>(_getListTransactionByUser);
    on<GetListTransactionByMerchantEvent>(_getListTransactionByMerchant);
  }
}

const MerchantRepository merchantRepository = MerchantRepository();

void _checkAccountIsMerchant(MerchantEvent event, Emitter emit) async {
  AccountIsMerchantDTO result = const AccountIsMerchantDTO();

  try {
    if (event is CheckAccountIsMerchantEvent) {
      String userId = UserInformationHelper.instance.getUserId();
      result = await merchantRepository.checkAccountIsMerchant(userId);
      emit(MerchantCheckAccountIsMerchantSuccessfulState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantCheckAccountIsMerchantSuccessfulState(dto: result));
  }
}

void _getMerchantFee(MerchantEvent event, Emitter emit) async {
  List<ActiveFeeDTO> list = [];
  try {
    if (event is GetMerchantFeeEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingActiveFeeState());
      } else {
        emit(MerchantLoadingInitState());
      }
      list = await merchantRepository.getMerchantFee(
          event.customerSyncId, event.month);
      emit(MerchantGetMerchantFeeSuccessfulState(
          list: list, isLoadingPage: event.isLoadingPage));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetMerchantFeeSuccessfulState(list: list));
  }
}

void _getListTransactionByUser(MerchantEvent event, Emitter emit) async {
  List<TransactionMerchantDTO> list = [];
  try {
    if (event is GetListTransactionByUserEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingInitState());
      } else {
        emit(MerchantLoadingListState());
      }

      list = await merchantRepository.getListTransactionByUser(event.param);
      emit(MerchantGetListByUserSuccessfulState(
          list: list, isLoadingPage: event.isLoadingPage));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetListByUserSuccessfulState(list: list));
  }
}

void _getListTransactionByMerchant(MerchantEvent event, Emitter emit) async {
  List<TransactionMerchantDTO> list = [];
  try {
    if (event is GetListTransactionByMerchantEvent) {
      if (event.isLoadingPage) {
        emit(MerchantLoadingInitState());
      } else if (event.isLoadMore) {
        emit(MerchantLoadMoreListState());
      } else {
        emit(MerchantLoadingListState());
      }
      list = await merchantRepository.getListTransactionByMerchant(event.param);
      emit(MerchantGetListByMerchantSuccessfulState(
          list: list,
          isLoadingPage: event.isLoadingPage,
          isLoadMore: event.isLoadMore));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MerchantGetListByMerchantSuccessfulState(list: list));
  }
}
