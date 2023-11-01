import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/features/add_bank/events/list_bank_event.dart';
import 'package:VietQR/features/add_bank/states/list_bank_state.dart';
import 'package:VietQR/features/bank/repositories/bank_type_repository.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBankBloc extends Bloc<ListBankEvent, ListBankState> {
  ListBankBloc() : super(BankTypeInitialState()) {
    on<BankTypeEventGetList>(_getBankTypes);
    on<BankTypeEventGetListUnauthenticated>(_getBankTypes);
    on<BankTypeEventSearch>(_searchBankTypes);
  }
}

const BankTypeRepository bankTypeRepository = BankTypeRepository();

void _getBankTypes(ListBankEvent event, Emitter emit) async {
  try {
    if (event is BankTypeEventGetList) {
      emit(BankTypeLoadingState());
      List<BankTypeDTO> list = await bankTypeRepository.getBankTypes();
      emit(BankTypeGetListSuccessfulState(list: list));
    }
    if (event is BankTypeEventGetListUnauthenticated) {
      emit(BankTypeLoadingState());
      List<BankTypeDTO> list =
          await bankTypeRepository.getBankTypesUnauthenticated();
      emit(BankTypeGetListSuccessfulState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankTypeGetListFailedState());
  }
}

void _searchBankTypes(ListBankEvent event, Emitter emit) {
  try {
    if (event is BankTypeEventSearch) {
      // emit(BankTypeLoadingState());
      List<BankTypeDTO> result = [];
      if (event.textSearch.trim().isNotEmpty) {
        String textSearchRemoveDiacritic = StringUtils.instance
            .removeDiacritic(event.textSearch.trim().toUpperCase());
        result.addAll(event.list
            .where((dto) =>
                StringUtils.instance
                    .removeDiacritic(dto.bankCode.toUpperCase())
                    .contains(textSearchRemoveDiacritic) ||
                StringUtils.instance
                    .removeDiacritic(dto.bankName.toUpperCase())
                    .contains(textSearchRemoveDiacritic) ||
                StringUtils.instance
                    .removeDiacritic(dto.bankShortName.toUpperCase())
                    .contains(textSearchRemoveDiacritic))
            .toList());
      } else {
        result = event.list;
      }
      emit(BankTypeSearchState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankTypeGetListFailedState());
  }
}
