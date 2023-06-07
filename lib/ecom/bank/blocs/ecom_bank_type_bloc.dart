import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/ecom/bank/events/ecom_bank_type_event.dart';
import 'package:VietQR/ecom/bank/repositories/ecom_bank_type_repository.dart';
import 'package:VietQR/ecom/bank/states/ecom_bank_type_state.dart';
import 'package:VietQR/features/bank/events/bank_type_event.dart';
import 'package:VietQR/features/bank/repositories/bank_type_repository.dart';
import 'package:VietQR/features/bank/states/bank_type_state.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ECOMBankTypeBloc extends Bloc<ECOMBankTypeEvent, ECOMBankTypeState> {
  ECOMBankTypeBloc() : super(ECOMBankTypeInitialState()) {
    on<ECOMBankTypeEventGetList>(_getBankTypes);
    on<ECOMBankTypeEventGetListUnauthenticated>(_getBankTypes);
    on<ECOMBankTypeEventSearch>(_searchBankTypes);
  }
}

const ECOMBankTypeRepository bankTypeRepository = ECOMBankTypeRepository();

void _getBankTypes(ECOMBankTypeEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankTypeEventGetList) {
      emit(ECOMBankTypeLoadingState());
      List<BankTypeDTO> list = await bankTypeRepository.getBankTypes();
      emit(ECOMBankTypeGetListSuccessfulState(list: list));
    }
    if (event is ECOMBankTypeEventGetListUnauthenticated) {
      emit(ECOMBankTypeLoadingState());
      List<BankTypeDTO> list =
          await bankTypeRepository.getBankTypesUnauthenticated();
      emit(ECOMBankTypeGetListSuccessfulState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(ECOMBankTypeGetListFailedState());
  }
}

void _searchBankTypes(ECOMBankTypeEvent event, Emitter emit) {
  try {
    if (event is ECOMBankTypeEventSearch) {
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
      emit(ECOMBankTypeSearchState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(ECOMBankTypeGetListFailedState());
  }
}
