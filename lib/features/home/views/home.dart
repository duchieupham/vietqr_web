import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';

import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/home/frames/home_frame.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/widgets/transaction_success_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/notification_transaction_success_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/transaction_list_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late BankBloc _bankBloc;
  late TransactionBloc _transactionBloc;
  List<BankAccountDTO> bankAccounts = [];
  List<Color> cardColors = [];

  late WebSocketChannel channel;

  List<RelatedTransactionReceiveDTO> transactions = [];

  @override
  void initState() {
    super.initState();
    String userId = UserInformationHelper.instance.getUserId();
    listenWebSocket(userId);
    _bankBloc = BlocProvider.of(context);
    _transactionBloc = BlocProvider.of(context);
    _bankBloc.add(BankEventGetList(userId: userId));
  }

  void listenWebSocket(String userId) {
    if (userId.isNotEmpty) {
      bool isListenWebSocket = WebSocketHelper.instance.isListenWs();
      if (!isListenWebSocket) {
        try {
          WebSocketHelper.instance.setListenWs(true);
          final wsUrl =
              Uri.parse('wss://api.vietqr.org/vqr/socket?userId=$userId');
          channel = WebSocketChannel.connect(wsUrl);
          print('channel.closeCode: ${channel.closeCode}');
          if (channel.closeCode == null) {
            channel.stream.listen((event) {
              var data = jsonDecode(event);
              if (data['notificationType'] != null &&
                  data['notificationType'] ==
                      Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
                DialogWidget.instance.openWidgetDialog(
                  child: TransactionSuccessWidget(
                    dto: NotificationTransactionSuccessDTO.fromJson(data),
                  ),
                );
              }
            });
          } else {
            WebSocketHelper.instance.setListenWs(false);
          }
        } catch (e) {
          print('WS: $e');
          LOG.error('WS: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: HomeFrame(
        widget1: Column(
          children: [
            _buildTableRow(),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            UnconstrainedBox(
              child: SizedBox(
                  width: width - 80 - 400,
                  height: 30,
                  child: Consumer<TransactionListProvider>(
                    builder: (context, provider, child) {
                      return (provider.transactionEmpty)
                          ? const SizedBox()
                          : Row(
                              children: [
                                const Spacer(),
                                Text('Trang ${provider.page ~/ 20 + 1}'),
                                const Padding(
                                    padding: EdgeInsets.only(left: 30)),
                                if (provider.page != 0 &&
                                    (provider.page ~/ 20) != 1)
                                  Tooltip(
                                    message: 'Trang đầu',
                                    child: InkWell(
                                      onTap: () {
                                        int prevPage = 0 * 20;
                                        String bankId =
                                            Provider.of<MenuCardProvider>(
                                                    context,
                                                    listen: false)
                                                .bankDetailDTO
                                                .id;
                                        provider.updatePage(prevPage);
                                        provider.updateEnded(false);
                                        TransactionInputDTO
                                            transactionInputDTO =
                                            TransactionInputDTO(
                                                bankId: bankId,
                                                offset: prevPage);

                                        _transactionBloc.add(
                                            TransactionEventFetch(
                                                dto: transactionInputDTO));
                                      },
                                      child: BoxLayout(
                                        width: 25,
                                        height: 25,
                                        borderRadius: 25,
                                        bgColor: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.3),
                                        padding: const EdgeInsets.all(0),
                                        child: Icon(
                                          Icons.first_page_rounded,
                                          color: Theme.of(context).hintColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                if (provider.page != 0)
                                  Tooltip(
                                    message: 'Trang trước',
                                    child: InkWell(
                                      onTap: () {
                                        int prevPage =
                                            (provider.page ~/ 20 - 1) * 20;
                                        String bankId =
                                            Provider.of<MenuCardProvider>(
                                                    context,
                                                    listen: false)
                                                .bankDetailDTO
                                                .id;
                                        provider.updatePage(prevPage);
                                        provider.updateEnded(false);
                                        TransactionInputDTO
                                            transactionInputDTO =
                                            TransactionInputDTO(
                                                bankId: bankId,
                                                offset: prevPage);

                                        _transactionBloc.add(
                                            TransactionEventFetch(
                                                dto: transactionInputDTO));
                                      },
                                      child: BoxLayout(
                                        width: 25,
                                        height: 25,
                                        borderRadius: 25,
                                        bgColor: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.3),
                                        padding: const EdgeInsets.all(0),
                                        child: Icon(
                                          Icons.navigate_before_rounded,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                if (!provider.ended)
                                  Tooltip(
                                    message: 'Trang sau',
                                    child: InkWell(
                                      onTap: () {
                                        int nextPage =
                                            (provider.page ~/ 20 + 1) * 20;
                                        String bankId =
                                            Provider.of<MenuCardProvider>(
                                                    context,
                                                    listen: false)
                                                .bankDetailDTO
                                                .id;
                                        provider.updatePage(nextPage);
                                        TransactionInputDTO
                                            transactionInputDTO =
                                            TransactionInputDTO(
                                                bankId: bankId,
                                                offset: nextPage);
                                        _transactionBloc.add(
                                            TransactionEventFetch(
                                                dto: transactionInputDTO));
                                      },
                                      child: BoxLayout(
                                        width: 25,
                                        height: 25,
                                        borderRadius: 25,
                                        bgColor: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.3),
                                        padding: const EdgeInsets.all(0),
                                        child: Icon(
                                          Icons.navigate_next_rounded,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            );
                    },
                  )),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
        widget2: Consumer<MenuCardProvider>(
          builder: (context, provider, child) {
            return (provider.qrGeneratedDTO.qrCode.trim().isEmpty)
                ? const SizedBox()
                : ListView(
                    shrinkWrap: true,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      UnconstrainedBox(
                        child: VietQRWidget(
                          width: 400,
                          qrGeneratedDTO: provider.qrGeneratedDTO,
                          content: '',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      UnconstrainedBox(
                        child: SizedBox(
                          width: 350,
                          child: Row(
                            children: [
                              Tooltip(
                                message: 'In',
                                child: ButtonIconWidget(
                                  width: 350 / 3 - (20 / 3),
                                  height: 40,
                                  icon: Icons.print_rounded,
                                  title: '',
                                  function: () {},
                                  bgColor: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.3),
                                  textColor: Theme.of(context).hintColor,
                                ),
                              ),
                              const Spacer(),
                              Tooltip(
                                message: 'Lưu ảnh',
                                child: ButtonIconWidget(
                                  width: 350 / 3 - (20 / 3),
                                  height: 40,
                                  icon: Icons.photo_rounded,
                                  title: '',
                                  function: () {},
                                  bgColor: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.3),
                                  textColor: Theme.of(context).hintColor,
                                ),
                              ),
                              const Spacer(),
                              Tooltip(
                                message: 'Sao chép mã QR',
                                child: ButtonIconWidget(
                                  width: 350 / 3 - (20 / 3),
                                  height: 40,
                                  icon: Icons.copy_rounded,
                                  title: '',
                                  function: () {},
                                  bgColor: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.3),
                                  textColor: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      UnconstrainedBox(
                        child: Tooltip(
                          message: 'Tạo QR giao dịch',
                          child: ButtonIconWidget(
                            width: 350,
                            height: 40,
                            icon: Icons.add_rounded,
                            title: 'Tạo QR giao dịch',
                            function: () {
                              String id = provider.bankDetailDTO.id;
                              context.push('/qr/create/$id');
                            },
                            bgColor:
                                Theme.of(context).cardColor.withOpacity(0.3),
                            textColor: DefaultTheme.GREEN,
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
        menu: BlocConsumer<BankBloc, BankState>(
          listener: (context, state) {
            if (state is BankGetListSuccessState) {
              _resetBank();
              if (bankAccounts.isEmpty) {
                bankAccounts.addAll(state.list);
                cardColors.addAll(state.colors);
                TransactionInputDTO transactionInputDTO = TransactionInputDTO(
                  bankId: bankAccounts.first.id,
                  offset: 0,
                );
                _bankBloc
                    .add(BankEventGetDetail(bankId: bankAccounts.first.id));
                _transactionBloc
                    .add(TransactionEventGetList(dto: transactionInputDTO));
              }
            }
            if (state is BankDetailSuccessState) {
              Provider.of<MenuCardProvider>(context, listen: false)
                  .updateBankDetail(state.dto);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Tài khoản ngân hàng',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (bankAccounts.isNotEmpty)
                      BoxLayout(
                        width: 25,
                        height: 25,
                        borderRadius: 25,
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        bgColor: DefaultTheme.PURPLE_NEON.withOpacity(0.3),
                        child: Text(
                          bankAccounts.length.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: DefaultTheme.PURPLE_NEON,
                          ),
                        ),
                      ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(child: Consumer<MenuCardProvider>(
                  builder: (context, provider, child) {
                    return (bankAccounts.isEmpty)
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: bankAccounts.length,
                            itemBuilder: (context, index) {
                              ScrollController scrollController =
                                  ScrollController();
                              scrollController.addListener(() {
                                if (scrollController.hasClients) {
                                  scrollController.jumpTo(0);
                                }
                              });
                              return InkWell(
                                onTap: () {
                                  provider.updateIndex(index);
                                  _bankBloc.add(BankEventGetDetail(
                                      bankId: bankAccounts[index].id));
                                  Provider.of<TransactionListProvider>(context,
                                          listen: false)
                                      .reset();
                                  TransactionInputDTO transactionInputDTO =
                                      TransactionInputDTO(
                                    bankId: bankAccounts[index].id,
                                    offset: 0,
                                  );
                                  _transactionBloc.add(TransactionEventGetList(
                                      dto: transactionInputDTO));
                                  provider.updateShowMenu(!provider.showMenu);
                                },
                                child: AnimatedContainer(
                                  width: 300,
                                  height: (provider.index == index) ? 150 : 80,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (provider.index == index)
                                        ? cardColors[index]
                                        : cardColors[index].withOpacity(0.7),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    key: Key('card$index'),
                                    controller: scrollController,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        height: 35,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: DefaultTheme.WHITE,
                                                image: DecorationImage(
                                                  image: ImageUtils.instance
                                                      .getImageNetWork(
                                                    bankAccounts[index].imgId,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10)),
                                            Expanded(
                                              child: Text(
                                                '${bankAccounts[index].bankCode} - ${bankAccounts[index].bankAccount}\n${bankAccounts[index].bankName}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: DefaultTheme.WHITE,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (provider.index == index) ...[
                                        const Padding(
                                            padding: EdgeInsets.only(top: 30)),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      bankAccounts[index]
                                                          .userBankName
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color:
                                                            DefaultTheme.WHITE,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      (bankAccounts[index]
                                                              .isAuthenticated)
                                                          ? 'Trạng thái: Đã liên kết'
                                                          : 'Trạng thái: Chưa liên kết',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            DefaultTheme.WHITE,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  },
                )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableRow() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height - 120,
      alignment: Alignment.topCenter,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionGetListSuccessState) {
            _resetTransaction();
            if (state.list.isEmpty) {
              Provider.of<TransactionListProvider>(context, listen: false)
                  .updateTransactionEmpty(true);
            }
            if (state.list.isEmpty || state.list.length < 20) {
              Provider.of<TransactionListProvider>(context, listen: false)
                  .updateEnded(true);
            } else {
              Provider.of<TransactionListProvider>(context, listen: false)
                  .updateEnded(false);
            }
            if (transactions.isEmpty) {
              transactions = state.list;
            }
          }
          if (state is TransactionFetchSuccessState) {
            transactions.clear();
            if (state.list.isEmpty || state.list.length < 20) {
              Provider.of<TransactionListProvider>(context, listen: false)
                  .updateEnded(true);
            }
            if (transactions.isEmpty) {
              transactions = state.list;
            }
          }
        },
        builder: (context, state) {
          if (state is TransactionGetListSuccessState) {
            if (state.list.isEmpty) {
              return Container(
                width: width,
                height: 200,
                alignment: Alignment.center,
                child: const Text('Không có giao dịch nào'),
              );
            }
          }
          return (transactions.isEmpty)
              ? const SizedBox()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(
                          tooltip:
                              'Số thứ tự được sắp xếp theo giao dịch mới nhất',
                          label: _buildLabel('No.'),
                        ),
                        DataColumn(
                          label: _buildLabel('Giao dịch (VND)'),
                        ),
                        DataColumn(
                          label: _buildLabel('Trạng thái'),
                        ),
                        DataColumn(
                          label: _buildLabel('Thời gian'),
                        ),
                        DataColumn(
                          label: _buildLabel('Nội dung'),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        transactions.length,
                        (int index) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                (index + 1).toString(),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${TransactionUtils.instance.getTransType(transactions[index].transType)} ${CurrencyUtils.instance.getCurrencyFormatted(transactions[index].amount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      TransactionUtils.instance.getColorStatus(
                                    transactions[index].status,
                                    transactions[index].type,
                                    transactions[index].transType,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                TransactionUtils.instance.getStatusString(
                                    transactions[index].status),
                              ),
                            ),
                            DataCell(
                              Text(
                                TimeUtils.instance.formatDateFromInt(
                                    transactions[index].time, false),
                              ),
                            ),
                            DataCell(
                              Text(
                                transactions[index].content,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  void _resetBank() {
    bankAccounts.clear();
    cardColors.clear();
    Provider.of<MenuCardProvider>(context, listen: false).reset();
  }

  void _resetTransaction() {
    transactions.clear();
    Provider.of<TransactionListProvider>(context, listen: false).reset();
  }
}
