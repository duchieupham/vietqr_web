// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/member_store_dto.dart';
import 'package:VietQR/models/store_detail_dto.dart';
import 'package:VietQR/models/store_model.dart';
import 'package:equatable/equatable.dart';

enum EnterpriseType {
  NONE,
  GET_STORE,
  GET_STORE_DETAIL,
  GET_MEMBERS,
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
  final List<MemberStoreModel> members;

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
    required this.members,
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
      ];
}
