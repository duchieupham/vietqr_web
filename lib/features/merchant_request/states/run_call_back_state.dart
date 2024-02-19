import 'package:VietQR/models/api_service_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/callback_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:equatable/equatable.dart';

class RunCallBackState extends Equatable {
  const RunCallBackState();

  @override
  List<Object?> get props => [];
}

class CallbackInitialState extends RunCallBackState {}

class CallbackLoadingState extends RunCallBackState {}

class CallbackLoadingListState extends RunCallBackState {}

class CallbackLoadingLoadMoreState extends RunCallBackState {}

class GetListTransSuccessfulState extends RunCallBackState {
  final List<CallBackDTO> listTrans;
  final int offset;
  const GetListTransSuccessfulState({required this.listTrans, this.offset = 0});

  @override
  List<Object?> get props => [listTrans];
}

class GetListBankLoadingState extends RunCallBackState {}

class GetListBankSuccessfulState extends RunCallBackState {
  final List<BankAccountDTO> result;
  const GetListBankSuccessfulState({required this.result});

  @override
  List<Object?> get props => [result];
}

class GetInfoSuccessfulState extends RunCallBackState {
  final ApiServiceDTO result;
  const GetInfoSuccessfulState({required this.result});

  @override
  List<Object?> get props => [result];
}

class RequestTokenSuccessState extends RunCallBackState {}

class RequestTokenFailedState extends RunCallBackState {}

class RunCallBackSuccessState extends RunCallBackState {
  final ResponseMessageDTO result;
  const RunCallBackSuccessState({required this.result});

  @override
  List<Object?> get props => [result];
}

class RunCallBackFailedState extends RunCallBackState {
  final ResponseMessageDTO result;
  const RunCallBackFailedState({required this.result});

  @override
  List<Object?> get props => [result];
}
