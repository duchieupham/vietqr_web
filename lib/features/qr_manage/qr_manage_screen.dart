import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_dropdown.dart';
import 'package:VietQR/features/qr_manage/frame/qr_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:html' as html;

import 'views/qr_create_screen.dart';

// ignore: camel_case_types, constant_identifier_names
enum Qr_Manage { CREATE, WALLET }

class QrManageScreen extends StatefulWidget {
  final Qr_Manage type;

  const QrManageScreen({super.key, required this.type});

  @override
  State<QrManageScreen> createState() => _QrManageScreenState();
}

class _QrManageScreenState extends State<QrManageScreen> {
  Qr_Manage type = Qr_Manage.CREATE;
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
          currentType: MenuHomeType.CREATE_QR,
          subMenuQr: [
            ItemDropDownMenu(
              title: 'Tạo mã VietQR',
              isSelect: type == Qr_Manage.CREATE,
              onTap: () => onTapMenu(Qr_Manage.CREATE),
            ),
            ItemDropDownMenu(
              title: 'Ví QR',
              isSelect: type == Qr_Manage.WALLET,
              onTap: () => onTapMenu(Qr_Manage.WALLET),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(Qr_Manage value) {
    if (value == Qr_Manage.CREATE) {
      html.window.history.pushState(null, '/qr', '/create-vietqr');
      type = value;
    } else if (value == Qr_Manage.WALLET) {
      html.window.history.pushState(null, '/qr', '/vietqr-wallet');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == Qr_Manage.CREATE) {
      return const QrGenerateScreen();
    } else {
      return const SizedBox();
    }
  }
}
