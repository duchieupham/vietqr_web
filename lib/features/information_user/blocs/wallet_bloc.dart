import 'package:VietQR/features/information_user/events/wallet_event.dart';
import 'package:VietQR/features/information_user/repositories/wallet_repository.dart';
import 'package:VietQR/features/information_user/states/wallet_state.dart';
import 'package:VietQR/models/wallet_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitialState()) {
    on<WalletGetInfoEvent>(_getInfoWallet);
  }

  final WalletRepository walletRepository = const WalletRepository();

  void _getInfoWallet(WalletEvent event, Emitter emit) async {
    String userId = UserInformationHelper.instance.getUserId();
    try {
      if (event is WalletGetInfoEvent) {
        emit(WalletLoadingState());
        final WalletDTO dto = await walletRepository.getInfoWallet(userId);
        if (dto.walletId.isNotEmpty) {
          emit(WalletSuccessfulState(walletDTO: dto));
        } else {
          String msg = 'Lỗi hệ thống';
          emit(WalletFailedState(msg: msg));
        }
      }
    } catch (e) {
      debugPrint('Error at _updateUserInformation - UserEditBloc: $e');
      emit(const WalletFailedState(msg: 'Vui lòng thử lại sau'));
    }
  }
}
