import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_open_bank_account.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/views/add_bank_view.dart';
import 'package:VietQR/features/business/views/business_manager_view.dart';
import 'package:VietQR/features/home/frames/overview_frame.dart';
import 'package:VietQR/features/home/views/home.dart';
import 'package:VietQR/features/home/widget/card_wallet.dart';
import 'package:VietQR/features/home/widget/menu_left.dart';
import 'package:VietQR/features/home/widget/popup_confirm_logout.dart';
import 'package:VietQR/features/information_user/widget/popup_share_code.dart';
import 'package:VietQR/features/setting/widgets/popup_setting.dart';
import 'package:VietQR/features/setting/widgets/theme_setting_widget.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OverViewPage extends StatefulWidget {
  const OverViewPage({Key? key}) : super(key: key);

  @override
  State<OverViewPage> createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  late BankBloc _bankBloc;
  late TransactionBloc _transactionBloc;
  List<BankAccountDTO> bankAccounts = [];
  List<Color> cardColors = [];
  @override
  void initState() {
    super.initState();
    String userId = UserInformationHelper.instance.getUserId();
    _bankBloc = BlocProvider.of(context);
    _transactionBloc = BlocProvider.of(context);
  }

  void _resetBank() {
    bankAccounts.clear();
    cardColors.clear();
    Provider.of<MenuCardProvider>(context, listen: false).reset();
  }

  handleOnTabMenu(MenuHomeType type) {
    switch (type) {
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
      case MenuHomeType.BANKLIST:
        bool showCardMenu =
            Provider.of<MenuCardProvider>(context, listen: false).showMenu;
        Provider.of<MenuCardProvider>(context, listen: false)
            .updateShowMenu(!showCardMenu);
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
          width: 800,
          height: 650,
          child: const PopupSetting(),
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

  List<Widget> _getPage() {
    List<Widget> pages = [
      HomeScreen(
        transactionBloc: _transactionBloc,
        bankBloc: _bankBloc,
      ),
      AddBankView(
        userId: UserInformationHelper.instance.getUserId(),
      ),
      const BusinessManagerView()
    ];
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MenuProvider>(builder: (context, provider, child) {
        return OverViewFrame(
          page: Consumer<MenuProvider>(builder: (context, provider, child) {
            return _getPage()[provider.initPage];
          }),
          menu: MenuLeft(
            onTab: (menuType) {
              handleOnTabMenu(menuType);
            },
          ),
          menuCard: _buildCardATM(context),
        );
      }),
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

        if (state is BankGetListSuccessState) {
          _resetBank();
          if (bankAccounts.isEmpty) {
            bankAccounts.addAll(state.list);
            Session.instance.updateBankAccountsAuth(state.list);
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
        return SizedBox(
          width: 280,
          child: Padding(
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
                                  style: TextStyle(fontSize: 11),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                _buildButtonAddAccountBank(),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                              ],
                            ),
                          )
                        : (bankAccounts.isEmpty)
                            ? const SizedBox()
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: bankAccounts.length + 1,
                                      itemBuilder: (context, index) {
                                        ScrollController scrollController =
                                            ScrollController();
                                        scrollController.addListener(() {
                                          if (scrollController.hasClients) {
                                            scrollController.jumpTo(0);
                                          }
                                        });

                                        if (index == bankAccounts.length) {
                                          return const Text(
                                            'Nhấp chọn tài khoản để hiển thị giao dịch',
                                            style: TextStyle(fontSize: 10),
                                          );
                                        }
                                        return InkWell(
                                          onTap: () {
                                            Provider.of<MenuProvider>(context,
                                                    listen: false)
                                                .selectMenu(MenuHomeType.HOME);
                                            provider.updateShowMenu(false);
                                            provider.updateIndex(index);
                                            _bankBloc.add(BankEventGetDetail(
                                                bankId:
                                                    bankAccounts[index].id));
                                            TransactionInputDTO
                                                transactionInputDTO =
                                                TransactionInputDTO(
                                              bankId: bankAccounts[index].id,
                                              offset: 0,
                                            );
                                            _transactionBloc.add(
                                                TransactionEventGetList(
                                                    dto: transactionInputDTO));
                                            // Provider.of<MenuProvider>(context,
                                            //         listen: false)
                                            //     .updateShowMenu(false);
                                          },
                                          child: AnimatedContainer(
                                            width: 300,
                                            duration: const Duration(
                                                milliseconds: 100),
                                            curve: Curves.easeInOut,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              border: (provider.index != index)
                                                  ? Border.all(
                                                      color: DefaultTheme
                                                          .BLACK_LIGHT
                                                          .withOpacity(0.2))
                                                  : null,
                                              boxShadow: (provider.index ==
                                                      index)
                                                  ? [
                                                      BoxShadow(
                                                        color: DefaultTheme
                                                            .GREY_TEXT
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0.6,
                                                        blurRadius: 5,
                                                        offset: const Offset(0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ]
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                      border: (provider.index !=
                                                              index)
                                                          ? Border.all(
                                                              color: DefaultTheme
                                                                  .BLACK_LIGHT
                                                                  .withOpacity(
                                                                      0.2))
                                                          : null,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      color: DefaultTheme.WHITE,
                                                      image: DecorationImage(
                                                        image: ImageUtils
                                                            .instance
                                                            .getImageNetWork(
                                                          bankAccounts[index]
                                                              .imgId,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10)),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${bankAccounts[index].bankCode} - ${bankAccounts[index].bankAccount}',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: (provider
                                                                              .index ==
                                                                          index)
                                                                      ? DefaultTheme
                                                                          .WHITE
                                                                      : DefaultTheme
                                                                          .BLACK,
                                                                  fontSize: 13),
                                                            ),
                                                            _buildItemCheck(
                                                                bankAccounts[
                                                                    index],
                                                                isChoose: provider
                                                                        .index ==
                                                                    index)
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
                                                                ? DefaultTheme
                                                                    .WHITE
                                                                : DefaultTheme
                                                                    .BLACK,
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
                                                          color: DefaultTheme
                                                              .WHITE),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  _buildButtonAddAccountBank()
                                ],
                              );
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonAddAccountBank() {
    return UnconstrainedBox(
      child: Tooltip(
        message: 'Thêm TK ngân hàng',
        child: ButtonIconWidget(
          width: 245,
          height: 40,
          border: Border.all(color: DefaultTheme.BLUE_TEXT),
          pathIcon: AppImages.icMenuBank,
          title: 'Thêm/Liên kết TK ngân hàng',
          function: () {
            Provider.of<MenuCardProvider>(context, listen: false)
                .updateShowMenu(false);
            Provider.of<MenuProvider>(context, listen: false)
                .selectMenu(MenuHomeType.ADD_LINK_BANK_ACCOUNT);
          },
          bgColor: Theme.of(context).canvasColor.withOpacity(0.3),
          textSize: 11,
          pathIconSize: 28,
          textColor: DefaultTheme.BLUE_TEXT,
        ),
      ),
    );
  }

  Widget _buildItemCheck(BankAccountDTO accountDTO, {bool isChoose = false}) {
    if (accountDTO.isAuthenticated) {
      return Container(
        margin: const EdgeInsets.only(left: 4),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          color: accountDTO.userId == UserInformationHelper.instance.getUserId()
              ? DefaultTheme.BLUE_CARD
              : DefaultTheme.ORANGE,
        ),
        child: const Icon(
          Icons.check,
          color: DefaultTheme.WHITE,
          size: 7,
        ),
      );
    } else if (accountDTO.bankCode == 'MB' &&
        accountDTO.userId == UserInformationHelper.instance.getUserId() &&
        !isChoose) {
      return InkWell(
        onTap: () {
          Provider.of<MenuProvider>(context, listen: false)
              .selectMenu(MenuHomeType.ADD_LINK_BANK_ACCOUNT);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 2, top: 2),
          child: Text(
            'Liên kết ngay',
            style: TextStyle(
              fontSize: 9,
              color: DefaultTheme.BLUE_TEXT,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
