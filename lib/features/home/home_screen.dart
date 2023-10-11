import 'dart:html' as html;
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/home/blocs/home_bloc.dart';
import 'package:VietQR/features/home/blocs/home_provider.dart';
import 'package:VietQR/features/home/event/home_event.dart';
import 'package:VietQR/features/home/states/home_state.dart';
import 'package:VietQR/features/home/views/home_frame.dart';
import 'package:VietQR/features/home/views/info_account_view.dart';
import 'package:VietQR/features/transaction/widgets/transaction_detail_view.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late HomeBloc _bloc;
  late WebSocketChannel channel;

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
    Session.instance.fetchAccountSetting();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectRow(String id) {
    DialogWidget.instance.openPopup(
      child: TransactionDetailView(transactionId: id),
      width: 500,
      height: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
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
      },
      builder: (context, state) {
        return HomeFrame(
          home: _buildHome(),
          listBank: _buildListBank(state.listBanks),
          infoAccount: _buildInfoAccount(dto, qrGeneratedDTO),
        );
      },
    );
  }

  Widget _buildHome() {
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
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Số dư: ',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: '20,000 VQR',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.visibility,
                  size: 20,
                ),
                const Spacer(),
                const Text(
                  '110',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Image.asset(
                  'assets/images/ic-point.png',
                  height: 20,
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const ServiceSection(),
        ],
      ),
    );
  }

  Widget _buildListBank(List<BankAccountDTO> list) {
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
                onTap: () async {},
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
                          Image.asset(
                            'assets/images/ic-card-blue.png',
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
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(list.length, (index) {
                      BankAccountDTO dto = list[index];
                      return GestureDetector(
                        onTap: () async {
                          provider.onChangeBankId(dto.id);
                          _bloc.add(BankCardGetDetailEvent(bankId: dto.id));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: provider.bankId == dto.id
                                ? AppColor.BLUE_TEXT
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
                                        decoration: TextDecoration.underline),
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
          padding: EdgeInsets.only(top: 10, right: 6),
          child: Icon(
            Icons.arrow_forward_ios,
            color: AppColor.WHITE,
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoAccount(AccountBankDetailDTO dto, QRGeneratedDTO qrDTO) {
    String bankId = Provider.of<HomeProvider>(context, listen: false).bankId;
    return InfoDetailBankAccount(
      refresh: () async {},
      dto: dto,
      qrGeneratedDTO: qrDTO,
      bankId: bankId,
    );
  }
}
