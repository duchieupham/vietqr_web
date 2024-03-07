// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/member_store_dto.dart';
import 'package:VietQR/models/store_detail_dto.dart';
import 'package:VietQR/models/store_model.dart';
import 'package:VietQR/models/transaction_store_dto.dart';
import 'package:equatable/equatable.dart';

enum EnterpriseType {
  NONE,
  GET_STORE,
  GET_STORE_DETAIL,
  GET_MEMBERS,
  GET_TRANS,
}

enum EnterpriseMenuType { OVERVIEW, STORE }

class EnterpriseState extends Equatable {
  final BlocStatus status;
  final EnterpriseType request;
  final String msg;
  final StoreModel storeModel;
  final StoreDetailDTO storeDetailModel;
  final bool isLoadMore;
  final bool isEmpty;
  final int offset;
  final Map<String, List<Terminal>> storeMaps;
  final Map<String, List<MemberStoreModel>> membersMap;
  final Map<String, List<TransactionStoreDTO>> transactionsMap;
  final List<MemberStoreModel> members;
  final List<TransactionStoreDTO> transactions;

  const EnterpriseState({
    this.status = BlocStatus.NONE,
    this.request = EnterpriseType.NONE,
    this.msg = '',
    required this.storeModel,
    required this.storeDetailModel,
    this.isLoadMore = false,
    this.isEmpty = false,
    this.offset = 0,
    required this.storeMaps,
    required this.membersMap,
    required this.transactionsMap,
    required this.members,
    required this.transactions,
  });

  EnterpriseState copyWith({
    BlocStatus? status,
    String? msg,
    StoreModel? storeModel,
    StoreDetailDTO? storeDetailModel,
    EnterpriseType? request,
    bool? isLoadMore,
    bool? isEmpty,
    int? offset,
    Map<String, List<Terminal>>? storeMaps,
    Map<String, List<MemberStoreModel>>? membersMap,
    List<MemberStoreModel>? members,
    Map<String, List<TransactionStoreDTO>>? transactionsMap,
    List<TransactionStoreDTO>? transactions,
  }) {
    return EnterpriseState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      storeModel: storeModel ?? this.storeModel,
      request: request ?? this.request,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      isEmpty: isEmpty ?? this.isEmpty,
      offset: offset ?? this.offset,
      storeMaps: storeMaps ?? this.storeMaps,
      storeDetailModel: storeDetailModel ?? this.storeDetailModel,
      membersMap: membersMap ?? this.membersMap,
      members: members ?? this.members,
      transactionsMap: transactionsMap ?? this.transactionsMap,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        storeModel,
        isLoadMore,
        isEmpty,
        offset,
        storeMaps,
        storeDetailModel,
        membersMap,
        members,
        transactions,
        transactionsMap,
      ];
}
