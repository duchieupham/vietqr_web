import 'package:VietQR/models/account_bank_branch_insert_dto.dart';
import 'package:VietQR/models/branch_filter_insert_dto.dart';
import 'package:VietQR/models/branch_member_delete_dto.dart';
import 'package:VietQR/models/branch_member_insert_dto.dart';
import 'package:equatable/equatable.dart';

class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object?> get props => [];
}

class BranchEventGetChoice extends BranchEvent {
  final String userId;

  const BranchEventGetChoice({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BranchEventGetFilter extends BranchEvent {
  final BranchFilterInsertDTO dto;

  const BranchEventGetFilter({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

//

class BranchEventGetDetail extends BranchEvent {
  const BranchEventGetDetail();
}

class BranchEventGetBanks extends BranchEvent {
  const BranchEventGetBanks();
}

class BranchEventGetMembers extends BranchEvent {
  final bool? isLoading;

  const BranchEventGetMembers({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class BranchEventSearchMember extends BranchEvent {
  final String phoneNo;
  final String businessId;

  const BranchEventSearchMember({
    required this.phoneNo,
    required this.businessId,
  });

  @override
  List<Object?> get props => [phoneNo, businessId];
}

class BranchEventInsertMember extends BranchEvent {
  final BranchMemberInsertDTO dto;

  const BranchEventInsertMember({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BranchEventInitial extends BranchEvent {}

class BranchEventRemove extends BranchEvent {
  final BranchMemberDeleteDTO dto;
  final int index;

  const BranchEventRemove({required this.dto, required this.index});

  @override
  List<Object?> get props => [dto, index];
}

class BranchEventGetConnectBanks extends BranchEvent {
  final String userId;

  const BranchEventGetConnectBanks({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BranchEventConnectBank extends BranchEvent {
  final AccountBankBranchInsertDTO dto;

  const BranchEventConnectBank({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BranchEventRemoveBank extends BranchEvent {
  final AccountBankBranchInsertDTO dto;

  const BranchEventRemoveBank({required this.dto});

  @override
  List<Object?> get props => [dto];
}
