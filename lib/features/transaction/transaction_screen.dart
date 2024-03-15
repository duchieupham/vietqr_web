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

import 'views/transaction_accounting_view.dart';
import 'views/transaction_payment_view.dart';

class TransactionScreen extends StatefulWidget {
  final String type;

  const TransactionScreen({super.key, required this.type});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TokenBloc bloc;

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
              ItemMenuHome(
                title: 'GD thanh toán',
                isSelect:
                    (widget.type == '0') || (widget.type.contains('0?bankId=')),
                onTap: () {
                  context.push('/transactions', extra: {'type': '0'});
                },
              ),
              ItemMenuHome(
                title: 'GD chờ xác nhận',
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
      },
    );
  }

  Widget _buildBody() {
    if ((widget.type == '0') || (widget.type.contains('0?bankId='))) {
      return const TransactionPaymentView();
    }
    return const TransactionAccountingView();
  }
}
