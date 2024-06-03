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

class GetListBankAccountEvent extends InvoiceEvent {}

class RequestPaymentInvoiceItemEvent extends InvoiceEvent {
  final String invoiceId;
  final List<String> itemItemIds;
  final String? bankIdRecharge;

  const RequestPaymentInvoiceItemEvent(
    this.invoiceId,
    this.itemItemIds,
    this.bankIdRecharge,
  );

  @override
  List<Object?> get props => [invoiceId, itemItemIds, bankIdRecharge];
}

class GetInvoiceDetail extends InvoiceEvent {
  final String invoiceId;

  const GetInvoiceDetail(
    this.invoiceId,
  );

  @override
  List<Object?> get props => [invoiceId];
}
