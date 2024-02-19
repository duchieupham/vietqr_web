import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/transaction_user/blocs/tran_user_bloc.dart';
import 'package:VietQR/features/transaction_user/page/list_transaction.dart';
import 'package:VietQR/features/transaction_user/provider/trans_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../frame/trans_user_frame.dart';

class TransactionUserScreen extends StatefulWidget {
  const TransactionUserScreen({super.key});

  @override
  State<TransactionUserScreen> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<TransactionUserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<TransUserProvider>(
      create: (context) => TransUserProvider(),
      child: MerchantFrame(
        menu: Consumer<TransUserProvider>(builder: (context, provider, child) {
          return MenuLeft(
            currentType: MenuHomeType.TRANSACTION,
            subMenuTransactionUser: [
              ItemMenuHome(
                title: 'Tất cả',
                isSelect: provider.valueFilter.id == 9,
                onTap: () {
                  provider.changeFilter(
                      const FilterTransaction(id: 9, title: 'Tất cả'));
                },
              ),
              ItemMenuHome(
                title: 'Số tài khoản',
                isSelect: provider.valueFilter.id == 0,
                onTap: () {
                  provider.changeFilter(
                      const FilterTransaction(id: 0, title: 'Số tài khoản'));
                },
              ),
              ItemMenuHome(
                title: 'Mã giao dịch',
                isSelect: provider.valueFilter.id == 1,
                onTap: () {
                  provider.changeFilter(
                      const FilterTransaction(id: 1, title: 'Mã giao dịch'));
                },
              ),
              ItemMenuHome(
                title: 'Order ID',
                isSelect: provider.valueFilter.id == 2,
                onTap: () {
                  provider.changeFilter(
                      const FilterTransaction(id: 2, title: 'Order ID'));
                },
              ),
              ItemMenuHome(
                title: 'Mã điểm bán',
                isSelect: provider.valueFilter.id == 4,
                onTap: () {
                  provider.changeFilter(
                      const FilterTransaction(id: 4, title: 'Mã điểm bán'));
                },
              ),
              ItemMenuHome(
                title: 'Nội dung',
                isSelect: provider.valueFilter.id == 3,
                onTap: () {
                  provider.changeFilter(
                      const FilterTransaction(id: 3, title: 'Nội dung'));
                },
              ),
            ],
          );
        }),
        table: BlocProvider<TransactionUserBloc>(
          create: (context) => TransactionUserBloc(),
          child: SizedBox(
            width: width,
            height: height - 60,
            child: const ListTransactionUser(),
          ),
        ),
      ),
    );
  }
}
