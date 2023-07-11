import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'dart:html' as html;
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_open_bank_account.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'dart:js' as js;
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/views/link_card_view.dart';
import 'package:VietQR/features/bank/widgets/detail_bank_widget.dart';
import 'package:VietQR/features/home/frames/home_frame.dart';
import 'package:VietQR/features/home/widget/card_wallet.dart';
import 'package:VietQR/features/home/widget/menu_left.dart';
import 'package:VietQR/features/home/widget/popup_confirm_logout.dart';
import 'package:VietQR/features/information_user/widget/popup_share_code.dart';
import 'package:VietQR/features/setting/widgets/theme_setting_widget.dart';
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
import 'package:VietQR/services/providers/menu_provider.dart';
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
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late BankBloc _bankBloc;
  late TransactionBloc _transactionBloc;
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
    _bankBloc = BlocProvider.of(context);
    _tokenBloc.add(const TokenEventCheckValid());
    _transactionBloc = BlocProvider.of(context);

    _bankBloc.add(BankEventGetList(userId: userId));
    Session.instance.registerEventListener(EventTypes.refreshListAccountBank,
        () {
      _bankBloc.add(BankEventGetList(userId: userId));
    });
    Session.instance.registerEventListener(EventTypes.refreshListTransaction,
        () {
      _transactionBloc.add(TransactionEventGetList(
          dto: TransactionInputDTO(
              bankId: Provider.of<MenuCardProvider>(context, listen: false)
                  .bankDetailDTO
                  .id,
              offset: currentPage)));
    });
    Session.instance.fetchWallet();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Session.instance.registerEventListener(EventTypes.refreshListTransaction,
        () {
      _transactionBloc.add(TransactionEventGetList(
          dto: TransactionInputDTO(
              bankId: Provider.of<MenuCardProvider>(context, listen: false)
                  .bankDetailDTO
                  .id,
              offset: currentPage)));
    });
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

  handleOnTabMenu(MenuHomeType type) {
    switch (type) {
      case MenuHomeType.HOME:
        break;

      case MenuHomeType.INTRO_VIET_QR:
        DialogWidget.instance.openPopup(
          width: 500,
          height: 300,
          child: const PopupShareCode(),
        );
        break;

      case MenuHomeType.CONTACT:
        DialogWidget.instance.openMsgDialog(
          title: 'Tính năng đang bảo trì',
          msg: 'Vui lòng thử lại sau',
        );
        break;

      case MenuHomeType.SCAN_CCCD:
        DialogWidget.instance.openMsgDialog(
          title: 'Tính năng đang bảo trì',
          msg: 'Vui lòng thử lại sau',
        );
        break;

      case MenuHomeType.SCAN_BANK:
        DialogWidget.instance.openMsgDialog(
          title: 'Tính năng đang bảo trì',
          msg: 'Vui lòng thử lại sau',
        );
        break;
      case MenuHomeType.BUSINESS:
        context.go('/business_manager');
        break;
      case MenuHomeType.BANKLIST:
        bool showCardMenu =
            Provider.of<MenuCardProvider>(context, listen: false).showMenu;
        Provider.of<MenuCardProvider>(context, listen: false)
            .updateShowMenu(!showCardMenu);
        break;

      case MenuHomeType.ADD_LINK_BANK_ACCOUNT:
        String userId = UserInformationHelper.instance.getUserId();
        context.go('/bank/create/$userId');
        break;

      case MenuHomeType.ADD_LINK_BANK_MB:
        DialogWidget.instance.openPopup(
          child: const DialogOpenBankAccount(),
          width: 500,
          height: 650,
        );
        break;

      case MenuHomeType.OPEN_BANK_MB_ACCOUNT:
        DialogWidget.instance.openPopup(
          child: const DialogOpenBankAccount(),
          width: 500,
          height: 650,
        );
        break;
      case MenuHomeType.SETTING:
        DialogWidget.instance.openPopup(
          width: 600,
          height: 350,
          child: const ThemeSettingWidget(),
        );
        break;

      case MenuHomeType.LOGOUT:
        DialogWidget.instance.openPopup(
          width: 300,
          height: 200,
          child: const PopupConfirmLogout(),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocListener<TokenBloc, TokenState>(
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
          widget2: _buildGenQRCode(),
          menu: MenuLeft(
            onTab: (menuType) {
              print('------------------------ $menuType');
              handleOnTabMenu(menuType);
            },
          ),
          menuCard: _buildCardATM(context),
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
                                    bgColor: DefaultTheme.GREEN,
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
                                      bankBloc: _bankBloc,
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

  Widget _buildCardATM(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<BankBloc, BankState>(
      listener: (context, state) {
        if (state is BankRemoveLoadingState) {
          Navigator.pop(context);
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is BankRemoveSuccessState) {
          String userId = UserInformationHelper.instance.getUserId();
          Navigator.pop(context);
          _bankBloc.add(BankEventGetList(userId: userId));
        }
        if (state is BankRemoveFailedState) {
          Navigator.pop(context);
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể xoá tài khoản',
            msg: state.message,
          );
        }
        if (state is BankGetListSuccessState) {
          _resetBank();
          if (bankAccounts.isEmpty) {
            bankAccounts.addAll(state.list);
            cardColors.addAll(state.colors);
            if (state.list.isNotEmpty) {
              TransactionInputDTO transactionInputDTO = TransactionInputDTO(
                bankId: bankAccounts.first.id,
                offset: 0,
              );
              _bankBloc.add(BankEventGetDetail(bankId: bankAccounts.first.id));
              _transactionBloc
                  .add(TransactionEventGetList(dto: transactionInputDTO));
            }
          }
        }
        if (state is BankDetailSuccessState) {
          Provider.of<MenuCardProvider>(context, listen: false)
              .updateBankDetail(state.dto);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: WalletCard(),
              ),
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
                      bgColor: DefaultTheme.CARD_MY_QR.withOpacity(0.5),
                      child: Text(
                        bankAccounts.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: DefaultTheme.BLUE_TEXT,
                        ),
                      ),
                    ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Expanded(child: Consumer<MenuCardProvider>(
                builder: (context, provider, child) {
                  return (bankAccounts.isEmpty &&
                          (state is BankGetListSuccessState ||
                              state is BankDetailSuccessState))
                      ? SizedBox(
                          width: width - 60,
                          // borderRadius: 15,
                          // alignment: Alignment.center,
                          // bgColor: DefaultTheme.TRANSPARENT,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/ic-card.png',
                                width: width * 0.4,
                                height: 150,
                              ),
                              const Text(
                                'Chưa có tài khoản ngân hàng được thêm.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              UnconstrainedBox(
                                child: Tooltip(
                                  message: 'Thêm TK ngân hàng',
                                  child: ButtonIconWidget(
                                    width: 300,
                                    height: 40,
                                    icon: Icons.add_rounded,
                                    title: 'Thêm TK ngân hàng',
                                    function: () {
                                      String userId = UserInformationHelper
                                          .instance
                                          .getUserId();
                                      context.go('/bank/create/$userId');
                                    },
                                    bgColor: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(0.3),
                                    textColor: DefaultTheme.GREEN,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                            ],
                          ),
                        )
                      : (bankAccounts.isEmpty)
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
                                    Provider.of<TransactionListProvider>(
                                            context,
                                            listen: false)
                                        .reset();
                                    TransactionInputDTO transactionInputDTO =
                                        TransactionInputDTO(
                                      bankId: bankAccounts[index].id,
                                      offset: 0,
                                    );
                                    _transactionBloc.add(
                                        TransactionEventGetList(
                                            dto: transactionInputDTO));
                                    provider.updateShowMenu(false);
                                    // Provider.of<MenuProvider>(context,
                                    //         listen: false)
                                    //     .updateShowMenu(false);
                                  },
                                  child: AnimatedContainer(
                                    width: 300,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      border: (provider.index != index)
                                          ? Border.all(
                                              color: DefaultTheme.BLACK_LIGHT
                                                  .withOpacity(0.2))
                                          : null,
                                      boxShadow: (provider.index == index)
                                          ? [
                                              BoxShadow(
                                                color: DefaultTheme.GREY_TEXT
                                                    .withOpacity(0.5),
                                                spreadRadius: 0.6,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    0), // changes position of shadow
                                              ),
                                            ]
                                          : null,
                                      borderRadius: BorderRadius.circular(8),
                                      color: (provider.index == index)
                                          ? cardColors[index]
                                          : Theme.of(context).cardColor,
                                    ),
                                    child: SizedBox(
                                      width: 300,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: (provider.index != index)
                                                  ? Border.all(
                                                      color: DefaultTheme
                                                          .BLACK_LIGHT
                                                          .withOpacity(0.2))
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(60),
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${bankAccounts[index].bankCode} - ${bankAccounts[index].bankAccount}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color:
                                                              (provider.index ==
                                                                      index)
                                                                  ? DefaultTheme
                                                                      .WHITE
                                                                  : DefaultTheme
                                                                      .BLACK,
                                                          fontSize: 13),
                                                    ),
                                                    if (bankAccounts[index]
                                                        .isAuthenticated)
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 4),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          25)),
                                                          color: bankAccounts[
                                                                          index]
                                                                      .userId ==
                                                                  UserInformationHelper
                                                                      .instance
                                                                      .getUserId()
                                                              ? DefaultTheme
                                                                  .BLUE_CARD
                                                              : DefaultTheme
                                                                  .ORANGE,
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: DefaultTheme
                                                              .WHITE,
                                                          size: 7,
                                                        ),
                                                      )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  bankAccounts[index]
                                                      .userBankName
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: (provider.index ==
                                                            index)
                                                        ? DefaultTheme.WHITE
                                                        : DefaultTheme.BLACK,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (provider.index == index)
                                            const Text(
                                              'Đang chọn',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: DefaultTheme.WHITE),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                },
              )),
            ],
          ),
        );
      },
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
