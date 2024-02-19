import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/add_bank/blocs/bank_type_bloc.dart';
import 'package:VietQR/features/add_bank/events/list_bank_event.dart';
import 'package:VietQR/features/add_bank/states/list_bank_state.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/blocs/home_bloc.dart';
import 'package:VietQR/features/home/blocs/home_provider.dart';
import 'package:VietQR/features/home/event/home_event.dart';
import 'package:VietQR/features/home/frames/home_frame.dart';
import 'package:VietQR/features/home/provider/wallet_home_provider.dart';
import 'package:VietQR/features/home/states/home_state.dart';
import 'package:VietQR/features/home/views/info_account_view.dart';
import 'package:VietQR/features/transaction/widgets/transaction_detail_view.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../commons/enums/event_type.dart';
import 'widget/service_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(context),
      child: ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        child: _HomeScreen(),
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int currentPage = 0;
  List<BankAccountDTO> bankAccounts = [];
  List<Color> cardColors = [];
  List<BankTypeDTO> bankTypesResult = [];
  late HomeBloc _bloc;
  late WebSocketChannel channel;
  late ListBankBloc bankTypeBloc;

  late QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

  late AccountBankDetailDTO dto = const AccountBankDetailDTO(
    id: '',
    bankAccount: '',
    userBankName: '',
    bankCode: '',
    bankName: '',
    imgId: '',
    type: 0,
    userId: '',
    bankTypeId: '',
    bankTypeStatus: 0,
    nationalId: '',
    qrCode: '',
    phoneAuthenticated: '',
    businessDetails: [],
    transactions: [],
    authenticated: false,
    caiValue: '',
  );
  bool focusKeyBroadListen = false;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.add(BankCardEventGetList());
    Session.instance.registerEventListener(EventTypes.refreshListAccountBank,
        () {
      _bloc.add(BankCardEventGetList());
    });

    Session.instance.fetchWallet();
    // Session.instance.fetchAccountSetting();
    bankTypeBloc = ListBankBloc()..add(const BankTypeEventGetList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateBankAccount() {}

  void selectRow(String id) {
    DialogWidget.instance.openPopup(
      child: TransactionDetailView(transactionId: id),
      width: 500,
      height: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (focusKeyBroadListen) {
          if (event.data.keyLabel == '/') {
            context.go('/create-qr');
          }
        }
        focusKeyBroadListen = true;
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.request == BankType.GET_DETAIL) {
            if (state.bankDetailDTO != null) {
              dto = state.bankDetailDTO!;
            }
            qrGeneratedDTO = QRGeneratedDTO(
              bankCode: dto.bankCode,
              bankName: dto.bankName,
              bankAccount: dto.bankAccount,
              userBankName: dto.userBankName,
              amount: '',
              content: '',
              qrCode: dto.qrCode,
              imgId: dto.imgId,
            );
          }
          if (state.request == BankType.BANK) {
            if (state.listBanks.isNotEmpty) {
              context
                  .read<HomeProvider>()
                  .onChangeBankId(state.listBanks.first.id);
              _bloc.add(
                  BankCardGetDetailEvent(bankId: state.listBanks.first.id));
            } else {}
          }
        },
        builder: (context, state) {
          return HomeFrame(
            menu: const MenuLeft(
              currentType: MenuHomeType.HOME,
            ),
            widget1: _buildHome(),
            widget2: Expanded(
                flex: state.listBanks.isNotEmpty ? 1 : 2,
                child: _buildListBank(state.listBanks, state.colors)),
            widget3: state.listBanks.isEmpty
                ? const SizedBox(
                    width: 80,
                  )
                : Expanded(
                    child: _buildInfoAccount(dto, qrGeneratedDTO, state)),
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    return Consumer<WalletHomeProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Trang chủ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Số dư: ',
                          style: TextStyle(fontSize: 13, color: AppColor.BLACK),
                        ),
                        TextSpan(
                          text: provider.showAmount
                              ? '${CurrencyUtils.instance.getCurrencyFormatted(Session.instance.wallet.amount)} VQR'
                              : '********',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColor.BLACK),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () {
                      provider.changeShowAmount();
                    },
                    child: provider.showAmount
                        ? const Icon(
                            Icons.visibility,
                            size: 20,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            size: 20,
                          ),
                  ),
                  const Spacer(),
                  Text(
                    Session.instance.wallet.point,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Image(
                    image:
                        ImageUtils.instance.getImageNetWork(AppImages.icPoint),
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ServiceSection(),
          ],
        ),
      );
    });
  }

  Widget _buildListBank(List<BankAccountDTO> list, List<Color> colors) {
    String userId = UserInformationHelper.instance.getUserId();

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Danh sách TK ngân hàng',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  context.go('/add-bank/step1');
                },
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: ImageUtils.instance
                                .getImageNetWork(AppImages.icCardBlue),
                            height: 28,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 5)),
                          const Text(
                            'Thêm tài khoản ngân hàng',
                            style: TextStyle(
                              color: AppColor.BLUE_TEXT,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: list.isEmpty
                    ? _buildListBankBlank()
                    : SingleChildScrollView(
                        child: Column(
                          children: List.generate(list.length, (index) {
                            BankAccountDTO dto = list[index];
                            return GestureDetector(
                              onTap: () async {
                                provider.onChangeBankId(dto.id);
                                _bloc.add(
                                    BankCardGetDetailEvent(bankId: dto.id));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: provider.bankId == dto.id
                                      ? colors[index]
                                      : AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTitleCard(dto, userId,
                                        isSelect: provider.bankId == dto.id),
                                    if ((!dto.isAuthenticated &&
                                        dto.bankCode == 'MB' &&
                                        dto.userId == userId)) ...[
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {},
                                        child: const Text(
                                          'Liên kết tài khoản',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: AppColor.BLUE_TEXT,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleCard(BankAccountDTO dto, String userId,
      {bool isSelect = false}) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: ImageUtils.instance.getImageNetWork(
                dto.imgId,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${dto.bankCode} - ${dto.bankAccount}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelect ? AppColor.WHITE : AppColor.BLACK,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                if (dto.isAuthenticated)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: dto.userId == userId
                          ? AppColor.BLUE_TEXT
                          : AppColor.ORANGE,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColor.WHITE,
                      size: 8,
                    ),
                  ),
              ],
            ),
            Text(
              dto.userBankName.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isSelect ? AppColor.WHITE : AppColor.BLACK,
                  fontSize: 10,
                  height: 1.4),
            ),
          ],
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.only(top: 10, right: 6, bottom: 8),
          child: Icon(
            Icons.arrow_forward_ios,
            color: AppColor.WHITE,
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoAccount(
      AccountBankDetailDTO dto, QRGeneratedDTO qrDTO, HomeState state) {
    String bankId = Provider.of<HomeProvider>(context, listen: false).bankId;
    if (state.status == BlocStatus.LOADING) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: UnconstrainedBox(
            child: SizedBox(
                height: 32, width: 32, child: CircularProgressIndicator())),
      );
    }

    return InfoDetailBankAccount(
      refresh: () async {},
      dto: dto,
      fromUrl: '/home',
      qrGeneratedDTO: qrDTO,
      bankId: bankId,
    );
  }

  Widget _buildListBankBlank() {
    return BlocProvider<ListBankBloc>(
        create: (context) => bankTypeBloc,
        child: BlocConsumer<ListBankBloc, ListBankState>(
            listener: (context, state) {
          if (state is BankTypeGetListSuccessfulState) {
            if (state.list.isNotEmpty) {
              bankTypesResult = state.list;
              bankTypesResult.sort((a, b) {
                if (a.status == 1) {
                  return -1;
                } else if (b.status == 1) {
                  return 1;
                } else {
                  return 0;
                }
              });
            }
          }
        }, builder: (context, state) {
          if (state is BankTypeLoadingState) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SingleChildScrollView(
            child: Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: bankTypesResult.map((e) {
                  return _buildItemBank(e, () {
                    // provider.updateBankType(e);
                    context.go('/add-bank/step2?bankId=${e.id}');
                  }, isSelected: e.status == 1);
                }).toList(),
              ),
            ),
          );
        }));
  }

  Widget _buildItemBank(BankTypeDTO dto, VoidCallback onTap,
      {bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: Column(
              children: [
                Container(
                  width: 94,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.WHITE,
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(
                        dto.imageId,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  dto.bankShortName,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.check,
                  size: 10,
                  color: AppColor.WHITE,
                ),
              ),
            )
        ],
      ),
    );
  }
}
