import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/qr/blocs/qr_bloc.dart';
import 'package:VietQR/features/qr/events/qr_event.dart';
import 'package:VietQR/features/qr/frames/create_qr_frame.dart';
import 'package:VietQR/features/qr/states/qr_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/qr_create_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/create_qr_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateQR extends StatelessWidget {
  final String bankId;
  late BankBloc _bankBloc;
  late QRBloc _qrBloc;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  FocusNode focusNode = FocusNode();

  AccountBankDetailDTO bankDetailDTO = const AccountBankDetailDTO(
    id: '',
    bankAccount: '',
    userBankName: '',
    bankCode: '',
    bankName: '',
    imgId: '58b7190b-a294-4b14-968f-cd365593893e',
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

  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
    bankCode: '',
    bankName: '',
    bankAccount: '',
    userBankName: '',
    amount: '',
    content: '',
    qrCode: '',
    imgId: '58b7190b-a294-4b14-968f-cd365593893e',
  );

  CreateQR({
    super.key,
    required this.bankId,
  });

  _initialServices(BuildContext context) {
    focusNode.requestFocus();
    _bankBloc = BlocProvider.of(context);
    _qrBloc = BlocProvider.of(context);
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<CreateQRProvider>(context, listen: false).reset();
    });
    if (bankId.trim().isNotEmpty) {
      _bankBloc.add(BankEventGetDetail(bankId: bankId));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    _initialServices(context);
    return Scaffold(
      body: BlocConsumer<BankBloc, BankState>(
        listener: (context, state) {
          if (state is BankDetailSuccessState) {
            bankDetailDTO = state.dto;
          }
        },
        builder: (context, state) {
          return (bankDetailDTO.id.isEmpty)
              ? const SizedBox()
              : CreateQRFrame(
                  widget1: [
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    BoxLayout(
                      width: 300,
                      height: 60,
                      borderRadius: 5,
                      enableShadow: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: DefaultTheme.WHITE,
                              image: DecorationImage(
                                image: ImageUtils.instance
                                    .getImageNetWork(bankDetailDTO.imgId),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bankDetailDTO.bankCode,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  bankDetailDTO.bankName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 30)),
                    _buildElementInfo(
                      context: context,
                      title: 'Tài khoản',
                      description: bankDetailDTO.bankAccount,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: DividerWidget(width: width),
                    ),
                    _buildElementInfo(
                      context: context,
                      title: 'Trạng thái',
                      description: (bankDetailDTO.authenticated)
                          ? 'Đã liên kết'
                          : 'Chưa liên kết',
                    ),
                    if (bankDetailDTO.businessDetails.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: DividerWidget(width: width),
                      ),
                      _buildElementInfo(
                        context: context,
                        title: 'Doanh nghiệp',
                        description:
                            bankDetailDTO.businessDetails.first.businessName,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: DividerWidget(width: width),
                      ),
                      _buildElementInfo(
                        context: context,
                        title: 'Chi nhánh',
                        description: bankDetailDTO.businessDetails.first
                            .branchDetails.first.branchName,
                      ),
                    ],
                  ],
                  widget2: [
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    const Text(
                      'Số tiền',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Consumer<CreateQRProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            BorderLayout(
                              width: width,
                              height: 50,
                              isError: provider.amountErr,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidget(
                                      width: width,
                                      isObscureText: false,
                                      autoFocus: true,
                                      focusNode: focusNode,
                                      hintText: 'VD: 50,000',
                                      fontSize: 12,
                                      controller: amountController,
                                      inputType: TextInputType.number,
                                      keyboardAction: TextInputAction.next,
                                      onChange: (vavlue) {
                                        if (amountController.text.isNotEmpty) {
                                          if (StringUtils.instance.isNumeric(
                                              amountController.text)) {
                                            provider.updateAmountErr(false);
                                            if (amountController.text.length >=
                                                4) {
                                              provider.updateValidCreate(true);
                                            } else {
                                              provider.updateValidCreate(false);
                                            }
                                          } else {
                                            provider.updateAmountErr(true);
                                            provider.updateValidCreate(false);
                                          }
                                        } else {
                                          provider.updateAmountErr(false);
                                          provider.updateValidCreate(false);
                                        }
                                      },
                                    ),
                                  ),
                                  const Text(
                                    'VND',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 20)),
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
                                    color: DefaultTheme.RED_CALENDAR,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    const Text(
                      'Nội dung thanh toán',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    BorderLayout(
                      width: width,
                      height: 50,
                      isError: false,
                      child: TextFieldWidget(
                        width: width,
                        isObscureText: false,
                        autoFocus: true,
                        hintText: 'Nội dung thanh toán tối đa 50 ký tự',
                        fontSize: 12,
                        maxLength: 50,
                        controller: contentController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.done,
                        onChange: (vavlue) {},
                        onSubmitted: (value) {
                          if (amountController.text.isNotEmpty &&
                              StringUtils.instance
                                  .isNumeric(amountController.text)) {
                            QRCreateDTO qrCreateDTO = QRCreateDTO(
                              bankId: bankDetailDTO.id,
                              amount: amountController.text,
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
                            _qrBloc.add(QREventGenerate(dto: qrCreateDTO));
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    const Text(
                      'Mẫu nội dung',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: width,
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
                          if (bankDetailDTO.businessDetails.isNotEmpty) ...[
                            _buildChoiceChip(
                              context,
                              'Thanh toan cho ${bankDetailDTO.businessDetails.first.businessName}',
                            ),
                            _buildChoiceChip(
                              context,
                              'Giao dich ${bankDetailDTO.businessDetails.first.branchDetails.first.branchName}',
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
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Consumer<CreateQRProvider>(
                      builder: (context, provider, child) {
                        return Container(
                          width: width,
                          alignment: Alignment.centerLeft,
                          child: (provider.isValidCreate)
                              ? ButtonIconWidget(
                                  width: 300,
                                  height: 40,
                                  icon: Icons.add_rounded,
                                  title: 'Tạo mã QR',
                                  function: () {
                                    if (amountController.text.isNotEmpty &&
                                        StringUtils.instance
                                            .isNumeric(amountController.text)) {
                                      QRCreateDTO qrCreateDTO = QRCreateDTO(
                                        bankId: bankDetailDTO.id,
                                        amount: amountController.text,
                                        content: StringUtils.instance
                                            .removeDiacritic(
                                                contentController.text),
                                        branchId: (bankDetailDTO
                                                .businessDetails.isNotEmpty)
                                            ? bankDetailDTO
                                                .businessDetails
                                                .first
                                                .branchDetails
                                                .first
                                                .branchId
                                            : '',
                                        businessId: (bankDetailDTO
                                                .businessDetails.isNotEmpty)
                                            ? bankDetailDTO.businessDetails
                                                .first.businessId
                                            : '',
                                        userId: UserInformationHelper.instance
                                            .getUserId(),
                                      );
                                      _qrBloc.add(
                                          QREventGenerate(dto: qrCreateDTO));
                                    }
                                  },
                                  bgColor: DefaultTheme.GREEN,
                                  textColor: DefaultTheme.WHITE,
                                )
                              : ButtonIconWidget(
                                  width: 300,
                                  height: 40,
                                  icon: Icons.add_rounded,
                                  title: 'Tạo mã QR',
                                  function: () {},
                                  bgColor: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.4),
                                  textColor: DefaultTheme.GREY_TEXT,
                                ),
                        );
                      },
                    ),
                  ],
                  widget3: BlocConsumer<QRBloc, QRState>(
                    listener: (context, state) {
                      if (state is QRGenerateSuccessState) {
                        qrGeneratedDTO = state.dto;
                      }
                    },
                    builder: (context, state) {
                      if (state is QRLoadingState) {
                        return const UnconstrainedBox(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: DefaultTheme.GREEN,
                            ),
                          ),
                        );
                      }
                      return (qrGeneratedDTO.qrCode.isEmpty)
                          ? const SizedBox()
                          : ListView(
                              shrinkWrap: true,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 30)),
                                UnconstrainedBox(
                                  child: VietQRWidget(
                                    width: 400,
                                    hasBgNapas: true,
                                    qrGeneratedDTO: qrGeneratedDTO,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                              String paramData = Session
                                                  .instance
                                                  .formatDataParamUrl(
                                                      qrGeneratedDTO,
                                                      action: 'PRINT');
                                              int start = Uri.base
                                                  .toString()
                                                  .indexOf('/qr');
                                              int end =
                                                  Uri.base.toString().length;
                                              html.window.open(
                                                  Uri.base.toString().replaceRange(
                                                      start,
                                                      end,
                                                      '/qr_generate$paramData'),
                                                  'new tab');
                                            },
                                            bgColor:
                                                Theme.of(context).cardColor,
                                            textColor:
                                                Theme.of(context).hintColor,
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
                                              Provider.of<ActionShareProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateAction(false);
                                              String paramData = Session
                                                  .instance
                                                  .formatDataParamUrl(
                                                      qrGeneratedDTO,
                                                      action: 'SAVE');

                                              int start = Uri.base
                                                  .toString()
                                                  .indexOf('/qr');
                                              int end =
                                                  Uri.base.toString().length;
                                              html.window.open(
                                                  Uri.base.toString().replaceRange(
                                                      start,
                                                      end,
                                                      '/qr_generate$paramData'),
                                                  'new tab');
                                            },
                                            bgColor:
                                                Theme.of(context).cardColor,
                                            textColor:
                                                Theme.of(context).hintColor,
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
                                              await FlutterClipboard.copy(
                                                      ShareUtils
                                                          .instance
                                                          .getTextSharing(
                                                              qrGeneratedDTO))
                                                  .then(
                                                (value) =>
                                                    Fluttertoast.showToast(
                                                  msg: 'Đã sao chép',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      DefaultTheme.WHITE,
                                                  textColor: DefaultTheme.BLACK,
                                                  fontSize: 15,
                                                  webBgColor:
                                                      'rgba(255, 255, 255)',
                                                  webPosition: 'center',
                                                ),
                                              );
                                            },
                                            bgColor:
                                                Theme.of(context).cardColor,
                                            textColor:
                                                Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                );
        },
      ),
    );
  }

  Widget _buildElementInfo(
      {required BuildContext context,
      required String title,
      required String description}) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const Spacer(),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
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
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).cardColor,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
