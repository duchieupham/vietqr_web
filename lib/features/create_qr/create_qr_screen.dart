import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/env_type.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/create_qr/blocs/create_qr_bloc.dart';
import 'package:VietQR/features/create_qr/frame/create_qr_frame.dart';
import 'package:VietQR/features/create_qr/provider/create_qr_provider.dart';
import 'package:VietQR/features/create_qr/states/create_qr_state.dart';
import 'package:VietQR/features/create_qr/widget/calculator_view.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/qr_create_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../commons/utils/image_utils.dart';
import 'event/create_qr_event.dart';

class CreateQrScreen extends StatefulWidget {
  final String bankAccountId;

  const CreateQrScreen({super.key, this.bankAccountId = ''});

  @override
  State<CreateQrScreen> createState() => _CreateQrScreenState();
}

class _CreateQrScreenState extends State<CreateQrScreen> {
  late CreateQRBloc createQRBloc;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  List<BankAccountDTO> bankAccounts = [];
  List<Color> colors = [];
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeContent = FocusNode();
  FocusNode focusNodeWidget = FocusNode();
  AccountBankDetailDTO bankDetailDTO = const AccountBankDetailDTO(
    businessDetails: [],
    transactions: [],
  );
  int focusKeyBroadListen = 0;
  bool showDialog = false;
  int indexBankAccount = 0;
  bool focusAmount = false;
  @override
  void initState() {
    createQRBloc = CreateQRBloc()..add(GetListBankAccount());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(focusNodeWidget);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateQRProvider>(
      create: (context) => CreateQRProvider(),
      child: BlocProvider<CreateQRBloc>(
        create: (context) => createQRBloc,
        child: BlocConsumer<CreateQRBloc, CreateQRState>(
            listener: (context, state) {
          if (state is GetListBankAccountSuccessfulState) {
            bankAccounts = state.list;
            colors = state.colors;
            if (widget.bankAccountId.isNotEmpty) {
              createQRBloc
                  .add(BankEventGetDetail(bankId: widget.bankAccountId));
              for (var bank in bankAccounts) {
                if (bank.id == widget.bankAccountId) {
                  context.read<CreateQRProvider>().updateBankAccountDto(bank);
                }
              }
            } else {
              context
                  .read<CreateQRProvider>()
                  .updateBankAccountDto(bankAccounts.first);
            }
          }
          if (state is BankDetailSuccessState) {
            bankDetailDTO = state.dto;
            if (widget.bankAccountId.isNotEmpty) {}
          }
          if (state is QRGenerateSuccessState) {
            if (EnvConfig.getEnv() == EnvType.PROD) {
              if (widget.bankAccountId.isNotEmpty) {
                html.window.open(
                    Uri.base.toString().replaceFirst(
                        '/create-qr/${widget.bankAccountId}',
                        '/qr-generated?token=${state.dto.transactionRefId}'),
                    'new tab');
              } else {
                html.window.open(
                    Uri.base.toString().replaceFirst('/create-qr',
                        '/qr-generated?token=${state.dto.transactionRefId}'),
                    'new tab');
              }

              // context.go('/qr-generated?token=${state.dto.transactionRefId}',
              //     extra: true);
            } else {
              if (widget.bankAccountId.isNotEmpty) {
                html.window.open(
                    Uri.base.toString().replaceFirst(
                        '/create-qr/${widget.bankAccountId}',
                        '/test/qr-generated?token=${state.dto.transactionRefId}'),
                    'new tab');
              } else {
                html.window.open(
                    Uri.base.toString().replaceFirst('/create-qr',
                        '/test/qr-generated?token=${state.dto.transactionRefId}'),
                    'new tab');
              }

              // context.go(
              //     '/test/qr-generated?token=${state.dto.transactionRefId}',
              //     extra: true);
            }
          }
        }, builder: (context, state) {
          return RawKeyboardListener(
            focusNode: focusNodeWidget,
            autofocus: false,
            onKey: (RawKeyEvent event) {
              if (event.data.keyLabel == '*') {
                context.push('/home');
              }

              focusKeyBroadListen++;

              if (focusKeyBroadListen == 1) {
                indexBankAccount =
                    bankAccounts.indexOf(bankAccounts[indexBankAccount]);

                if (event.data.keyLabel == '+') {
                  if (indexBankAccount == bankAccounts.length - 1) {
                    indexBankAccount = -1;
                  }
                  indexBankAccount++;
                  context
                      .read<CreateQRProvider>()
                      .updateBankAccountDto(bankAccounts[indexBankAccount]);
                  createQRBloc.add(BankEventGetDetail(
                      bankId: bankAccounts[indexBankAccount].id));
                }

                if (event.data.keyLabel == '-') {
                  if (indexBankAccount == 0) {
                    indexBankAccount = bankAccounts.length;
                    indexBankAccount--;
                  } else {
                    indexBankAccount--;
                  }

                  context
                      .read<CreateQRProvider>()
                      .updateBankAccountDto(bankAccounts[indexBankAccount]);
                  createQRBloc.add(BankEventGetDetail(
                      bankId: bankAccounts[indexBankAccount].id));
                }
                if (!focusAmount) {
                  if (event.logicalKey == LogicalKeyboardKey.enter) {
                    FocusScope.of(context).requestFocus(focusNode);
                    focusAmount = true;
                  }
                }
              }

              if (focusKeyBroadListen == 2) {
                focusKeyBroadListen = 0;
              }
            },
            child: CreateQRFrame(
              widget1: _buildListBank(),
              widget2: _formCreate(),
              // widget3: _buildQRcode(state),
            ),
          );
        }),
      ),
    );
  }

  Widget _formCreate() {
    return Consumer<CreateQRProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Thông tin tạo mã VietQR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      'Số tiền*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Column(
                      children: [
                        BorderLayout(
                          height: 50,
                          isError: provider.amountErr,
                          bgColor: AppColor.WHITE,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  isObscureText: false,
                                  autoFocus: true,
                                  focusNode: focusNode,
                                  hintText: 'VD: 50,000',
                                  fontSize: 12,
                                  value: provider.money,
                                  inputType: TextInputType.number,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardAction: TextInputAction.done,
                                  onChange: (value) {
                                    if (showDialog) {
                                      Navigator.pop(context);
                                      showDialog = false;
                                    }
                                    provider.updateMoney(value.toString());
                                    if (provider.money.isNotEmpty) {
                                      if (provider.money == '0') {
                                        provider.updateValidCreate(true);
                                        provider.updateAmountErr(false);
                                      } else if (provider.money
                                              .replaceAll(',', '')
                                              .length >=
                                          4) {
                                        provider.updateValidCreate(true);
                                        provider.updateAmountErr(false);
                                      } else {
                                        provider.updateValidCreate(false);
                                        provider.updateAmountErr(true);
                                      }
                                    } else {
                                      provider.updateAmountErr(false);
                                      provider.updateValidCreate(true);
                                    }
                                  },
                                  onSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeContent);
                                  },
                                ),
                              ),
                              const Text(
                                'VND',
                                style: TextStyle(fontSize: 12),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 20)),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        if (provider.amountErr)
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Số tiền không đúng định dạng',
                              style: TextStyle(
                                color: AppColor.RED_CALENDAR,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24)),
                    const Text(
                      'Nội dung thanh toán',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    BorderLayout(
                      height: 50,
                      isError: false,
                      bgColor: AppColor.WHITE,
                      child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: false,
                        focusNode: focusNodeContent,
                        hintText: 'Nội dung thanh toán tối đa 50 ký tự',
                        fontSize: 12,
                        maxLength: 50,
                        controller: contentController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.done,
                        onChange: (vavlue) {},
                        onSubmitted: (value) {
                          String amount = '0';
                          if (provider.money.isNotEmpty) {
                            amount = provider.money.replaceAll(',', '');
                          }

                          if (provider.bankAccountDTO.id.isEmpty) {
                            if (showDialog) {
                              Navigator.pop(context);
                              showDialog = false;
                            } else {
                              showDialog = true;
                              DialogWidget.instance.openMsgDialog(
                                  title: 'TK ngân hàng không hợp lệ',
                                  msg: 'Vui lòng chọn tài khoản ngân hàng');
                            }
                          } else if (provider.bankAccountDTO.id.isNotEmpty) {
                            QRCreateDTO qrCreateDTO = QRCreateDTO(
                              bankId: bankDetailDTO.id,
                              amount: amount,
                              content: StringUtils.instance
                                  .removeDiacritic(contentController.text),
                              branchId:
                                  (bankDetailDTO.businessDetails.isNotEmpty)
                                      ? bankDetailDTO.businessDetails.first
                                          .branchDetails.first.branchId
                                      : '',
                              businessId:
                                  (bankDetailDTO.businessDetails.isNotEmpty)
                                      ? bankDetailDTO
                                          .businessDetails.first.businessId
                                      : '',
                              userId:
                                  UserInformationHelper.instance.getUserId(),
                            );

                            createQRBloc.add(QREventGenerate(dto: qrCreateDTO));
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildChoiceChip(
                            context,
                            'Thanh toan',
                          ),
                          _buildChoiceChip(
                            context,
                            'Chuyen khoan den ${bankDetailDTO.bankAccount}',
                          ),
                          if (bankDetailDTO.businessDetails?.isNotEmpty ??
                              false) ...[
                            _buildChoiceChip(
                              context,
                              'Thanh toan cho ${bankDetailDTO.businessDetails!.first.businessName}',
                            ),
                            _buildChoiceChip(
                              context,
                              'Giao dich ${bankDetailDTO.businessDetails!.first.branchDetails.first.branchName}',
                            ),
                          ],
                          if (bankDetailDTO.type == 0) ...[
                            _buildChoiceChip(
                              context,
                              'Chuyen khoan cho ${bankDetailDTO.userBankName}',
                            ),
                            _buildChoiceChip(
                              context,
                              'Giao dich ngay ${TimeUtils.instance.formatDate(DateTime.now().toString())}',
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24)),
                    const Text(
                      'Đính kèm nội dung',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: _buildTemplateSubButton('Tải tệp đính kèm', () {
                        DialogWidget.instance.openMsgQRInstallApp();
                      }, Icons.file_open),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24)),
                    const Text(
                      'Công cụ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        runSpacing: 12,
                        spacing: 12,
                        children: [
                          _buildTemplateSubButton('Máy tính', () {
                            DialogWidget.instance.openPopup(
                              width: 400,
                              height: 560,
                              child: CalculatorScreen(
                                onSubmit: (vale) {
                                  double money = double.parse(vale);

                                  provider.updateMoneyFormCalculator(
                                      money.round().toString());
                                },
                              ),
                            );
                          }, Icons.calculate_outlined),
                          _buildTemplateSubButton('Quét QR/Barcode nội dung',
                              () {
                            DialogWidget.instance.openMsgQRInstallApp();
                          }, Icons.qr_code_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ButtonIconWidget(
                height: 40,
                icon: Icons.add_rounded,
                title: 'Tạo mã VietQR',
                function: () {
                  if (provider.bankAccountDTO.id.isEmpty) {
                    showDialog = true;
                    DialogWidget.instance.openMsgDialog(
                        title: 'TK ngân hàng không hợp lệ',
                        msg: 'Vui lòng chọn tài khoản ngân hàng');
                  } else if (provider.amountErr) {
                    showDialog = true;
                    DialogWidget.instance.openMsgDialog(
                        title: 'Số tiền không hợp lệ',
                        msg: 'Vui lòng nhập số tiền');
                  } else {
                    String amount = '0';
                    if (provider.money.isNotEmpty) {
                      amount = provider.money.replaceAll(',', '');
                    }

                    if (provider.bankAccountDTO.id.isNotEmpty) {
                      QRCreateDTO qrCreateDTO = QRCreateDTO(
                        bankId: bankDetailDTO.id,
                        amount: amount,
                        content: StringUtils.instance
                            .removeDiacritic(contentController.text),
                        branchId: (bankDetailDTO.businessDetails.isNotEmpty)
                            ? bankDetailDTO.businessDetails.first.branchDetails
                                .first.branchId
                            : '',
                        businessId: (bankDetailDTO.businessDetails.isNotEmpty)
                            ? bankDetailDTO.businessDetails.first.businessId
                            : '',
                        userId: UserInformationHelper.instance.getUserId(),
                      );

                      createQRBloc.add(QREventGenerate(dto: qrCreateDTO));
                    }
                  }
                },
                bgColor: AppColor.BLUE_TEXT,
                textColor: AppColor.WHITE,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListBank() {
    String userId = UserInformationHelper.instance.getUserId();

    return Consumer<CreateQRProvider>(
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
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(bankAccounts.length, (index) {
                      BankAccountDTO dto = bankAccounts[index];
                      return GestureDetector(
                        onTap: () async {
                          provider.updateBankAccountDto(dto);
                          createQRBloc.add(BankEventGetDetail(bankId: dto.id));
                          // _bloc.add(BankCardGetDetailEvent(bankId: dto.id));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: provider.bankId == dto.id
                                ? colors[index]
                                : AppColor.WHITE,
                            border: Border.all(color: AppColor.GREY_BUTTON),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitleCard(dto, userId,
                                  isSelect: provider.bankId == dto.id),
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
            border: Border.all(color: AppColor.GREY_BUTTON),
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
        const Icon(
          Icons.arrow_forward,
          color: AppColor.WHITE,
          size: 16,
        )
      ],
    );
  }

  Widget _buildChoiceChip(
    BuildContext context,
    String text,
    // ValueChanged<Object>? onTap,
  ) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: () {
          contentController.clear();
          contentController.value = contentController.value.copyWith(
            text: text.toString(),
          );
          // return onTap!(text);
        },
        focusNode: null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColor.BLUE_TEXT),
            color: AppColor.BLUE_TEXT.withOpacity(0.3),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateSubButton(
      String text, VoidCallback onTab, IconData iconData) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: onTab,
        focusNode: null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.BLUE_TEXT.withOpacity(0.3),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                iconData,
                color: AppColor.BLUE_TEXT,
                size: 18,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
