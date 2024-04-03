import 'package:VietQR/models/bank_type_dto.dart';
import 'package:equatable/equatable.dart';

class ListBankEvent extends Equatable {
  const ListBankEvent();

  @override
  List<Object?> get props => [];
}

class BankTypeEventGetList extends ListBankEvent {
  const BankTypeEventGetList();

  @override
  List<Object?> get props => [];
}

class BankTypeEventGetListUnauthenticated extends ListBankEvent {
  const BankTypeEventGetListUnauthenticated();

  @override
  List<Object?> get props => [];
}

class BankTypeEventSearch extends ListBankEvent {
  final String textSearch;
  final List<BankTypeDTO> list;

  const BankTypeEventSearch({required this.textSearch, required this.list});

  @override
  List<Object?> get props => [textSearch, list];
}
