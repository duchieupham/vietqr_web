import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/mixin/base_manager.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/home/event/home_event.dart';
import 'package:VietQR/features/home/repositories/home_repository.dart';
import 'package:VietQR/features/home/states/home_state.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with BaseManager {
  @override
  final BuildContext context;

  HomeBloc(this.context)
      : super(const HomeState(listBanks: [], colors: [], listBankTypeDTO: [])) {
    on<BankCardEventGetList>(_getBankAccounts);
    on<UpdateEvent>(_updateEvent);
    // on<ScanQrEventGetBankType>(_getBankTypeQR);
    on<LoadDataBankEvent>(_getListBankTypes);
    on<BankCardGetDetailEvent>(_getDetail);
  }

  final homeRepository = const HomeRepository();

  // void _getBankTypeQR(HomeEvent event, Emitter emit) async {
  //   try {
  //     if (event is ScanQrEventGetBankType) {
  //       emit(state.copyWith(request: BankType.NONE));
  //       VietQRScannedDTO vietQRScannedDTO =
  //           QRScannerUtils.instance.getBankAccountFromQR(event.code);
  //
  //       if (vietQRScannedDTO.caiValue.isNotEmpty &&
  //           vietQRScannedDTO.bankAccount.isNotEmpty) {
  //         BankTypeDTO dto = await homeRepository
  //             .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
  //         if (dto.id.isNotEmpty) {
  //           emit(
  //             state.copyWith(
  //               request: BankType.SCAN,
  //               typeQR: TypeQR.QR_BANK,
  //               bankTypeDTO: dto,
  //               bankAccount: vietQRScannedDTO.bankAccount,
  //             ),
  //           );
  //         } else {
  //           emit(state.copyWith(request: BankType.SCAN_ERROR));
  //         }
  //       } else {
  //         emit(state.copyWith(request: BankType.SCAN_NOT_FOUND));
  //       }
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     emit(state.copyWith(request: BankType.SCAN_NOT_FOUND));
  //   }
  // }

  Future _getListBankTypes(HomeEvent event, Emitter emit) async {
    // if (banks.isEmpty) {
    //   try {
    //     if (event is LoadDataBankEvent) {
    //       List<BankTypeDTO> list = await homeRepository.getBankTypes();
    //       banks = list;
    //       emit(
    //         state.copyWith(listBankTypeDTO: list, request: BankType.GET_BANK),
    //       );
    //     }
    //   } catch (e) {
    //     LOG.error(e.toString());
    //     emit(state.copyWith(status: BlocStatus.ERROR));
    //   }
    // } else if (state.listBankTypeDTO.isEmpty) {
    //   emit(
    //     state.copyWith(listBankTypeDTO: banks, request: BankType.GET_BANK),
    //   );
    // }
  }

  void _getBankAccounts(HomeEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventGetList) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BankAccountDTO> list =
            await homeRepository.getListBankAccount(userId);
        final List<Color> colors = [];

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

        emit(state.copyWith(
            request: BankType.BANK,
            listBanks: list,
            colors: colors,
            status: BlocStatus.UNLOADING));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: BankType.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _getDetail(HomeEvent event, Emitter emit) async {
    try {
      if (event is BankCardGetDetailEvent) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING,
            request: BankType.NONE,
          ),
        );
        final AccountBankDetailDTO dto =
            await homeRepository.getAccountBankDetail(event.bankId);
        emit(
          state.copyWith(
            bankDetailDTO: dto,
            status: BlocStatus.NONE,
            request: BankType.GET_DETAIL,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: BankType.ERROR));
    }
  }

  void _updateEvent(HomeEvent event, Emitter emit) {}

  final otd = BankAccountDTO();
  final otd2 = BankAccountDTO();
}
