import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/fee_package_invoice.dto.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:VietQR/models/invoice_detail_qr_dto.dart';
import 'package:VietQR/models/invoice_excel_dto.dart';
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
  final List<FeePackageInvoiceDTO>? listFeePackageInvoice;
  final InvoiceDetailDTO? invoiceDetailDTO;
  final InvoiceDetailQrDTO? invoiceDetailQrDTO;
  final bool? isShow;
  final bool isOpenDialog;
  final bool hasFile;

  final InvoiceExcelDTO? invoiceExcelDTO;

  const InvoiceStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = InvoiceType.NONE,
    this.listInvoice,
    this.listBank,
    this.metaDataDTO,
    this.listFeePackageInvoice,
    this.invoiceDetailDTO,
    this.invoiceDetailQrDTO,
    this.isShow,
    this.hasFile = false,
    this.invoiceExcelDTO,
    this.isOpenDialog = false,
  });

  InvoiceStates copyWith({
    BlocStatus? status,
    InvoiceType? request,
    String? msg,
    List<InvoiceFeeDTO>? listInvoice,
    List<BankAccountDTO>? listBank,
    List<FeePackageInvoiceDTO>? listFeePackageInvoice,
    MetaDataDTO? metaDataDTO,
    InvoiceDetailDTO? invoiceDetailDTO,
    InvoiceDetailQrDTO? invoiceDetailQrDTO,
    InvoiceExcelDTO? invoiceExcelDTO,
    bool? isShow,
    bool? isOpenDialog,
    bool? hasFile,
  }) {
    return InvoiceStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listInvoice: listInvoice ?? this.listInvoice,
      listBank: listBank ?? this.listBank,
      listFeePackageInvoice:
          listFeePackageInvoice ?? this.listFeePackageInvoice,
      metaDataDTO: metaDataDTO ?? this.metaDataDTO,
      invoiceDetailDTO: invoiceDetailDTO ?? this.invoiceDetailDTO,
      invoiceExcelDTO: invoiceExcelDTO ?? this.invoiceExcelDTO,
      invoiceDetailQrDTO: invoiceDetailQrDTO ?? this.invoiceDetailQrDTO,
      isShow: isShow ?? this.isShow,
      isOpenDialog: isOpenDialog ?? this.isOpenDialog,
      hasFile: hasFile ?? this.hasFile,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        listInvoice,
        listBank,
        listFeePackageInvoice,
        invoiceDetailDTO,
        invoiceDetailQrDTO,
        invoiceExcelDTO,
        isShow,
        isOpenDialog,
        hasFile,
        metaDataDTO,
      ];
}
