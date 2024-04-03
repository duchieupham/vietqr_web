import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/merchant_request/repositories/callback_repository.dart';
import 'package:VietQR/features/merchant_request/states/run_call_back_state.dart';
import 'package:VietQR/models/api_service_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/callback_dto.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/run_callback_event.dart';

class RunCallbackBloc extends Bloc<CallbackEvent, RunCallBackState> {
  RunCallbackBloc() : super(CallbackInitialState()) {
    on<GetTransEvent>(_getTrans);
    on<GetTransLoadMoreEvent>(_getTransLoadMore);
    // on<GetListCustomerEvent>(_getListCustomer);
    on<GetListBankEvent>(_getListBank);
    on<GetInfoConnectEvent>(_getInfo);
    on<GetTokenEvent>(_loadFreeToken);
    on<RunCallbackEvent>(_runCallBack);
  }

  final repository = CallBackRepository();

  void _getTrans(CallbackEvent event, Emitter emit) async {
    List<CallBackDTO> list = [];
    try {
      if (event is GetTransEvent) {
        emit(CallbackLoadingListState());
        list =
            await repository.getTrans(event.bankId, event.customerId ?? '', 0);
        emit(GetListTransSuccessfulState(listTrans: list));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(GetListTransSuccessfulState(listTrans: list));
    }
  }

  void _getTransLoadMore(CallbackEvent event, Emitter emit) async {
    List<CallBackDTO> list = [];

    if (event is GetTransLoadMoreEvent) {
      emit(CallbackLoadingLoadMoreState());
      try {
        bool isLoadMore = false;
        int offset = event.offset;
        offset += 1;

        List<CallBackDTO> data = event.list;

        list = await repository.getTrans(
            event.bankId ?? '', event.customerId ?? '', offset * 20);

        if (list.isEmpty || list.length < 20) {
          isLoadMore = true;
        }
        data.addAll(list);

        emit(
            GetListTransSuccessfulState(listTrans: data, offset: event.offset));
      } catch (e) {
        LOG.error(e.toString());
        emit(GetListTransSuccessfulState(
            listTrans: event.list, offset: event.offset));
      }
    }
  }

  // void _getListCustomer(CallbackEvent event, Emitter emit) async {
  //   try {
  //     if (event is GetListCustomerEvent) {
  //       emit(
  //         state.copyWith(status: BlocStatus.NONE, request: CallBackType.NONE),
  //       );
  //       final result = await repository.getListCustomer();
  //       emit(
  //         state.copyWith(
  //             listCustomers: result,
  //             status: BlocStatus.NONE,
  //             request: CallBackType.CUSTOMERS),
  //       );
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     emit(state.copyWith(
  //       status: BlocStatus.NONE,
  //       request: CallBackType.ERROR,
  //     ));
  //   }
  // }
  //
  void _getListBank(CallbackEvent event, Emitter emit) async {
    List<BankAccountDTO> result = [];
    try {
      if (event is GetListBankEvent) {
        emit(GetListBankLoadingState());
        result = await repository.getListBank(event.customerId);
        emit(GetListBankSuccessfulState(result: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(GetListBankSuccessfulState(result: result));
    }
  }

  //
  void _getInfo(CallbackEvent event, Emitter emit) async {
    ApiServiceDTO apiServiceDTO = const ApiServiceDTO();
    try {
      if (event is GetInfoConnectEvent) {
        emit(CallbackLoadingState());
        if (event.platform == 'API service') {
          apiServiceDTO = await repository.getInfoApiService(event.id);
          emit(GetInfoSuccessfulState(result: apiServiceDTO));
        }
      }
    } catch (e) {
      emit(GetInfoSuccessfulState(result: apiServiceDTO));
    }
  }

  void _loadFreeToken(CallbackEvent event, Emitter emit) async {
    if (event is GetTokenEvent) {
      final result =
          await repository.getToken(event.systemUsername, event.systemPassword);

      if (result) {
        emit(RequestTokenSuccessState());
      } else {
        emit(RequestTokenFailedState());
      }
    }
  }

  //
  void _runCallBack(CallbackEvent event, Emitter emit) async {
    if (event is RunCallbackEvent) {
      final result = await repository.runCallback(event.body);
      await AccountHelper.instance.setTokenFree('');
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(RunCallBackSuccessState(result: result));
      } else {
        emit(RunCallBackFailedState(result: result));
      }
    }
  }
}
