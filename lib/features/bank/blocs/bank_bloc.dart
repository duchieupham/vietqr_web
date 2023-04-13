// ignore_for_file: use_build_context_synchronously

import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/repositories/bank_repository.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  BankBloc() : super(BankInitialState()) {
    on<BankEventGetList>(_getBankAccounts);
    on<BankEventGetDetail>(_getDetail);
  }
}

const BankRepository _bankRepository = BankRepository();

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
