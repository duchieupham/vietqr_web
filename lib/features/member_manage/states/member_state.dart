// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/member/member_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:equatable/equatable.dart';

enum MemberType { NONE, GET_MEMBERS, GET_MERCHANTS, ERROR }

class MemberState extends Equatable {
  final BlocStatus status;
  final MemberType request;
  final String? msg;
  final int offset;
  final List<BankAccountDTO> listBanks;
  final MemberDTO? memberDTO;
  final List<MerchantDTO> merchants;
  final BankAccountDTO? bankDTO;
  final bool isLoadMore;
  final Map<String, List<MemberDTO>> maps;

  // final Map<String, List<MemberDTO>> mapLocals;
  final List<TerminalQRDTO> terminals;
  final bool isCache;
  final List<String> keys;

  const MemberState({
    this.status = BlocStatus.NONE,
    this.request = MemberType.NONE,
    this.msg,
    this.offset = 0,
    this.bankDTO,
    this.isLoadMore = true,
    this.isCache = false,
    this.listBanks = const [],
    this.memberDTO,
    this.merchants = const [],
    this.maps = const {},
    this.terminals = const [],
    this.keys = const [],
  });

  MemberState copyWith({
    BlocStatus? status,
    String? msg,
    MemberType? request,
    List<BankAccountDTO>? listBanks,
    MemberDTO? memberDTO,
    List<MerchantDTO>? merchants,
    BankAccountDTO? bankDTO,
    bool? isLoadMore,
    bool? isCache,
    bool? isEmpty,
    int? offset,
    List<TerminalQRDTO>? terminals,
    Map<String, List<MemberDTO>>? maps,
    Map<String, List<MemberDTO>>? mapLocals,
    List<String>? keys,
  }) {
    return MemberState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      offset: offset ?? this.offset,
      listBanks: listBanks ?? this.listBanks,
      bankDTO: bankDTO ?? this.bankDTO,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      isCache: isCache ?? this.isCache,
      terminals: terminals ?? this.terminals,
      keys: keys ?? this.keys,
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
        listBanks,
        bankDTO,
        isLoadMore,
        terminals,
        isCache,
        keys,
        merchants,
        memberDTO,
      ];
}
