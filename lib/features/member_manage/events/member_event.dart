import 'package:VietQR/models/member/member_input_dto.dart';
import 'package:equatable/equatable.dart';

class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object?> get props => [];
}

class GetMembersEvent extends MemberEvent {
  final MemberInputDTO dto;

  const GetMembersEvent(this.dto);

  @override
  List<Object?> get props => [dto];
}

class GetMerchantsEvent extends MemberEvent {}
