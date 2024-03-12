import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/repositories/transaction_repository.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc()
      : super(const TransactionState(
          listBanks: [],
          listTrans: [],
          listTerminals: [],
          tranMaps: {},
        )) {
    on<GetTransOwnerEvent>(_getTransactions);
    on<GetTransNotOwnerEvent>(_getTransactionsNotOwner);
    on<GetListBankEvent>(_getBankAccounts);
    on<GetTerminalsEvent>(_getTerminals);
    on<UpdateBankAccountEvent>(_updateBankAccount);
    on<GetTransUnsettledEvent>(_getTransactionsUnsettled);
    on<UpdateTerminalEvent>(_updateTerminal);
    on<UpdateNoteEvent>(_updateNote);
  }

  final repository = TransactionRepository();

  void _getBankAccounts(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetListBankEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));
        List<BankAccountDTO> list = await repository.getListBankAccount();
        BankAccountDTO? bankDTO;

        if (list.isNotEmpty) {
          List<BankAccountDTO> listLinked =
              list.where((e) => e.isAuthenticated).toList();
          List<BankAccountDTO> listNotLinked =
              list.where((e) => !e.isAuthenticated).toList();

          list = [...listLinked, ...listNotLinked];
          bankDTO = list.first;
        }

        emit(state.copyWith(
          request: TransType.GET_BANKS,
          listBanks: list,
          bankDTO: bankDTO,
          status: BlocStatus.NONE,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: TransType.ERROR,
          status: BlocStatus.NONE,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _getTerminals(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTerminalsEvent) {
        emit(state.copyWith(status: BlocStatus.NONE));
        List<TerminalQRDTO> list = await repository.getTerminals(event.bankId);

        list = [...list];

        emit(state.copyWith(
            request: TransType.LIST_TERMINAL,
            listTerminals: list,
            status: BlocStatus.NONE));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _updateTerminal(TransactionEvent event, Emitter emit) async {
    try {
      if (event is UpdateTerminalEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: TransType.NONE));
        ResponseMessageDTO result = await repository.updateTerminal(
            event.transactionId, event.terminalCode);

        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          Map<String, List<TransReceiveDTO>> map = {};
          map.addAll(state.tranMaps);

          List<TransReceiveDTO> list = [...map['${event.offset}'] ?? []];

          int index = list.indexWhere(
              (element) => element.transactionId == event.transactionId);

          if (index != -1) {
            list[index].terminalCode = event.terminalCode;
            map['${event.offset}'] = list;
          }

          emit(state.copyWith(
            request: TransType.UPDATE_TERMINAL,
            status: BlocStatus.UNLOADING,
            tranMaps: map,
            listTrans: list,
          ));
        } else {
          emit(state.copyWith(
              request: TransType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
    }
  }

  void _updateNote(TransactionEvent event, Emitter emit) async {
    try {
      if (event is UpdateNoteEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: TransType.NONE));
        String transactionId = event.dto.transactionId;
        String note = event.dto.note;

        ResponseMessageDTO result =
            await repository.updateNote(transactionId, note);

        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          Map<String, List<TransReceiveDTO>> map = {};
          map.addAll(state.tranMaps);

          List<TransReceiveDTO> list = [...map['${event.offset}'] ?? []];

          int index = list
              .indexWhere((element) => element.transactionId == transactionId);

          if (index != -1) {
            list[index].note = note;
            map['${event.offset}'] = list;
          }

          emit(state.copyWith(
            request: TransType.UPDATE_NOTE,
            status: BlocStatus.UNLOADING,
            tranMaps: map,
            listTrans: list,
          ));
        } else {
          emit(state.copyWith(
              request: TransType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
    }
  }

  void _getTransactionsNotOwner(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransNotOwnerEvent) {
        bool isLoadMore = true;
        int offset = event.dto.offset;
        List<TransReceiveDTO> trans = [...state.listTrans];
        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.tranMaps);

        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));
        final List<TransReceiveDTO> result =
            await repository.getTransNotOwner(event.dto);

        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
        }

        if (event.isLoadMore && result.isNotEmpty) {
          trans = [...trans, ...result];
        } else {
          trans = [...result];
        }

        maps['$offset'] = result;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          tranMaps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: TransType.ERROR));
    }
  }

  void _getTransactionsUnsettled(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransUnsettledEvent) {
        bool isLoadMore = true;
        int offset = event.dto.offset;
        List<TransReceiveDTO> trans = [...state.listTrans];
        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.tranMaps);

        emit(state.copyWith(
            status: BlocStatus.LOADING, request: TransType.NONE));
        final List<TransReceiveDTO> result =
            await repository.getTransUnsettled(event.dto);

        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
        }

        if (event.isLoadMore && result.isNotEmpty) {
          trans = [...trans, ...result];
        } else {
          trans = [...result];
        }

        maps['$offset'] = result;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          tranMaps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: TransType.ERROR,
        status: BlocStatus.UNLOADING,
      ));
    }
  }

  void _getTransactions(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransOwnerEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: TransType.NONE));
        bool isLoadMore = true;
        int offset = event.dto.offset;
        List<TransReceiveDTO> trans = [...state.listTrans];
        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.tranMaps);

        final List<TransReceiveDTO> result =
            await repository.getTransactionByBankId(event.dto);

        if (result.isEmpty || result.length < 20) {
          isLoadMore = false;
        }

        if (event.isLoadMore && result.isNotEmpty) {
          trans = [...trans, ...result];
        } else {
          trans = [...result];
        }

        maps['$offset'] = result;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          tranMaps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: TransType.ERROR,
          status: BlocStatus.UNLOADING,
          msg: 'Có lỗi xảy ra. Vui lòng thử lại sau.'));
    }
  }

  void _updateBankAccount(TransactionEvent event, Emitter emit) async {
    try {
      if (event is UpdateBankAccountEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));

        emit(state.copyWith(
          request: TransType.UPDATE_BANK,
          bankDTO: event.dto,
          status: BlocStatus.UNLOADING,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: TransType.ERROR,
          msg: 'Có lỗi xảy ra. Vui lòng thử lại sau.'));
    }
  }
}

//
// void _fetchTransactions(TransactionEvent event, Emitter emit) async {
//   try {
//     if (event is TransactionEventFetch) {
//       emit(TransactionLoadingState());
//       final List<RelatedTransactionReceiveDTO> result =
//           await _transactionRepository.getTransactionByBankId(event.dto);
//       emit(TransactionFetchSuccessState(list: result));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TransactionFetchFailedState());
//   }
// }
//
// void _getDetail(TransactionEvent event, Emitter emit) async {
//   try {
//     if (event is TransactionEventGetDetail) {
//       emit(TransactionDetailLoadingState());
//       TransactionReceiveDTO dto =
//           await _transactionRepository.getTransactionDetail(event.id);
//       emit(TransactionDetailSuccessState(dto: dto));
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(TransactionDetailFailedState());
//   }
//
// }
