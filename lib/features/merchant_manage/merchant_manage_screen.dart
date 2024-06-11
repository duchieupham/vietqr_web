import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_dropdown.dart';
import 'package:VietQR/features/merchant_manage/views/merchant_api_service_screen.dart';
import 'package:VietQR/features/merchant_manage/views/merchant_connected_machine_screen.dart';
import 'package:VietQR/features/merchant_manage/views/merchant_e_commerce_screen.dart';
import 'package:VietQR/features/qr_manage/frame/qr_frame.dart';
import 'package:VietQR/services/providers/merchant_provider.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:provider/provider.dart';

// ignore: camel_case_types, constant_identifier_names
enum Merchant_Type { API_SERVICE, E_COMMERCE, CONNECTED_MACHINE }

class MerchantManageScreen extends StatefulWidget {
  final Merchant_Type type;

  const MerchantManageScreen({super.key, required this.type});

  @override
  State<MerchantManageScreen> createState() => _MerchantManageScreenState();
}

class _MerchantManageScreenState extends State<MerchantManageScreen> {
  Merchant_Type type = Merchant_Type.API_SERVICE;

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
          currentType: MenuHomeType.MERCHANT_V2,
          subMenuMerchantV2: [
            ItemDropDownMenu(
              title: 'Kết nối API Service',
              isSelect: type == Merchant_Type.API_SERVICE,
              onTap: () => onTapMenu(Merchant_Type.API_SERVICE),
            ),
            ItemDropDownMenu(
              title: 'Kết nối E-Commerce',
              isSelect: type == Merchant_Type.E_COMMERCE,
              onTap: () => onTapMenu(Merchant_Type.E_COMMERCE),
            ),
            ItemDropDownMenu(
              title: 'Kết nối máy bán hàng',
              isSelect: type == Merchant_Type.CONNECTED_MACHINE,
              onTap: () => onTapMenu(Merchant_Type.CONNECTED_MACHINE),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(Merchant_Type value) {
    if (value == Merchant_Type.API_SERVICE) {
      html.window.history
          .pushState(null, '/merchantv2', '/merchantv2/api-service');
      type = value;
    } else if (value == Merchant_Type.E_COMMERCE) {
      html.window.history
          .pushState(null, '/merchantv2', '/merchantv2/e-commerce');
      type = value;
    } else {
      html.window.history
          .pushState(null, '/merchantv2', '/merchantv2/connected-machine');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == Merchant_Type.API_SERVICE) {
      return const MerchantApiServiceScreen();
    } else if (type == Merchant_Type.E_COMMERCE) {
      return const MerchantEcommerceScreen();
    } else {
      return const MerchantConnectedMachineScreen();
    }
  }
}
