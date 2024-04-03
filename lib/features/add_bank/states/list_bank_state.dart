import 'package:VietQR/models/bank_type_dto.dart';
import 'package:equatable/equatable.dart';

class ListBankState extends Equatable {
  const ListBankState();

  @override
  List<Object?> get props => [];
}

class BankTypeInitialState extends ListBankState {}

class BankTypeLoadingState extends ListBankState {}

class BankTypeGetListSuccessfulState extends ListBankState {
  final List<BankTypeDTO> list;

  const BankTypeGetListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class BankTypeGetListFailedState extends ListBankState {}

class BankTypeSearchState extends ListBankState {
  final List<BankTypeDTO> list;

  const BankTypeSearchState({required this.list});

  @override
  List<Object?> get props => [list];
}
