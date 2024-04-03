// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/member/member_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:equatable/equatable.dart';

enum MemberType { NONE, GET_MEMBERS, GET_MERCHANTS, UPDATE_OFFSET, ERROR }

class MemberState extends Equatable {
  final BlocStatus status;
  final MemberType request;
  final String? msg;
  final int offset;
  final bool isLoadMore;
  final MemberDTO? memberDTO;
  final List<MerchantDTO> merchants;
  final Map<String, List<Member>> maps;

  const MemberState({
    this.status = BlocStatus.NONE,
    this.request = MemberType.NONE,
    this.msg,
    this.offset = 1,
    this.isLoadMore = true,
    this.memberDTO,
    this.merchants = const [],
    this.maps = const {},
  });

  MemberState copyWith({
    BlocStatus? status,
    String? msg,
    MemberType? request,
    MemberDTO? memberDTO,
    List<MerchantDTO>? merchants,
    bool? isLoadMore,
    bool? isEmpty,
    int? offset,
    List<TerminalQRDTO>? terminals,
    Map<String, List<Member>>? maps,
  }) {
    return MemberState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      offset: offset ?? this.offset,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      memberDTO: memberDTO ?? this.memberDTO,
      maps: maps ?? this.maps,
      merchants: merchants ?? this.merchants,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        offset,
        isLoadMore,
        merchants,
        memberDTO,
      ];
}
