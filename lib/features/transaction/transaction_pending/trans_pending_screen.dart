// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/layouts/dialog/choose_bank_widget.dart';
import 'package:VietQR/features/transaction/widgets/trans_header_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/services/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'views/trans_pending_view.dart';
import 'views/trans_unclassified_view.dart';

enum TransPendingType { unclassified, waiting, none }

extension TransPendingExt on TransPendingType {
  int get transPenIndex {
    switch (this) {
      case TransPendingType.waiting:
        return 1;
      case TransPendingType.unclassified:
      default:
        return 0;
    }
  }
}

class TransPendingScreen extends StatefulWidget {
  const TransPendingScreen({super.key});

  @override
  State<TransPendingScreen> createState() => TransPendingScreenState();
}

class TransPendingScreenState extends State<TransPendingScreen> {
  late TransactionBloc bloc;
  late SettingProvider provider;
  final _streamController = StreamController<dynamic>.broadcast();

  late Stream<dynamic> unclassifiedStream;
  late Stream<dynamic> pendingStream;

  final List<DataPending> _tabs = [
    DataPending(
        title: 'GD chưa phân loại', type: TransPendingType.unclassified),
    DataPending(title: 'GD chờ xác nhận', type: TransPendingType.waiting),
  ];

  TransPendingType transType = TransPendingType.none;

  /// 3,4,9 value = "" => get all trans
  BankAccountDTO bank = BankAccountDTO();

  TransactionInputDTO inputDTO = TransactionInputDTO();
  MerchantRole role = MerchantRole();
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    bloc = TransactionBloc();
    provider = Provider.of<SettingProvider>(context, listen: false);
    unclassifiedStream = _streamController.stream;
    pendingStream = _streamController.stream;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetListBankEvent());
    });
  }

  void onRole() {
    isOwner = bank.isOwner;
    if (!isOwner) {
      SettingAccountDTO settingDTO = provider.settingAccountDTO;
      List<MerchantRole> merchantRoles = [...settingDTO.merchantRoles];
      MerchantRole merchantDTO = merchantRoles.firstWhere(
          (element) => element.bankId == bank.bankId,
          orElse: () => MerchantRole());
      if (merchantDTO.bankId.isEmpty) return;
      role = merchantDTO;
    }
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
                  if (state.isLoading)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else if (!role.disableTab && !isOwner)
                    const Center(
                      child: Text('Bạn không có quyền truy cập'),
                    )
                  else ...[
                    _buildTabWidget(),
                    const SizedBox(height: 24),
                    IndexedStack(
                      index: transType.transPenIndex,
                      children: <Widget>[
                        TransUnclassifiedView(
                          bank: bank,
                          role: role,
                          dto: inputDTO,
                          stream: unclassifiedStream,
                          callBack: (value) {
                            inputDTO = value;
                            updateState();
                          },
                        ),
                        TransPendingView(
                          inputDTO: inputDTO,
                          stream: pendingStream,
                          role: role,
                          isOwner: isOwner,
                        ),
                      ],
                    ),
                  ],
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
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.GREY_BORDER),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.map((e) {
          bool selected = transType == e.type;
          if (!isOwner &&
              role.isUnclassified &&
              e.type == TransPendingType.waiting) {
            return const SizedBox();
          }
          return SizedBox(
            width: 200,
            child: GestureDetector(
              onTap: () {
                if (e.type == TransPendingType.waiting) {
                  _streamController.sink.add(inputDTO);
                }
                setState(() {
                  transType = e.type;
                });
              },
              child: Container(
                color: selected
                    ? AppColor.BLUE_TEXT.withOpacity(0.25)
                    : Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  e.title,
                  style: TextStyle(
                    color: selected ? AppColor.BLUE_TEXT : null,
                    fontWeight: selected ? FontWeight.bold : null,
                    fontSize: 12,
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
        return ChooseBankWidget(banks: list);
      },
    );

    if (data != null && data is BankAccountDTO) {
      if (transType == TransPendingType.waiting) {
        transType = TransPendingType.unclassified;
        updateState();
      }

      bloc.add(UpdateBankAccountEvent(data));
    }
  }

  void _listener(BuildContext context, TransactionState state) async {
    if (state.request == TransType.GET_BANKS) {
      bloc.add(GetTerminalsEvent(state.bankDTO?.bankId ?? ''));

      html.window.history.pushState(
          null,
          '/transactions?type=1?bankId=${bank.bankId}',
          '/transactions?type=1?bankId=${state.bankDTO?.bankId ?? ''}');

      bank = state.bankDTO ?? bank;
      transType = TransPendingType.unclassified;
      onRole();
      updateState();
    }

    if (state.request == TransType.UPDATE_BANK) {
      html.window.history.pushState(
          null,
          '/transactions?type=1?bankId=${bank.bankId}',
          '/transactions?type=1?bankId=${state.bankDTO?.bankId ?? ''}');
      bank = state.bankDTO ?? bank;

      onRole();
      updateState();
      _streamController.sink.add(bank);
    }
  }

  void updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    if (_streamController.hasListener) {
      _streamController.close();
    }
    super.dispose();
  }
}

class DataPending {
  final String title;
  final TransPendingType type;

  DataPending({required this.title, required this.type});
}
