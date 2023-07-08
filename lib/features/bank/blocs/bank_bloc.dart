// ignore_for_file: use_build_context_synchronously

import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/check_utils.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/repositories/bank_repository.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_name_information_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  BankBloc() : super(BankInitialState()) {
    on<BankEventGetList>(_getBankAccounts);
    on<BankEventGetDetail>(_getDetail);
    on<BankEventInsertUnauthenticated>(_insertBankUnauthenticated);
    on<BankCheckExistedEvent>(_checkExistedBank);
    on<BankEventRequestOTP>(_requestOTP);
    on<BankEventConfirmOTP>(_confirmOTP);
    on<BankEventInsert>(_insertBank);
    on<BankEventSearchName>(_searchBankName);
    on<BankEventRegisterAuthentication>(_registerAuthentication);
    on<BankEventRemove>(_removeBankAccount);
    on<BankEventUnlink>(_unlinkAccountBank);
    on<BankEventConfirmUnlinkOTP>(_confirmUnlinkOTP);
  }
}

const BankRepository _bankRepository = BankRepository();

void _insertBank(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventInsert) {
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
          BankInsertSuccessfulState(bankId: bankId, qr: qr),
        );
        Session.instance.sendEvent(EventTypes.refreshListAccountBank);
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(BankInsertFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankInsertFailedState(
        message: 'Không thể thêm tài khoản. Vui lòng kiểm tra lại kết nối.'));
  }
}

void _requestOTP(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventRequestOTP) {
      emit(BankReuqestOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.requestOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(
          BankRequestOTPSuccessState(
            dto: event.dto,
            requestId: responseMessageDTO.message,
          ),
        );
      } else {
        emit(BankRequestOTPFailedState(
            message: ErrorUtils.instance
                .getErrorMessage(responseMessageDTO.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(BankRequestOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message)));
  }
}

void _confirmOTP(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventConfirmOTP) {
      emit(BankConfirmOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.confirmOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankConfirmOTPSuccessState());
      } else {
        emit(
          BankConfirmOTPFailedState(
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
      BankConfirmOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
      ),
    );
  }
}

void _confirmUnlinkOTP(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventConfirmUnlinkOTP) {
      emit(BankConfirmOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.confirmUnlinkOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankConfirmOTPSuccessState());
      } else {
        emit(
          BankConfirmOTPFailedState(
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
      BankConfirmOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
      ),
    );
  }
}

void _getBankAccounts(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventGetList) {
      emit(BankLoadingState());
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
      emit(BankGetListSuccessState(list: list, colors: colors));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankGetListFailedState(
        message: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
  }
}

void _getDetail(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventGetDetail) {
      final AccountBankDetailDTO dto =
          await _bankRepository.getAccountBankDetail(event.bankId);
      emit(BankDetailSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankDetailFailedState());
  }
}

void _insertBankUnauthenticated(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventInsertUnauthenticated) {
      emit(BankLoadingState());
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
          BankInsertUnauthenticatedSuccessState(
            bankId: bankId,
            qr: qr,
          ),
        );
      } else {
        emit(BankInsertUnauthenticatedFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO dto =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(BankInsertUnauthenticatedFailedState(
        msg: ErrorUtils.instance.getErrorMessage(dto.message)));
  }
}

void _checkExistedBank(BankEvent event, Emitter emit) async {
  try {
    if (event is BankCheckExistedEvent) {
      emit(BankLoadingState());
      final ResponseMessageDTO result = await _bankRepository.checkExistedBank(
          event.bankAccount, event.bankTypeId);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCheckNotExistedState(isAuthenticated: event.isAuthenticated));
      } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
        emit(BankCheckExistedState(
            msg: CheckUtils.instance.getCheckMessage(result.message)));
      } else {
        emit(BankCheckFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankCheckFailedState());
  }
}

void _searchBankName(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventSearchName) {
      emit(BankSearchingNameState());
      BankNameInformationDTO dto =
          await _bankRepository.searchBankName(event.dto);
      if (dto.accountName.trim().isNotEmpty) {
        emit(BankSearchNameSuccessState(dto: dto));
      } else {
        emit(const BankSearchNameFailedState(msg: 'Không tìm thấy tên chủ TK'));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankSearchNameFailedState(msg: 'Không tìm thấy tên chủ TK'));
  }
}

void _registerAuthentication(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventRegisterAuthentication) {
      emit(BankLoadingState());
      final ResponseMessageDTO result =
          await _bankRepository.updateRegisterAuthenticationBank(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankUpdateAuthenticateSuccessState());
        Session.instance.sendEvent(EventTypes.refreshListAccountBank);
      } else {
        emit(BankUpdateAuthenticateFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _removeBankAccount(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventRemove) {
      emit(BankRemoveLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await _bankRepository.removeBankAccount(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankRemoveSuccessState());
      } else if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_CHECK) {
        String message =
            CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
        emit(BankRemoveFailedState(message: message));
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(BankRemoveFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankRemoveFailedState(
        message: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối'));
  }
}

void _unlinkAccountBank(BankEvent event, Emitter emit) async {
  try {
    if (event is BankEventUnlink) {
      emit(BankUnlinkLoadingState());
      final ResponseMessageDTO result =
          await _bankRepository.unLinkBank(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankUnlinkSuccessState(requestId: result.message, dto: event.dto));
      } else {
        emit(BankUnlinkFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}
