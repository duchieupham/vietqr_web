import 'package:VietQR/models/contact_dto.dart';
import 'package:equatable/equatable.dart';

import '../../../models/contact_detail_dto.dart';

class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class WalletInitialState extends ContactState {}

class WalletLoadingState extends ContactState {}

class WalletLoadingListState extends ContactState {}

class GetListContactSuccessfulState extends ContactState {
  final List<List<ContactDTO>> list;

  const GetListContactSuccessfulState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class GetDetailContactLoadingState extends ContactState {}

class GetDetailContactSuccessState extends ContactState {
  final ContactDetailDTO dto;

  const GetDetailContactSuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}
