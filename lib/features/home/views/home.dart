import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/views/link_card_view.dart';
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
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/add_bank_provider.dart';
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

class HomeScreen extends StatefulWidget {
  final BankBloc bankBloc;
  final TransactionBloc transactionBloc;
  const HomeScreen(
      {super.key, required this.transactionBloc, required this.bankBloc});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late TokenBloc _tokenBloc;
  int currentPage = 0;
  List<BankAccountDTO> bankAccounts = [];
  List<Color> cardColors = [];

  late WebSocketChannel channel;

  List<RelatedTransactionReceiveDTO> transactions = [];

  @override
  void initState() {
    super.initState();
    String userId = UserInformationHelper.instance.getUserId();
    _tokenBloc = BlocProvider.of(context);
    _tokenBloc.add(const TokenEventCheckValid());

    widget.bankBloc.add(BankEventGetList(userId: userId));
    Session.instance.registerEventListener(EventTypes.refreshListAccountBank,
        () {
      widget.bankBloc.add(BankEventGetList(userId: userId));
    });
    Session.instance.registerEventListener(EventTypes.refreshListTransaction,
        () {
      widget.transactionBloc.add(TransactionEventGetList(
          dto: TransactionInputDTO(
              bankId: Provider.of<MenuCardProvider>(context, listen: false)
                  .bankDetailDTO
                  .id,
              offset: currentPage)));
    });
    Session.instance.fetchWallet();
    Session.instance.fetchAccountSetting();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void selectRow(String id) {
    DialogWidget.instance.openPopup(
      child: TransactionDetailView(
        transactionId: id,
      ),
      width: 500,
      height: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return BlocListener<TokenBloc, TokenState>(
      listener: (context, state) {
        // if (state is TokenValidState) {
        //   _updateFcmToken(isFromLogin);
        // }
        if (state is SystemMaintainState) {
          DialogWidget.instance.openPopup(
            child: MaintainWidget(
              tokenBloc: _tokenBloc,
              width: 500,
              height: 500,
            ),
            width: 500,
            height: 500,
          );
        }
        if (state is SystemConnectionFailedState) {
          DialogWidget.instance.openPopup(
            child: DisconnectWidget(
              tokenBloc: _tokenBloc,
              width: 500,
              height: 500,
            ),
            width: 500,
            height: 500,
          );
        }
        if (state is TokenExpiredState) {
          DialogWidget.instance.openMsgDialog(
              title: 'Phiên đăng nhập hết hạn',
              msg: 'Vui lòng đăng nhập lại ứng dụng',
              function: () {
                Navigator.pop(context);
                _tokenBloc.add(TokenEventLogout());
              });
        }
        if (state is TokenExpiredLogoutState) {
          context.push('/login');
        }
        if (state is TokenLogoutFailedState) {
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể đăng xuất',
            msg: 'Vui lòng thử lại sau.',
          );
        }
      },
      child: HomeFrame(
        widget1: Column(
          children: [
            _buildTableRow(),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                  width: 200,
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
                                        currentPage = prevPage;
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

                                        widget.transactionBloc.add(
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
                                        currentPage = prevPage;
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
                                          offset: prevPage,
                                        );
                                        widget.transactionBloc.add(
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
                                        currentPage = nextPage;
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
                                        widget.transactionBloc.add(
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
        widget2: _buildGenQRCode(),
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
                              SelectableText(
                                (index + 1).toString(),
                              ),
                            ),
                            DataCell(
                                SelectableText(
                                  '${TransactionUtils.instance.getTransType(transactions[index].transType)} ${CurrencyUtils.instance.getCurrencyFormatted(transactions[index].amount)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: TransactionUtils.instance
                                        .getColorStatus(
                                      transactions[index].status,
                                      transactions[index].type,
                                      transactions[index].transType,
                                    ),
                                  ),
                                ), onTap: () {
                              selectRow(transactions[index].transactionId);
                            }),
                            DataCell(
                                SelectableText(
                                  TransactionUtils.instance.getStatusString(
                                      transactions[index].status),
                                ), onTap: () {
                              selectRow(transactions[index].transactionId);
                            }),
                            DataCell(
                                SelectableText(
                                  TimeUtils.instance.formatDateFromInt(
                                      transactions[index].time, false),
                                ), onTap: () {
                              selectRow(transactions[index].transactionId);
                            }),
                            DataCell(
                                SelectableText(
                                  transactions[index].content,
                                ), onTap: () {
                              selectRow(transactions[index].transactionId);
                            }),
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
    return SelectableText(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Widget _buildGenQRCode() {
    return Consumer<MenuCardProvider>(
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
                      height: 600,
                      hasBgNapas: true,
                      qrGeneratedDTO: provider.qrGeneratedDTO,
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
                              function: () {
                                String paramData = Session.instance
                                    .formatDataParamUrl(provider.qrGeneratedDTO,
                                        action: 'PRINT');
                                html.window.open(
                                    Uri.base.toString().replaceFirst(
                                        '/home', '/qr_generate$paramData'),
                                    'new tab');
                              },
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
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
                              function: () {
                                Provider.of<ActionShareProvider>(context,
                                        listen: false)
                                    .updateAction(false);
                                String paramData = Session.instance
                                    .formatDataParamUrl(provider.qrGeneratedDTO,
                                        action: 'SAVE');
                                html.window.open(
                                    Uri.base.toString().replaceFirst(
                                        '/home', '/qr_generate$paramData'),
                                    'new tab');
                              },
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
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
                              function: () async {
                                await FlutterClipboard.copy(ShareUtils.instance
                                        .getTextSharing(
                                            provider.qrGeneratedDTO))
                                    .then(
                                  (value) => Fluttertoast.showToast(
                                    msg: 'Đã sao chép',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: DefaultTheme.WHITE,
                                    textColor: DefaultTheme.BLACK,
                                    fontSize: 15,
                                    webBgColor: 'rgba(255, 255, 255)',
                                    webPosition: 'center',
                                  ),
                                );
                              },
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
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
                        bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                        textColor: DefaultTheme.BLUE_TEXT,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  UnconstrainedBox(
                    child: SizedBox(
                      width: 350,
                      child: Row(
                        children: [
                          if (!provider.bankDetailDTO.authenticated &&
                              provider.bankDetailDTO.bankTypeStatus == 1 &&
                              provider.bankDetailDTO.userId ==
                                  UserInformationHelper.instance
                                      .getUserId()) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Tooltip(
                                  message: 'Liên kết ngay',
                                  child: ButtonWidget(
                                    height: 40,
                                    textColor: DefaultTheme.WHITE,
                                    bgColor: DefaultTheme.BLUE_CARD,
                                    borderRadius: 3,
                                    function: () {
                                      BankTypeDTO bankTypeDTO = BankTypeDTO(
                                          id: provider.bankDetailDTO.bankTypeId,
                                          bankCode:
                                              provider.bankDetailDTO.bankCode,
                                          bankName:
                                              provider.bankDetailDTO.bankName,
                                          imageId: provider.bankDetailDTO.imgId,
                                          status: provider
                                              .bankDetailDTO.bankTypeStatus,
                                          caiValue:
                                              provider.bankDetailDTO.caiValue,
                                          bankShortName:
                                              provider.bankDetailDTO.bankName);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateBankId(
                                              provider.bankDetailDTO.id);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateSelect(2);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateRegisterAuthentication(true);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateSelectBankType(bankTypeDTO);
                                      DialogWidget.instance.openPopup(
                                        child: AddBankCardView(
                                          bankAccount: provider
                                              .bankDetailDTO.bankAccount,
                                          userBankName: provider
                                              .bankDetailDTO.userBankName,
                                        ),
                                        height: 600,
                                        width: 760,
                                      );
                                    },
                                    text: 'Liên kết ngay',
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Expanded(
                            child: Tooltip(
                              message: 'Chi tiết TK ngân hàng',
                              child: ButtonIconWidget(
                                height: 40,
                                icon: Icons.info_outline_rounded,
                                title: 'Chi tiết',
                                function: () {
                                  DialogWidget.instance.openPopup(
                                    child: BankDetailWidget(
                                      accountBankDetailDTO:
                                          provider.bankDetailDTO,
                                      qrGeneratedDTO: provider.qrGeneratedDTO,
                                      bankBloc: widget.bankBloc,
                                    ),
                                    width: 760,
                                    height: 450,
                                  );
                                },
                                bgColor: Theme.of(context)
                                    .canvasColor
                                    .withOpacity(0.3),
                                textColor: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  void _resetTransaction() {
    transactions.clear();
    Provider.of<TransactionListProvider>(context, listen: false).reset();
  }
}
