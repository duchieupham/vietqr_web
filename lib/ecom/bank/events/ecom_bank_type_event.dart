import 'package:VietQR/models/bank_type_dto.dart';
import 'package:equatable/equatable.dart';

class ECOMBankTypeEvent extends Equatable {
  const ECOMBankTypeEvent();

  @override
  List<Object?> get props => [];
}

class ECOMBankTypeEventGetList extends ECOMBankTypeEvent {
  const ECOMBankTypeEventGetList();

  @override
  List<Object?> get props => [];
}

class ECOMBankTypeEventGetListUnauthenticated extends ECOMBankTypeEvent {
  const ECOMBankTypeEventGetListUnauthenticated();

  @override
  List<Object?> get props => [];
}

class ECOMBankTypeEventSearch extends ECOMBankTypeEvent {
  final String textSearch;
  final List<BankTypeDTO> list;

  const ECOMBankTypeEventSearch({required this.textSearch, required this.list});

  @override
  List<Object?> get props => [textSearch, list];
}
