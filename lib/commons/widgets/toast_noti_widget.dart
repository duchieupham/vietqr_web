import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/features/invoice_manage/bloc/invoice_bloc.dart';
import 'package:VietQR/features/invoice_manage/event/invoice_events.dart';
import 'package:VietQR/models/notify_trans_dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToastNotiWidget extends StatefulWidget {
  final dynamic data;
  const ToastNotiWidget({super.key, required this.data});

  @override
  State<ToastNotiWidget> createState() => _ToastNotiWidgetState();
}

class _ToastNotiWidgetState extends State<ToastNotiWidget> {
  // late InvoiceBloc _bloc;
  // GoRouter? _router;

  @override
  void initState() {
    super.initState();
    // _provider = Provider.of<InvoiceProvider>(context, listen: false);
    // _provider.isCloseDialog(true);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   closeDialog();
    // });

    // _bloc = BlocProvider.of(context);
    // _router = GoRouter.of(context);
  }

  // bool isOpenDialog() {
  //   return widget.sharedPrefs.getBool('IS_DIALOG_OPEN') ?? false;
  // }

  // void closeDialog(BuildContext context) async {
  //   if (widget.data['notificationType'] == Stringify.NOTI_INVOICE_SUCCESS) {
  //     Provider.of<InvoiceProvider>(context, listen: false).isCloseDialog(true);
  //     // context.read<InvoiceBloc>().add(CloseDialogEvent());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String icLogo = '';
    String actionText = '';
    Color color = AppColor.WHITE;
    if (widget.data['notificationType'] == Stringify.NOTI_INVOICE_SUCCESS ||
        widget.data['notificationType'] == Stringify.NOTI_INVOICE_CREATE) {
      Provider.of<InvoiceProvider>(context, listen: false).isCloseDialog();
      Provider.of<InvoiceProvider>(context, listen: false).makeReload(true);
      // context.read<InvoiceBloc>().add(CloseDialogEvent());
    }
    switch (widget.data['notificationType']) {
      case Stringify.NOTI_TYPE_UPDATE_TRANSACTION:
        if (widget.data['transType'] == 'D') {
          icLogo = 'assets/images/ic-debit-noti.png';
          actionText = 'Danh sách giao dịch';
          color = AppColor.RED_TEXT;
        } else {
          if (widget.data['type'] == 2) {
            icLogo = 'assets/images/ic-other-noti.png';
            actionText = 'Cập nhật cửa hàng';
            color = AppColor.BLUE_CARD;
          } else {
            icLogo = 'assets/images/ic-success-noti.png';
            actionText = 'Danh sách giao dịch';
            color = AppColor.GREEN;
          }
        }
        break;
      case Stringify.NOTI_INVOICE_CREATE:
        if (widget.data['invoiceId'].isNotEmpty) {
          icLogo = 'assets/images/ic-noti-invoice.png';
          actionText = 'Thanh toán ngay';
          color = AppColor.ORANGE_C02;
        } else {
          icLogo = 'assets/images/ic-noti-invoice.png';
          actionText = 'Danh sách hóa đơn';
          color = AppColor.ORANGE_C02;
        }

        break;
      case Stringify.NOTI_INVOICE_SUCCESS:
        if (widget.data['status'] != 0) {
          icLogo = 'assets/images/ic-noti-invoice.png';
          actionText = 'Danh sách hóa đơn';
          color = AppColor.ORANGE_C02;
        }
        break;
      default:
        break;
    }
    return Material(
      color: AppColor.TRANSPARENT,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE,
            boxShadow: [
              BoxShadow(
                  color: AppColor.BLACK.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    icLogo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  // HtmlWidget(
                  //   data['html'],
                  //   customStylesBuilder: (element) {

                  //   },
                  // )
                  if (widget.data['notificationType'] ==
                          Stringify.NOTI_INVOICE_CREATE ||
                      widget.data['notificationType'] ==
                          Stringify.NOTI_INVOICE_SUCCESS)
                    Html(
                      data: widget.data['html'],
                      shrinkWrap: true,
                      style: {
                        'span': Style(
                            textOverflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            fontSize: FontSize(15)),
                      },
                    ),
                ],
              ),
            ),
            if (widget.data['notificationType'] ==
                Stringify.NOTI_INVOICE_CREATE) ...[
              const MySeparator(color: AppColor.GREY_DADADA),
              InkWell(
                onTap: () {
                  if (widget.data['invoiceId'].isNotEmpty) {
                    context.pushReplacement('/invoice-list');

                    Provider.of<InvoiceProvider>(context, listen: false)
                        .onPageChange(PageInvoice.DETAIL,
                            invoiceId: widget.data['invoiceId']);
                  } else {
                    context.pushReplacement('/invoice-list');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: color,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
