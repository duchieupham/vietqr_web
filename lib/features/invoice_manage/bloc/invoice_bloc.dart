import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/features/invoice_manage/event/invoice_events.dart';
import 'package:VietQR/features/invoice_manage/repository/invoice_repositories.dart';
import 'package:VietQR/features/invoice_manage/state/invoice_states.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:VietQR/models/metadata_dto.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/mixin/base_manager.dart';
import '../../../commons/utils/log.dart';
import '../../../models/invoice_fee_dto.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceStates> with BaseManager {
  @override
  final BuildContext context;

  List<InvoiceFeeDTO> listInvoice = [];

  InvoiceBloc(this.context) : super(const InvoiceStates()) {
    on<InvoiceEvent>(_getListInvoice);
    on<GetInvoiceDetail>(_getDetailInvoice);
    on<GetInvoiceExcel>(_getExcelInvoice);
    on<GetInvoiceList>(_getListInvoice);
    on<GetListBankAccountEvent>(_getBanks);
    on<RequestPaymentInvoiceItemEvent>(_reqPayment);
    on<CloseDialogEvent>(_closeDialog);
    on<GetListPackageInvoiceFeeEvent>(_getListPackageInvoiceFee);
  }
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  void _getBanks(
    InvoiceEvent event,
    Emitter emit,
  ) async {
    try {
      if (event is GetListBankAccountEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: InvoiceType.GET_BANKS));
        final result = await _invoiceRepository.getListBankAccount();
        if (result.isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              listBank: result,
              request: InvoiceType.GET_BANKS));
          // callback(result);
        } else {
          emit(state.copyWith(
              listBank: [],
              request: InvoiceType.GET_BANKS,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          request: InvoiceType.GET_BANKS,
          msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _getListPackageInvoiceFee(
    InvoiceEvent event,
    Emitter emit,
  ) async {
    try {
      if (event is GetListPackageInvoiceFeeEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: InvoiceType.GET_LIST_FEE));
        final result = await _invoiceRepository.getListFeePackageInvoice(
          bankId: event.bankId,
          time: event.time,
        );
        if (result.isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              listFeePackageInvoice: result,
              request: InvoiceType.GET_LIST_FEE));
          // callback(result);
        } else {
          emit(state.copyWith(
              listFeePackageInvoice: [],
              request: InvoiceType.GET_LIST_FEE,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          request: InvoiceType.GET_LIST_FEE,
          msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _reqPayment(
    InvoiceEvent event,
    Emitter emit,
  ) async {
    try {
      if (event is RequestPaymentInvoiceItemEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: InvoiceType.REQUEST_PAYMENT));
        final result = await _invoiceRepository.requestPaymnet(
          invoiceId: event.invoiceId,
          itemItemIds: event.itemItemIds,
        );
        if (result != null) {
          emit(state.copyWith(
              isShow: event.isShowPopup,
              invoiceDetailQrDTO: result,
              status: BlocStatus.SUCCESS,
              request: InvoiceType.REQUEST_PAYMENT));
        } else {
          emit(state.copyWith(
              invoiceDetailQrDTO: null,
              status: BlocStatus.ERROR,
              request: InvoiceType.REQUEST_PAYMENT));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          request: InvoiceType.REQUEST_PAYMENT,
          msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _getDetailInvoice(
    InvoiceEvent event,
    Emitter emit,
  ) async {
    try {
      if (event is GetInvoiceDetail) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(
              status: BlocStatus.LOADING, request: InvoiceType.INVOICE_DETAIL));
        }

        final result =
            await _invoiceRepository.getInvoiceDetail(event.invoiceId);
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              invoiceDetailDTO: result,
              request: InvoiceType.INVOICE_DETAIL,
              isShow: event.isShowPopup));
          // callback(result);
        } else {
          emit(state.copyWith(
              invoiceDetailDTO: null,
              isShow: event.isShowPopup,
              request: InvoiceType.INVOICE_DETAIL,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          request: InvoiceType.INVOICE_DETAIL,
          msg: 'Đã có lỗi xảy ra.'));
      //emiterror
    }
  }

  void _getExcelInvoice(
    InvoiceEvent event,
    Emitter emit,
  ) async {
    try {
      if (event is GetInvoiceExcel) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(
              status: BlocStatus.LOADING, request: InvoiceType.INVOICE_EXCEL));
        }

        final result =
            await _invoiceRepository.getInvoiceExcel(event.invoiceId);
        if (result != null) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            invoiceExcelDTO: result,
            request: InvoiceType.INVOICE_EXCEL,
          ));
        } else {
          emit(state.copyWith(
              invoiceExcelDTO: null,
              request: InvoiceType.INVOICE_EXCEL,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          request: InvoiceType.INVOICE_EXCEL,
          msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _getListInvoice(InvoiceEvent event, Emitter emit) async {
    try {
      if (event is GetInvoiceList) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: InvoiceType.GET_INVOICE_LIST));
        List<InvoiceFeeDTO>? list = await _invoiceRepository.getInvoiceList(
          status: event.status,
          bankId: event.bankId,
          filterBy: event.filterBy,
          time: event.time,
          page: event.page,
          size: event.size,
        );
        MetaDataDTO metaDataDTO = _invoiceRepository.metaDataDTO;
        Future.delayed(const Duration(milliseconds: 500));
        if (list!.isNotEmpty) {
          listInvoice = list;
          emit(state.copyWith(
              metaDataDTO: metaDataDTO,
              listInvoice: list,
              request: InvoiceType.GET_INVOICE_LIST,
              status: BlocStatus.SUCCESS));
        } else {
          emit(state.copyWith(
              listInvoice: [],
              request: InvoiceType.GET_INVOICE_LIST,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _closeDialog(InvoiceEvent event, Emitter emit) async {
    try {
      if (event is CloseDialogEvent) {
        emit(state.copyWith(
          isOpenDialog: true,
          status: BlocStatus.SUCCESS,
          request: InvoiceType.DIALOG,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          request: InvoiceType.DIALOG,
          msg: 'Đã có lỗi xảy ra.'));
    }
  }
}
