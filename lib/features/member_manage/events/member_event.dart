import 'package:VietQR/models/member/member_input_dto.dart';
import 'package:equatable/equatable.dart';

class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object?> get props => [];
}

class GetMerchantsEvent extends MemberEvent {}

class GetMembersEvent extends MemberEvent {
  final MemberInputDTO dto;

  const GetMembersEvent(this.dto);

  @override
  List<Object?> get props => [dto];
}

class FetchMembersEvent extends MemberEvent {
  final MemberInputDTO dto;

  const FetchMembersEvent(this.dto);

  @override
  List<Object?> get props => [dto];
}

class UpdateOffsetEvent extends MemberEvent {
  final int offset;

  const UpdateOffsetEvent(this.offset);

  @override
  List<Object?> get props => [offset];
}
