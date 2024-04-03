import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/create_qr/event/create_qr_event.dart';
import 'package:VietQR/features/create_qr/states/create_qr_state.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../repositories/create_qr_repository.dart';

class CreateQRBloc extends Bloc<CreateQREvent, CreateQRState> {
  CreateQRBloc() : super(CreateQRInitialState()) {
    on<GetListBankAccount>(_getBankAccounts);
    on<BankEventGetDetail>(_getDetail);
    on<QREventGenerate>(_generateQR);
    on<QRCodeUnUTCreateQR>(_createQR);
  }
}

CreateQRRepository createQRRepository = const CreateQRRepository();

void _getBankAccounts(CreateQREvent event, Emitter emit) async {
  String userId = UserInformationHelper.instance.getUserId();
  List<BankAccountDTO> list = [];
  List<Color> colors = [];
  try {
    if (event is GetListBankAccount) {
      list = await createQRRepository.getListBankAccount(userId);

      PaletteGenerator? paletteGenerator;
      BuildContext context = NavigationService.navigatorKey.currentContext!;
      if (list.isNotEmpty) {
        List<BankAccountDTO> listLinked =
            list.where((e) => e.isAuthenticated).toList();
        List<BankAccountDTO> listNotLinked =
            list.where((e) => !e.isAuthenticated).toList();

        list = [...listLinked, ...listNotLinked];

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

      emit(GetListBankAccountSuccessfulState(list: list, colors: colors));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(GetListBankAccountSuccessfulState(list: list, colors: colors));
  }
}

void _getDetail(CreateQREvent event, Emitter emit) async {
  try {
    if (event is BankEventGetDetail) {
      final AccountBankDetailDTO dto =
          await createQRRepository.getAccountBankDetail(event.bankId);
      emit(BankDetailSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankDetailFailedState());
  }
}

void _generateQR(CreateQREvent event, Emitter emit) async {
  try {
    if (event is QREventGenerate) {
      emit(QRGenerateLoadingState());
      final QRGeneratedDTO result =
          await createQRRepository.generateQR(event.dto);
      emit(QRGenerateSuccessState(dto: result));
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _createQR(CreateQREvent event, Emitter emit) async {
  try {
    if (event is QRCodeUnUTCreateQR) {
      emit(QRGenerateUnAuthenLoadingState());
      final QRGeneratedDTO result =
          await createQRRepository.generateQRUnAuthen(event.data);
      emit(CreateUnAuthenSuccessfulState(dto: result));
    }
  } catch (e) {
    emit(QRGenerateFailedState());
    LOG.error(e.toString());
  }
}
