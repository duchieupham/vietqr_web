// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/transaction/views/transaction_fram_view.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

enum MemberType { LIST_MEMBER, ADD_MEMBER }

class MemberManageScreen extends StatefulWidget {
  const MemberManageScreen({super.key});

  @override
  State<MemberManageScreen> createState() => _MemberManageScreenState();
}

class _MemberManageScreenState extends State<MemberManageScreen> {
  MemberType type = MemberType.LIST_MEMBER;

  @override
  Widget build(BuildContext context) {
    return TransactionFrame(
      menu: MenuLeft(
        currentType: MenuHomeType.MEMBER,
        subMenuMember: [
          ItemMenuHome(
            title: 'GD thanh toán',
            isSelect: type == MemberType.LIST_MEMBER,
            onTap: () => onTapMenu(MemberType.LIST_MEMBER),
          ),
          ItemMenuHome(
            title: 'GD chờ xác nhận',
            isSelect: type == MemberType.ADD_MEMBER,
            onTap: () => onTapMenu(MemberType.ADD_MEMBER),
          ),
        ],
      ),
      title: const SizedBox(),
      child: Container(),
    );
  }

  void onTapMenu(MemberType value) {
    if (value == MemberType.LIST_MEMBER) {
      html.window.history.pushState(null, '/member', '/member/list');
      type = value;
    } else {
      html.window.history.pushState(null, '/member', '/member/add-member');
      type = value;
    }
    setState(() {});
  }
}
