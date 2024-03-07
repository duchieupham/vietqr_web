import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/enterprise/enterprise.dart';
import 'package:VietQR/features/enterprise/responsitory/enterprise_repository.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/member_store_dto.dart';
import 'package:VietQR/models/store_detail_dto.dart';
import 'package:VietQR/models/store_model.dart';
import 'package:VietQR/models/transaction_store_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterpriseBloc extends Bloc<EnterpriseEvent, EnterpriseState> {
  EnterpriseBloc()
      : super(EnterpriseState(
          storeModel: StoreModel(),
          storeDetailModel: StoreDetailDTO(bank: BankAccountDTO()),
          storeMaps: const {},
          membersMap: const {},
          transactionsMap: const {},
          members: const [],
          transactions: const [],
        )) {
    on<GetStoreEvent>(_getStore);
    on<GetStoreDetailEvent>(_getStoreDetail);
    on<GetMemberStoreEvent>(_getMemberStore);
    on<GetTransStoreEvent>(_getTransStore);
  }

  String get userId => UserInformationHelper.instance.getUserId();
  final createQRRepository = const EnterpriseRepository();
  int limit = 20;

  void _getStore(EnterpriseEvent event, Emitter emit) async {
    try {
      if (event is GetStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: EnterpriseType.NONE));

        bool isLoadMore = true;
        int offset = event.offset;
        List<Terminal> terminals = [...state.storeModel.terminals];
        Map<String, List<Terminal>> maps = {};
        maps.addAll(state.storeMaps);

        StoreModel model = await createQRRepository.getStore(
            userId, offset * limit, event.merchantId, event.keySearch);

        if (model.terminals.isEmpty || model.terminals.length < limit) {
          isLoadMore = false;
        }

        if (event.loadMore && model.terminals.isNotEmpty) {
          terminals = [...terminals, ...model.terminals];
        } else {
          terminals = [...model.terminals];
        }

        maps['$offset'] = model.terminals;

        model.terminals = terminals;

        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: EnterpriseType.GET_STORE,
            storeModel: model,
            isLoadMore: isLoadMore,
            isEmpty: terminals.isEmpty,
            offset: offset,
            storeMaps: maps,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _getMemberStore(EnterpriseEvent event, Emitter emit) async {
    try {
      if (event is GetMemberStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: EnterpriseType.NONE));

        bool isLoadMore = true;
        int offset = event.offset;
        List<MemberStoreModel> members = [...state.members];
        Map<String, List<MemberStoreModel>> maps = {};
        maps.addAll(state.membersMap);

        List<MemberStoreModel> result = await createQRRepository.getMemberStore(
            userId,
            event.offset * limit,
            event.terminalId,
            event.keySearch,
            event.type);

        if (result.isEmpty || result.length < limit) {
          isLoadMore = false;
        }

        if (event.loadMore && result.isNotEmpty) {
          members = [...members, ...result];
        } else {
          members = [...result];
        }

        maps['$offset'] = result;

        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: EnterpriseType.GET_MEMBERS,
            members: result,
            membersMap: maps,
            offset: offset,
            isEmpty: result.isEmpty,
            isLoadMore: isLoadMore,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _getTransStore(EnterpriseEvent event, Emitter emit) async {
    try {
      if (event is GetTransStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: EnterpriseType.NONE));

        bool isLoadMore = true;
        int offset = event.offset;
        List<TransactionStoreDTO> trans = [...state.transactions];
        Map<String, List<TransactionStoreDTO>> maps = {};
        maps.addAll(state.transactionsMap);

        List<TransactionStoreDTO> result =
            await createQRRepository.getTransStore(
                event.terminalId,
                event.type,
                event.keySearch,
                event.offset * limit,
                event.fromDate,
                event.toDate,
                userId);

        if (result.isEmpty || result.length < limit) {
          isLoadMore = false;
        }

        if (event.loadMore && result.isNotEmpty) {
          trans = [...trans, ...result];
        } else {
          trans = [...result];
        }

        maps['$offset'] = result;

        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: EnterpriseType.GET_TRANS,
            transactions: trans,
            transactionsMap: maps,
            offset: offset,
            isEmpty: result.isEmpty,
            isLoadMore: isLoadMore,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _getStoreDetail(EnterpriseEvent event, Emitter emit) async {
    try {
      if (event is GetStoreDetailEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: EnterpriseType.NONE));

        StoreDetailDTO model =
            await createQRRepository.getStoreDetail(event.terminalId, userId);

        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: EnterpriseType.GET_STORE_DETAIL,
            storeDetailModel: model,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
