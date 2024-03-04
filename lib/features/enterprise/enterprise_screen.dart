import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/enterprise/enterprise.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnterpriseScreen extends StatefulWidget {
  const EnterpriseScreen({super.key});

  @override
  State<EnterpriseScreen> createState() => _EnterpriseScreenState();
}

class _EnterpriseScreenState extends State<EnterpriseScreen> {
  late EnterpriseBloc bloc;
  EnterpriseMenuType currentType = EnterpriseMenuType.STORE;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return EnterpriseFrame(
      menu: MenuLeft(
        currentType: MenuHomeType.ENTERPRISE,
        subMenuEnterprise: [
          ItemMenuHome(
            title: 'Tổng quan',
            isSelect: true,
            onTap: () {},
          ),
          ItemMenuHome(
            title: 'Cửa hàng',
            isSelect: false,
            onTap: () {
              context.go('/enterprise/store');
            },
          ),
        ],
      ),
      widget1: Column(
        children: const [
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
      title: const SizedBox(),
    );
  }
}
