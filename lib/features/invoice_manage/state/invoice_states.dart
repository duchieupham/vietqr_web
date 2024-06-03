import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:equatable/equatable.dart';
import '../../../models/bank_account_dto.dart';
import '../../../models/invoice_fee_dto.dart';
import '../../../models/metadata_dto.dart';

class InvoiceStates extends Equatable {
  final String? msg;
  final List<InvoiceFeeDTO>? listInvoice;
  final InvoiceType? request;
  final BlocStatus status;
  final MetaDataDTO? metaDataDTO;
  final List<BankAccountDTO>? listBank;
  final InvoiceDetailDTO? invoiceDetailDTO;

  const InvoiceStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = InvoiceType.NONE,
    this.listInvoice,
    this.listBank,
    this.metaDataDTO,
    this.invoiceDetailDTO,
  });

  InvoiceStates copyWith({
    BlocStatus? status,
    InvoiceType? request,
    String? msg,
    List<InvoiceFeeDTO>? listInvoice,
    List<BankAccountDTO>? listBank,
    MetaDataDTO? metaDataDTO,
    InvoiceDetailDTO? invoiceDetailDTO,
  }) {
    return InvoiceStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listInvoice: listInvoice ?? this.listInvoice,
      listBank: listBank ?? this.listBank,
      metaDataDTO: metaDataDTO ?? this.metaDataDTO,
      invoiceDetailDTO: invoiceDetailDTO ?? this.invoiceDetailDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        listInvoice,
        listBank,
        metaDataDTO,
      ];
}
