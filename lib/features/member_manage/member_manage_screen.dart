// ignore_for_file: constant_identifier_names

import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/transaction/views/transaction_fram_view.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'member_manage.dart';

enum MemberType { LIST_MEMBER, ADD_MEMBER }

class MemberManageScreen extends StatefulWidget {
  final MemberType type;

  const MemberManageScreen({super.key, required this.type});

  @override
  State<MemberManageScreen> createState() => _MemberManageScreenState();
}

class _MemberManageScreenState extends State<MemberManageScreen> {
  MemberType type = MemberType.LIST_MEMBER;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TransactionFrame(
      menu: MenuLeft(
        currentType: MenuHomeType.MEMBER,
        subMenuMember: [
          ItemMenuHome(
            title: 'Danh sách nhân viên',
            isSelect: type == MemberType.LIST_MEMBER,
            onTap: () => onTapMenu(MemberType.LIST_MEMBER),
          ),
          ItemMenuHome(
            title: 'Thêm mới nhân viên',
            isSelect: type == MemberType.ADD_MEMBER,
            onTap: () => onTapMenu(MemberType.ADD_MEMBER),
          ),
        ],
      ),
      title: const SizedBox(),
      child: _buildBody(),
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

  Widget _buildBody() {
    if (type == MemberType.LIST_MEMBER) {
      return const ListMemberView();
    }
    return const SizedBox();
  }
}
