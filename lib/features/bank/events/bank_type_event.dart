import 'package:VietQR/models/bank_type_dto.dart';
import 'package:equatable/equatable.dart';

class BankTypeEvent extends Equatable {
  const BankTypeEvent();

  @override
  List<Object?> get props => [];
}

class BankTypeEventGetList extends BankTypeEvent {
  const BankTypeEventGetList();

  @override
  List<Object?> get props => [];
}

class BankTypeEventGetListUnauthenticated extends BankTypeEvent {
  const BankTypeEventGetListUnauthenticated();

  @override
  List<Object?> get props => [];
}

class BankTypeEventSearch extends BankTypeEvent {
  final String textSearch;
  final List<BankTypeDTO> list;

  const BankTypeEventSearch({required this.textSearch, required this.list});

  @override
  List<Object?> get props => [textSearch, list];
}
