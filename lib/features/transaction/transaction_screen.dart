import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/token/blocs/token_bloc.dart';
import 'package:VietQR/features/token/events/token_event.dart';
import 'package:VietQR/features/token/states/token_state.dart';
import 'package:VietQR/features/transaction/views/transaction_fram_view.dart';
import 'package:VietQR/layouts/maintain_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../home/widget/item_menu_dropdown.dart';
import 'transaction_pending/trans_pending_screen.dart';
import 'transaction_pending/views/trans_unclassified_view.dart';
import 'transaction_payment/trans_payment_screen.dart';
import 'dart:html' as html;

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TokenBloc bloc;
  String type = '0';

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
    bloc.add(const TokenEventCheckValid());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokenBloc, TokenState>(
      listener: (context, state) async {
        if (state is SystemMaintainState) {
          await DialogWidget.instance.showFullModalBottomContent(
            isDissmiss: false,
            widget: MaintainWidget(
              onRetry: () {
                context.read<TokenBloc>().add(const TokenEventCheckValid());
                Navigator.pop(context);
              },
            ),
          );
        }
        if (state is TokenExpiredState) {
          await DialogWidget.instance.openMsgDialog(
              title: 'Phiên đăng nhập hết hạn',
              msg: 'Vui lòng đăng nhập lại ứng dụng',
              function: () {
                context.read<TokenBloc>().add(TokenEventLogout());
              });
        }
        if (state is TokenExpiredLogoutState) {
          if (!mounted) return;
          context.pushReplacement("/login");
        }

        if (state is TokenLogoutFailedState) {
          await DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng xuất',
            msg: 'Vui lòng thử lại sau.',
          );
        }
      },
      builder: (context, state) {
        return TransactionFrame(
          menu: MenuLeft(
            currentType: MenuHomeType.TRANSACTION,
            subMenuTransaction: [
              ItemDropDownMenu(
                title: 'Quản lý GD thanh toán',
                isSelect: type == "0" ? true : false,
                onTap: () => onTapMenu('0'),
              ),
              ItemDropDownMenu(
                title: 'Quản lý GD chờ xác nhận',
                isSelect: type == "1" ? true : false,
                onTap: () => onTapMenu('1'),
              ),
            ],
          ),
          title: const SizedBox(),
          child: _buildBody(),
        );
      },
    );
  }

  void onTapMenu(String value) {
    if (value == '0') {
      html.window.history
          .pushState(value, '/transactions', '/transactions?type=$value');
      type = value;
    } else {
      html.window.history
          .pushState(value, '/transactions', '/transactions?type=$value');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == '0') {
      return const TransactionPaymentView();
    }
    return const TransPendingScreen();
  }
}
