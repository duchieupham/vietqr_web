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
  TransactionBloc() : super(const TransactionState()) {
    on<GetTransOwnerEvent>(_getTransactions);
    on<FetchTransOwnerEvent>(_fetchTransaction);
    on<GetTransNotOwnerEvent>(_getTransactionsNotOwner);
    on<FetchTransNotOwnerEvent>(_fetchTransactionNotOwner);
    on<GetTransUnsettledEvent>(_getTransactionsUnsettled);
    on<FetchTransUnsettledEvent>(_fetchTransactionUnsettled);
    on<GetTransUnclassifiedEvent>(_getTransUnclassified);
    on<FetchTransUnclassifiedEvent>(_fetchTransUnclassified);
    on<GetListBankEvent>(_getBankAccounts);
    on<GetTerminalsEvent>(_getTerminals);
    on<UpdateBankAccountEvent>(_updateBankAccount);
    on<UpdateTerminalEvent>(_updateTerminal);
    on<UpdateNoteEvent>(_updateNote);
    on<UpdateCacheDataEvent>(_updateCache);
    on<UpdateOffsetEvent>(_updateOffset);
    on<TransApproveEvent>(_transApprove);
    on<TransRequestEvent>(_transRequest);
    on<GetTotalTransEvent>(_getTotalTrans);
  }

  final repository = TransactionRepository();
  final int _limit = 20;

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
          isLoading: false,
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

        TerminalQRDTO value = TerminalQRDTO(terminalName: 'Tất cả cửa hàng');

        list.insert(0, value);

        emit(state.copyWith(
            request: TransType.LIST_TERMINAL,
            terminals: list,
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
          String key = event.timeKey;

          if (state.isCache) {
            map.addAll(state.mapLocals);
          } else {
            map.addAll(state.maps);
            key = '${event.offset}';
          }

          List<TransReceiveDTO> list = [...map[key] ?? []];

          int index = list.indexWhere(
              (element) => element.transactionId == event.transactionId);

          if (index != -1) {
            list[index].terminalCode = event.terminalCode;
            map[key] = list;
          }

          if (state.isCache) {
            emit(state.copyWith(
              request: TransType.UPDATE_TERMINAL,
              status: BlocStatus.UNLOADING,
              mapLocals: map,
              listTrans: list,
            ));
          } else {
            emit(state.copyWith(
              request: TransType.UPDATE_TERMINAL,
              status: BlocStatus.UNLOADING,
              maps: map,
              listTrans: list,
            ));
          }
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
          String key = event.timeKey;

          if (state.isCache) {
            map.addAll(state.mapLocals);
          } else {
            map.addAll(state.maps);
            key = '${event.offset}';
          }

          List<TransReceiveDTO> list = [...map[key] ?? []];

          int index = list
              .indexWhere((element) => element.transactionId == transactionId);

          if (index != -1) {
            list[index].note = note;
            map[key] = list;
          }

          if (state.isCache) {
            emit(state.copyWith(
              request: TransType.UPDATE_NOTE,
              status: BlocStatus.UNLOADING,
              mapLocals: map,
              listTrans: list,
            ));
          } else {
            emit(state.copyWith(
              request: TransType.UPDATE_NOTE,
              status: BlocStatus.UNLOADING,
              maps: map,
              listTrans: list,
            ));
          }
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

  void _updateCache(TransactionEvent event, Emitter emit) async {
    try {
      if (event is UpdateCacheDataEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: TransType.NONE));

        List<TransReceiveDTO> list = state.mapLocals[event.timeKey] ?? [];

        emit(
          state.copyWith(
            request: TransType.UPDATE_CACHE,
            status: BlocStatus.UNLOADING,
            isCache: true,
            isLoadMore: list.length >= 20,
            maps: event.clearData ? {} : state.maps,
            offset: 0,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
    }
  }

  void _updateOffset(TransactionEvent event, Emitter emit) async {
    try {
      if (event is UpdateOffsetEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));

        emit(
          state.copyWith(
            request: TransType.UPDATE_OFFSET,
            status: BlocStatus.NONE,
            offset: event.offset,
            isCache: false,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
    }
  }

  void _transApprove(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransApproveEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));
        TransType type = TransType.NONE;
        final result = await repository.transApprove(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          Map<String, List<TransReceiveDTO>> maps = {};
          maps.addAll(state.maps);

          List<TransReceiveDTO> list = [...maps['${event.offset}'] ?? []];

          /// duyệt thành công
          if (event.dto.status == 1) {
            maps['${event.offset}'] = list
                .where((element) => element.id != event.dto.transactionId)
                .toList();
            type = TransType.APPROVE_TRANS;
          } else {
            int index = list
                .indexWhere((element) => element.id == event.dto.transactionId);
            List<TransRequest> requests = [];
            if (index != -1) requests = [...list[index].requests];
            requests = requests
                .where((element) => element.requestId != event.dto.requestId)
                .toList();
            list[index].requests = [...requests];
            maps['${event.offset}'] = list
                .where((element) => element.id != event.dto.transactionId)
                .toList();
            type = TransType.CLOSE_TRANS;
          }

          emit(
            state.copyWith(
              request: type,
              status: BlocStatus.NONE,
              maps: maps,
            ),
          );
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
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

  void _transRequest(TransactionEvent event, Emitter emit) async {
    try {
      if (event is TransRequestEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));
        TransType type = TransType.NONE;
        final result = await repository.transRequest(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          Map<String, List<TransReceiveDTO>> maps = {};
          maps.addAll(state.maps);

          List<TransReceiveDTO> list = [...maps['${event.offset}'] ?? []];

          /// duyệt thành công

          emit(
            state.copyWith(
              request: type,
              status: BlocStatus.NONE,
              maps: maps,
            ),
          );
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
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
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: TransType.NONE,
            isCache: true));
        bool isLoadMore = true;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = [...state.listTrans];
        List<String> keys = [...state.keys];

        Map<String, List<TransReceiveDTO>> mapsLocal = {};
        mapsLocal.addAll(state.mapLocals);

        if (keys.contains(event.timeKey)) {
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            maps: {},
            status: BlocStatus.UNLOADING,
            isCache: true,
          ));
          return;
        }

        final result = await repository.getTransNotOwner(event.dto);

        if (result.isEmpty || result.length < _limit) {
          isLoadMore = false;
        }

        String key = event.timeKey;

        mapsLocal[key] = result;
        keys.add(key);

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          mapLocals: mapsLocal,
          maps: {},
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          keys: keys,
          isCache: true,
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

  void _getTransactionsUnsettled(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransUnsettledEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: TransType.NONE,
            isCache: true));
        bool isLoadMore = true;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = [...state.listTrans];
        List<String> keys = [...state.keys];

        Map<String, List<TransReceiveDTO>> mapsLocal = {};
        mapsLocal.addAll(state.mapLocals);

        if (keys.contains(event.timeKey)) {
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            maps: {},
            status: BlocStatus.UNLOADING,
            isCache: true,
          ));
          return;
        }

        final result = await repository.getTransUnsettled(event.dto);

        if (result.isEmpty || result.length < _limit) {
          isLoadMore = false;
        }

        String key = event.timeKey;

        mapsLocal[key] = result;
        keys.add(key);

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          mapLocals: mapsLocal,
          maps: {},
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          keys: keys,
          isCache: true,
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

  void _fetchTransactionUnsettled(TransactionEvent event, Emitter emit) async {
    try {
      if (event is FetchTransUnsettledEvent) {
        emit(state.copyWith(
          status: BlocStatus.LOADING,
          request: TransType.NONE,
          isCache: false,
          maps: event.clickSearch ? {} : state.maps,
        ));
        bool isLoadMore = event.loadMore;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = state.maps['$offset'] ?? [];

        if (trans.length >= _limit && trans.isNotEmpty) {
          isLoadMore = true;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        } else if (trans.length < _limit && trans.isNotEmpty) {
          isLoadMore = false;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        }

        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.maps);

        final result = await repository.getTransUnsettled(event.dto);

        if (result.isEmpty || result.length < _limit) {
          isLoadMore = false;
        }

        maps['$offset'] = result;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          maps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          isCache: false,
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

  void _fetchTransactionNotOwner(TransactionEvent event, Emitter emit) async {
    try {
      if (event is FetchTransNotOwnerEvent) {
        emit(state.copyWith(
          status: BlocStatus.LOADING,
          request: TransType.NONE,
          isCache: false,
          maps: event.clickSearch ? {} : state.maps,
        ));
        bool isLoadMore = event.loadMore;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = state.maps['$offset'] ?? [];

        if (trans.length >= _limit && trans.isNotEmpty) {
          isLoadMore = true;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        } else if (trans.length < _limit && trans.isNotEmpty) {
          isLoadMore = false;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        }

        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.maps);

        final result = await repository.getTransNotOwner(event.dto);

        if (result.isEmpty || result.length < _limit) {
          isLoadMore = false;
        }

        maps['$offset'] = result;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          maps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          isCache: false,
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

  void _fetchTransaction(TransactionEvent event, Emitter emit) async {
    try {
      if (event is FetchTransOwnerEvent) {
        emit(state.copyWith(
          status: BlocStatus.LOADING,
          request: TransType.NONE,
          isCache: false,
          maps: event.clickSearch ? {} : state.maps,
        ));
        bool isLoadMore = event.loadMore;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = state.maps['$offset'] ?? [];

        if (trans.length >= _limit && trans.isNotEmpty) {
          isLoadMore = true;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        } else if (trans.length < _limit && trans.isNotEmpty) {
          isLoadMore = false;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        }

        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.maps);

        final result = await repository.getTransactionByBankId(event.dto);

        if (result.isEmpty || result.length < _limit) {
          isLoadMore = false;
        }

        maps['$offset'] = result;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          maps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          isCache: false,
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

  void _getTransactions(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransOwnerEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: TransType.NONE,
            isCache: true));
        bool isLoadMore = true;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = [...state.listTrans];
        List<String> keys = [...state.keys];

        Map<String, List<TransReceiveDTO>> mapsLocal = {};
        mapsLocal.addAll(state.mapLocals);

        if (keys.contains(event.timeKey)) {
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            maps: {},
            status: BlocStatus.UNLOADING,
            isCache: true,
          ));
          return;
        }

        final result = await repository.getTransactionByBankId(event.dto);

        if (result.isEmpty || result.length < _limit) {
          isLoadMore = false;
        }

        String key = event.timeKey;

        mapsLocal[key] = result;
        keys.add(key);

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          mapLocals: mapsLocal,
          maps: {},
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          keys: keys,
          isCache: true,
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
        emit(state.copyWith(
          request: TransType.UPDATE_BANK,
          bankDTO: event.dto,
          status: BlocStatus.NONE,
          mapLocals: {},
          maps: {},
          isLoadMore: true,
          offset: 0,
          isCache: true,
          keys: [],
          listTrans: [],
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: TransType.ERROR,
          msg: 'Có lỗi xảy ra. Vui lòng thử lại sau.'));
    }
  }

  void _getTransUnclassified(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTransUnclassifiedEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: TransType.NONE,
            isCache: true));
        bool isLoadMore = true;
        int offset = event.dto.offset;

        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.maps);

        final result = await repository.getTransUnclassified(event.dto);

        List<TransReceiveDTO> datas = [...result.items];

        if (datas.isEmpty || datas.length < _limit) {
          isLoadMore = false;
        }

        maps['$offset'] = datas;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          maps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          isCache: true,
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

  void _fetchTransUnclassified(TransactionEvent event, Emitter emit) async {
    try {
      if (event is FetchTransUnclassifiedEvent) {
        emit(state.copyWith(
          status: BlocStatus.LOADING,
          request: TransType.NONE,
          isCache: false,
          maps: event.clickSearch ? {} : state.maps,
        ));
        bool isLoadMore = event.loadMore;
        int offset = event.dto.offset;

        List<TransReceiveDTO> trans = state.maps['$offset'] ?? [];

        if (trans.length >= _limit && trans.isNotEmpty) {
          isLoadMore = true;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        } else if (trans.length < _limit && trans.isNotEmpty) {
          isLoadMore = false;
          emit(state.copyWith(
            request: TransType.GET_TRANS_TRUE,
            offset: offset,
            isLoadMore: isLoadMore,
            status: BlocStatus.UNLOADING,
            isCache: false,
          ));
          return;
        }

        Map<String, List<TransReceiveDTO>> maps = {};
        maps.addAll(state.maps);

        final result = await repository.getTransUnclassified(event.dto);

        List<TransReceiveDTO> datas = [...result.items];

        if (datas.isEmpty || datas.length < _limit) {
          isLoadMore = false;
        }

        maps['$offset'] = datas;

        emit(state.copyWith(
          request: TransType.GET_TRANS_TRUE,
          listTrans: trans,
          maps: maps,
          offset: offset,
          isLoadMore: isLoadMore,
          status: BlocStatus.UNLOADING,
          transactionDTO: result,
          isCache: false,
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

  void _getTotalTrans(TransactionEvent event, Emitter emit) async {
    try {
      if (event is GetTotalTransEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: TransType.NONE));

        final result = await repository.getTotalTrans(event.dto);

        emit(state.copyWith(
          request: TransType.GET_TOTAL,
          totalTransDTO: result,
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
