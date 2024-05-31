import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_dropdown.dart';
import 'package:VietQR/features/invoice_manage/views/invoice_list_screen.dart';
import 'package:VietQR/features/qr_manage/frame/qr_frame.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

// ignore: camel_case_types, constant_identifier_names
enum Invoice_Type { LIST, SERVICE_FEE }

class InvoiceManageScreen extends StatefulWidget {
  final Invoice_Type type;

  const InvoiceManageScreen({super.key, required this.type});

  @override
  State<InvoiceManageScreen> createState() => _InvoiceManageScreenState();
}

class _InvoiceManageScreenState extends State<InvoiceManageScreen> {
  Invoice_Type type = Invoice_Type.LIST;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FrameViewWidget(
        title: const SizedBox(),
        menu: MenuLeft(
          currentType: MenuHomeType.INVOICE,
          subMenuInvoice: [
            ItemDropDownMenu(
              title: 'Danh sách hoá đơn',
              isSelect: type == Invoice_Type.LIST,
              onTap: () => onTapMenu(Invoice_Type.LIST),
            ),
            ItemDropDownMenu(
              title: 'Thu phí dịch vụ',
              isSelect: type == Invoice_Type.SERVICE_FEE,
              onTap: () => onTapMenu(Invoice_Type.SERVICE_FEE),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(Invoice_Type value) {
    if (value == Invoice_Type.LIST) {
      html.window.history.pushState(null, '/invoice', '/invoice');
      type = value;
    } else if (value == Invoice_Type.SERVICE_FEE) {
      html.window.history.pushState(null, '/invoice', '/service-fee');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == Invoice_Type.LIST) {
      return const InvoiceListScreen();
    } else {
      return const SizedBox();
    }
  }
}
