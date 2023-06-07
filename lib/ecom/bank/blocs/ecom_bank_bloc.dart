// ignore_for_file: use_build_context_synchronously

import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/check_utils.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/ecom/bank/events/ecom_bank_event.dart';
import 'package:VietQR/ecom/bank/repositories/ecom_bank_repository.dart';
import 'package:VietQR/ecom/bank/states/ecom_bank_state.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/repositories/bank_repository.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_name_information_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class ECOMBankBloc extends Bloc<ECOMBankEvent, ECOMBankState> {
  ECOMBankBloc() : super(ECOMBankInitialState()) {
    on<ECOMBankEventGetList>(_getBankAccounts);
    on<ECOMBankEventGetDetail>(_getDetail);
    on<ECOMBankEventInsertUnauthenticated>(_insertBankUnauthenticated);
    on<ECOMBankCheckExistedEvent>(_checkExistedBank);
    on<ECOMBankEventRequestOTP>(_requestOTP);
    on<ECOMBankEventConfirmOTP>(_confirmOTP);
    on<ECOMBankEventInsert>(_insertBank);
    on<ECOMBankEventSearchName>(_searchBankName);
  }
}

const ECOMBankRepository _bankRepository = ECOMBankRepository();

void _insertBank(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventInsert) {
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.insertBankCard(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        String bankId = '';
        String qr = '';
        if (responseMessageDTO.message.isNotEmpty) {
          if (responseMessageDTO.message.contains('*')) {
            bankId = responseMessageDTO.message.split('*')[0];
            qr = responseMessageDTO.message.split('*')[1];
          }
        }
        emit(
          ECOMBankInsertSuccessfulState(bankId: bankId, qr: qr),
        );
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(ECOMBankInsertFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const ECOMBankInsertFailedState(
        message: 'Không thể thêm tài khoản. Vui lòng kiểm tra lại kết nối.'));
  }
}

void _requestOTP(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventRequestOTP) {
      emit(ECOMBankReuqestOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.requestOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(
          ECOMBankRequestOTPSuccessState(
            dto: event.dto,
            requestId: responseMessageDTO.message,
          ),
        );
      } else {
        emit(ECOMBankRequestOTPFailedState(
            message: ErrorUtils.instance
                .getErrorMessage(responseMessageDTO.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(ECOMBankRequestOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message)));
  }
}

void _confirmOTP(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventConfirmOTP) {
      emit(ECOMBankConfirmOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.confirmOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(ECOMBankConfirmOTPSuccessState());
      } else {
        emit(
          ECOMBankConfirmOTPFailedState(
            message:
                ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          ),
        );
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(
      ECOMBankConfirmOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
      ),
    );
  }
}

void _getBankAccounts(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventGetList) {
      emit(ECOMBankLoadingState());
      final List<BankAccountDTO> list =
          await _bankRepository.getListBankAccount(event.userId);
      final List<Color> colors = [];
      PaletteGenerator? paletteGenerator;
      BuildContext context = NavigationService.navigatorKey.currentContext!;
      if (list.isNotEmpty) {
        for (BankAccountDTO dto in list) {
          NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
          paletteGenerator = await PaletteGenerator.fromImageProvider(image);
          if (paletteGenerator.dominantColor != null) {
            colors.add(paletteGenerator.dominantColor!.color);
          } else {
            colors.add(Theme.of(context).cardColor);
          }
        }
      }
      emit(ECOMBankGetListSuccessState(list: list, colors: colors));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const ECOMBankGetListFailedState(
        message: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
  }
}

void _getDetail(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventGetDetail) {
      final AccountBankDetailDTO dto =
          await _bankRepository.getAccountBankDetail(event.bankId);
      emit(ECOMBankDetailSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(ECOMBankDetailFailedState());
  }
}

void _insertBankUnauthenticated(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventInsertUnauthenticated) {
      emit(ECOMBankLoadingInsertState());
      final ResponseMessageDTO result =
          await _bankRepository.insertBankUnauthenticated(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        String bankId = '';
        String qr = '';
        if (result.message.isNotEmpty) {
          if (result.message.contains('*')) {
            bankId = result.message.split('*')[0];
            qr = result.message.split('*')[1];
          }
        }
        emit(
          ECOMBankInsertUnauthenticatedSuccessState(
            bankId: bankId,
            qr: qr,
          ),
        );
      } else {
        emit(ECOMBankInsertUnauthenticatedFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO dto =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(ECOMBankInsertUnauthenticatedFailedState(
        msg: ErrorUtils.instance.getErrorMessage(dto.message)));
  }
}

void _checkExistedBank(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankCheckExistedEvent) {
      emit(ECOMBankLoadingInsertState());
      final ResponseMessageDTO result = await _bankRepository.checkExistedBank(
          event.bankAccount, event.bankTypeId);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(ECOMBankCheckNotExistedState(
            isAuthenticated: event.isAuthenticated));
      } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
        emit(ECOMBankCheckExistedState(
            msg: CheckUtils.instance.getCheckMessage(result.message)));
      } else {
        emit(ECOMBankCheckFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(ECOMBankCheckFailedState());
  }
}

void _searchBankName(ECOMBankEvent event, Emitter emit) async {
  try {
    if (event is ECOMBankEventSearchName) {
      emit(ECOMBankSearchingNameState());
      BankNameInformationDTO dto =
          await _bankRepository.searchBankName(event.dto);
      if (dto.accountName.trim().isNotEmpty) {
        emit(ECOMBankSearchNameSuccessState(dto: dto));
      } else {
        emit(ECOMBankSearchNameFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(ECOMBankSearchNameFailedState());
  }
}
