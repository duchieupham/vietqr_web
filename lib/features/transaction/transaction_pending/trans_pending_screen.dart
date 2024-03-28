import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/widgets/dialog_choose_bank_widget.dart';
import 'package:VietQR/features/transaction/widgets/trans_header_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'trans_unclassified_view.dart';
import 'trans_pending_view.dart';

enum TransPendingType { unclassified, waiting }

class TransPendingScreen extends StatefulWidget {
  const TransPendingScreen({super.key});

  @override
  State<TransPendingScreen> createState() => _TransPendingScreenState();
}

class _TransPendingScreenState extends State<TransPendingScreen> {
  late TransactionBloc bloc;
  final List<DataPending> _tabs = [
    DataPending(
        title: 'GD chưa phân loại', type: TransPendingType.unclassified),
    DataPending(title: 'GD chờ xác nhận', type: TransPendingType.waiting),
  ];

  String _bankId = '';
  TransPendingType transType = TransPendingType.unclassified;

  @override
  void initState() {
    super.initState();
    bloc = TransactionBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetListBankEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => bloc,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: _listener,
        builder: (context, state) {
          return TransHeaderWidget(
            title: 'Giao dịch chờ xác nhận',
            dto: state.bankDTO,
            onTap: () => _onChooseBank(state.listBanks),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabWidget(),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabWidget() {
    return Container(
      height: 40,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.GREY_BORDER),
      ),
      child: Row(
        children: _tabs.map((e) {
          bool selected = transType == e.type;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                transType = e.type;
              }),
              child: Container(
                color: selected ? AppColor.BLUE_TEXT.withOpacity(0.25) : null,
                alignment: Alignment.center,
                child: Text(
                  e.title,
                  style: TextStyle(
                    color: selected ? AppColor.BLUE_TEXT : null,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _onChooseBank(List<BankAccountDTO> list) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogChooseBankWidget(banks: list);
      },
    );

    if (data != null && data is BankAccountDTO) {
      bloc.add(UpdateBankAccountEvent(data));
    }
  }

  void _listener(BuildContext context, TransactionState state) async {
    if (state.request == TransType.UPDATE_BANK) {
      _bankId = state.bankDTO?.bankId ?? '';
      updateState();
    }
  }

  void updateState() {
    setState(() {});
  }

  Widget _buildBody() {
    if (transType == TransPendingType.waiting) {
      return const TransPendingView();
    }

    return const TransUnclassifiedView();
  }
}

class DataPending {
  final String title;
  final TransPendingType type;

  DataPending({required this.title, required this.type});
}
