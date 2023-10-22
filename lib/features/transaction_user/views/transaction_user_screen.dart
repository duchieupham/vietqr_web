import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/transaction_user/blocs/tran_user_bloc.dart';
import 'package:VietQR/features/transaction_user/page/list_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../frame/trans_user_frame.dart';

class TransactionUserScreen extends StatefulWidget {
  const TransactionUserScreen({super.key});

  @override
  State<TransactionUserScreen> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<TransactionUserScreen> {
  late TransactionUserBloc transactionUserBloc;

  @override
  void initState() {
    transactionUserBloc = TransactionUserBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return MerchantFrame(
      menu: const MenuLeft(
        currentType: MenuHomeType.TRANSACTION,
      ),
      table: BlocProvider<TransactionUserBloc>(
        create: (context) => transactionUserBloc,
        child: SizedBox(
          width: width,
          height: height - 60,
          child: ListTransactionUser(
            transactionUserBloc: transactionUserBloc,
          ),
        ),
      ),
    );
  }
}
