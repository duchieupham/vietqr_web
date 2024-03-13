import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/transaction/views/transaction_fram_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'views/transaction_accounting_view.dart';
import 'views/transaction_payment_view.dart';

class TransactionScreen extends StatefulWidget {
  final String type;

  const TransactionScreen({super.key, required this.type});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TransactionFrame(
      menu: MenuLeft(
        currentType: MenuHomeType.TRANSACTION,
        subMenuTransaction: [
          ItemMenuHome(
            title: 'Giao dịch thanh toán',
            isSelect:
                (widget.type == '0') || (widget.type.contains('0?bankId=')),
            onTap: () {
              context.push('/transactions', extra: {'type': '0'});
            },
          ),
          ItemMenuHome(
            title: 'Giao dịch chờ xác nhận',
            isSelect:
                (widget.type == '1') || (widget.type.contains('1?bankId=')),
            onTap: () {
              context.push('/transactions', extra: {'type': '1'});
            },
          ),
        ],
      ),
      title: const SizedBox(),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if ((widget.type == '0') || (widget.type.contains('0?bankId='))) {
      return const TransactionPaymentView();
    }
    return const TransactionAccountingView();
  }
}
