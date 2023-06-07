import 'package:VietQR/models/bank_type_dto.dart';
import 'package:equatable/equatable.dart';

class ECOMBankTypeState extends Equatable {
  const ECOMBankTypeState();

  @override
  List<Object?> get props => [];
}

class ECOMBankTypeInitialState extends ECOMBankTypeState {}

class ECOMBankTypeLoadingState extends ECOMBankTypeState {}

class ECOMBankTypeGetListSuccessfulState extends ECOMBankTypeState {
  final List<BankTypeDTO> list;

  const ECOMBankTypeGetListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class ECOMBankTypeGetListFailedState extends ECOMBankTypeState {}

class ECOMBankTypeSearchState extends ECOMBankTypeState {
  final List<BankTypeDTO> list;

  const ECOMBankTypeSearchState({required this.list});

  @override
  List<Object?> get props => [list];
}
