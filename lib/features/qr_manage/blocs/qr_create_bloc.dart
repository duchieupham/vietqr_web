import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/mixin/base_manager.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/qr_manage/event/qr_create_events.dart';
import 'package:VietQR/features/qr_manage/repositories/qr_create_repository.dart';
import 'package:VietQR/features/qr_manage/states/qr_manage_state.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRCreateBloc extends Bloc<QRCreateEvent, QRGenerateState>
    with BaseManager {
  @override
  final BuildContext context;

  QRCreateBloc(this.context) : super(const QRGenerateState()) {
    on<GetListBankAccount>(_getBankList);
    on<GetListBankType>(_getBankType);
    on<GetListTerminalEvent>(_getListMerchant);
    on<QRGenerateEvent>(_generateQR);
    on<UnAuthQRGenerateEvent>(_unAuthQRGenerate);
  }

  final QRGenerateRepository _repository = QRGenerateRepository();

  void _getBankList(QRCreateEvent event, Emitter emit) async {
    try {
      if (event is GetListBankAccount) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        List<BankAccountDTO>? result = await _repository.getListBankAccount();
        if (result.isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: QrGenerate.GET_BANKS,
              listAccountBanks: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.NONE, request: QrGenerate.GET_BANKS));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getListMerchant(QRCreateEvent event, Emitter emit) async {
    try {
      if (event is GetListTerminalEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrGenerate.NONE));

        final result = await _repository.getTerminals(event.bankId!);

        emit(
          state.copyWith(
            request: QrGenerate.GET_MERCHANTS,
            status: BlocStatus.UNLOADING,
            listTerminal: result,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.ERROR,
            msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'),
      );
    }
  }

  void _getBankType(QRCreateEvent event, Emitter emit) async {
    try {
      if (event is GetListBankType) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        List<BankTypeDTO>? result = await _repository.getBankTypes();
        if (result.isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: QrGenerate.GET_BANK_TYPE,
              listBankType: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.NONE, request: QrGenerate.GET_BANK_TYPE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _generateQR(QRCreateEvent event, Emitter emit) async {
    try {
      if (event is QRGenerateEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrGenerate.QR_GENERATE));
        final result = await _repository.generateQR(
            bankId: event.bankId,
            amount: event.amount,
            content: event.content,
            terminalCode: event.terminalCode ?? '',
            orderId: event.orderId ?? '');
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: QrGenerate.QR_GENERATE,
              dto: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: QrGenerate.QR_GENERATE,
              dto: null));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrGenerate.QR_GENERATE));
    }
  }

  void _unAuthQRGenerate(QRCreateEvent event, Emitter emit) async {
    try {
      if (event is UnAuthQRGenerateEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrGenerate.QR_GENERATE));
        final result = await _repository.generateQRUnAuthen(
            bankAccount: event.bankAccount,
            bankCode: event.bankCode,
            userBankName: event.userBankName,
            amount: event.amount ?? '',
            content: event.content ?? '');
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: QrGenerate.UN_AUTH_QR_GENERATE,
              dto: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: QrGenerate.UN_AUTH_QR_GENERATE,
              dto: null));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrGenerate.UN_AUTH_QR_GENERATE));
    }
  }
}
