import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';

import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/widgets/detail_bank_widget.dart';
import 'package:VietQR/features/home/frames/home_frame.dart';
import 'package:VietQR/features/token/blocs/token_bloc.dart';
import 'package:VietQR/features/token/events/token_event.dart';
import 'package:VietQR/features/token/states/token_state.dart';
import 'package:VietQR/features/token/widgets/disconnect_widget.dart';
import 'package:VietQR/features/token/widgets/maintain_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/widgets/transaction_detail_view.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/transaction_list_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../commons/enums/event_type.dart';

class ECOMHomeScreen extends StatefulWidget {
  const ECOMHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<ECOMHomeScreen> {
  late BankBloc _bankBloc;
  late TokenBloc _tokenBloc;
  int currentPage = 0;
  List<BankAccountDTO> bankAccounts = [];
  List<Color> cardColors = [];

  late WebSocketChannel channel;

  List<RelatedTransactionReceiveDTO> transactions = [];
  String userId = UserInformationHelper.instance.getUserECOMId();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: width * 0.9,
            child: Column(
              children: [
                const SelectableText('value token'),
                const SizedBox(
                  height: 50,
                ),
                Tooltip(
                  message: 'Thêm tài khoản ngân hàng',
                  child: ButtonIconWidget(
                    width: width * 0.6,
                    height: 45,
                    icon: Icons.add_rounded,
                    title: 'Thêm tài khoản ngân hàng',
                    function: () {
                      context.push('/ecom/bank/create/$userId');
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.GREEN,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
