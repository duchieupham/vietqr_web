import 'package:equatable/equatable.dart';

class InvoiceEvent extends Equatable {
  const InvoiceEvent();
  @override
  List<Object?> get props => [];
}

class GetInvoiceList extends InvoiceEvent {
  final int? status;
  final String? bankId;
  final int? filterBy;
  final String? time;
  final int? page;
  final int? size;

  const GetInvoiceList(
      {required this.status,
      required this.bankId,
      required this.filterBy,
      this.time,
      this.page,
      this.size});

  @override
  List<Object?> get props => [status, bankId, filterBy, time, page, size];
}

class GetListPackageInvoiceFeeEvent extends InvoiceEvent {
  final String? bankId;
  final String? time;

  const GetListPackageInvoiceFeeEvent({
    required this.bankId,
    required this.time,
  });

  @override
  List<Object?> get props => [bankId, time];
}

class GetListBankAccountEvent extends InvoiceEvent {}

class RequestMultiInvoicePaymentEvent extends InvoiceEvent {
  final List<String> invoiceIds;

  const RequestMultiInvoicePaymentEvent({required this.invoiceIds});

  @override
  List<Object?> get props => [invoiceIds];
}

class RequestPaymentInvoiceItemEvent extends InvoiceEvent {
  final String invoiceId;
  final List<String> itemItemIds;
  final bool isShowPopup;

  const RequestPaymentInvoiceItemEvent(
    this.invoiceId,
    this.itemItemIds,
    this.isShowPopup,
  );

  @override
  List<Object?> get props => [invoiceId, itemItemIds, isShowPopup];
}

class CloseDialogEvent extends InvoiceEvent {}

class GetAttachFile extends InvoiceEvent {
  final String invoiceId;

  const GetAttachFile(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class GetInvoiceDetail extends InvoiceEvent {
  final String invoiceId;
  final bool isShowPopup;

  const GetInvoiceDetail(
    this.invoiceId,
    this.isShowPopup,
  );

  @override
  List<Object?> get props => [invoiceId, isShowPopup];
}

class GetInvoiceExcel extends InvoiceEvent {
  final String invoiceId;

  const GetInvoiceExcel(
    this.invoiceId,
  );

  @override
  List<Object?> get props => [invoiceId];
}
