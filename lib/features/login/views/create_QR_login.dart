import 'dart:html' as html;
import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_type_bloc.dart';
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/provider/create_qr_login_provider.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../bank/events/bank_type_event.dart';
import '../../bank/states/bank_type_state.dart';
import '../events/qrcode_un_authen_event.dart';
import '../frames/create_qr_login_frame.dart';

class CreateQRLogin extends StatefulWidget {
  const CreateQRLogin({super.key});

  @override
  State<CreateQRLogin> createState() => _CreateQRCodeState();
}

class _CreateQRCodeState extends State<CreateQRLogin> {
  static final TextEditingController bankAccountController =
      TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController amountController =
      TextEditingController(text: '');
  static final TextEditingController contentController =
      TextEditingController(text: '');
  final FocusNode _focusNode = FocusNode();
  late QRCodeUnUTBloc qrCodeUnUTBloc;
  late BankTypeBloc bankTypeBloc;
  List<BankTypeDTO> bankTypes = [];
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
  @override
  void initState() {
    super.initState();
    qrCodeUnUTBloc = BlocProvider.of(context);
    bankTypeBloc = BlocProvider.of(context);
    context.read<MenuLoginProvider>().changePage(0);
    bankTypeBloc.add(const BankTypeEventGetListUnauthenticated());
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColor.BLUE_TEXT;
    }
    return AppColor.WINTER_COLOR;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<CreateQRLoginProvider>(
      create: (context) => CreateQRLoginProvider(),
      child: CreateQRLoginFrame(
        width: width,
        height: height,
        widget1: _buildFormInput(),
        widget2: _buildQRCode(),
        menuTop: const MenuLogin(),
        bottom: BlocConsumer<BankTypeBloc, BankTypeState>(
            listener: (context, state) {
          if (state is BankTypeGetListSuccessfulState) {
            bankTypes = state.list;
          }
        }, builder: (context, state) {
          return const FooterWeb(
            showListBank: true,
          );
        }),
      ),
    );
  }

  Widget _buildFormInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tạo mã QR',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Chọn loại QR muốn tạo',
              style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
            )
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  ButtonIconWidget(
                    height: 30,
                    width: 100,
                    iconSize: 16,
                    title: 'VietQR',
                    function: () {},
                    textSize: 12,
                    bgColor: AppColor.BLUE_TEXT,
                    textColor: AppColor.WHITE,
                    pathIcon: AppImages.icVietQrSmall,
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: Consumer<BankTypeProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const Text(
                            'Thông tin tạo mã',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 28)),
                          const Text(
                            'Ngân hàng *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          BlocConsumer<BankTypeBloc, BankTypeState>(
                              listener: (context, state) {
                            if (state is BankTypeGetListSuccessfulState) {
                              bankTypes = state.list;
                            }
                          }, builder: (context, state) {
                            if (state is BankTypeLoadingState) {
                              return const UnconstrainedBox(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              );
                            }

                            return _buildListBank();
                          }),
                          const Padding(padding: EdgeInsets.only(top: 24)),
                          const Text(
                            'Số tài khoản *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          BorderLayout(
                            height: 50,
                            isError: provider.bankAccountErr,
                            bgColor: AppColor.WHITE,
                            borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldWidget(
                              isObscureText: false,
                              maxLines: 1,
                              hintText: 'Nhập số tài khoản',
                              fontSize: 14,
                              controller: bankAccountController,
                              inputType: TextInputType.number,
                              focusNode: _focusNode,
                              keyboardAction: TextInputAction.next,
                              onTapOutside: (value) {
                                if (_focusNode.hasFocus) {
                                  _focusNode.unfocus();
                                  _focusNode.unfocus();
                                }
                              },
                              onChange: (value) {
                                provider.updateBankAccountErr(
                                  (bankAccountController.text.isEmpty ||
                                      !StringUtils.instance.isNumeric(
                                          bankAccountController.text)),
                                );
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 5)),
                          Visibility(
                            visible: provider.bankAccountErr,
                            child: const Text(
                              'Số tài khoản không hợp lệ',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.RED_TEXT,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 24)),
                          const Text(
                            'Tên chủ tài khoản *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          BorderLayout(
                            height: 50,
                            isError: provider.nameErr,
                            bgColor: AppColor.WHITE,
                            borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldWidget(
                              isObscureText: false,
                              maxLines: 1,
                              fontSize: 14,
                              hintText: 'Nhập tên chủ tài khoản',
                              controller: nameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.done,
                              onSubmitted: (value) {
                                if (provider.bankType.bankCode.isNotEmpty) {
                                  provider.updateBankAccountErr(
                                    (bankAccountController.text.isEmpty ||
                                        !StringUtils.instance.isNumeric(
                                            bankAccountController.text)),
                                  );
                                  provider.updateNameErr(
                                    nameController.text.isEmpty,
                                  );
                                  if (provider.isValidUnauthenticateForm()) {
                                    Map<String, dynamic> data = {};
                                    data['bankAccount'] =
                                        bankAccountController.text;
                                    data['userBankName'] = nameController.text;
                                    data['bankCode'] =
                                        provider.bankType.bankCode;
                                    qrCodeUnUTBloc
                                        .add(QRCodeUnUTCreateQR(data: data));
                                  }
                                } else {
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể tạo',
                                    msg: 'Vui lòng chọn ngân hàng thụ hưởng',
                                  );
                                }
                              },
                              onChange: (vavlue) {
                                provider.updateNameErr(
                                  nameController.text.isEmpty,
                                );
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 5)),
                          Visibility(
                            visible: provider.nameErr,
                            child: const Text(
                              'Chủ tài khoản không hợp lệ',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.RED_TEXT,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            children: [
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  provider.updateShowMoreOption(
                                      !provider.showMoreOption);
                                },
                                child: Text(
                                  provider.showMoreOption
                                      ? 'Đóng tùy chọn'
                                      : 'Tùy chọn thêm',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.BLUE_TEXT),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Transform.rotate(
                                  angle: provider.showMoreOption
                                      ? math.pi / 2
                                      : -math.pi / 2,
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 12,
                                    color: AppColor.BLUE_TEXT,
                                  ))
                            ],
                          ),
                          if (provider.showMoreOption) ...[
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            const Text(
                              'Số tiền',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 8)),
                            BorderLayout(
                              height: 50,
                              bgColor: AppColor.WHITE,
                              borderColor:
                                  AppColor.BLACK_BUTTON.withOpacity(0.3),
                              isError: provider.nameErr,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFieldWidget(
                                isObscureText: false,
                                maxLines: 1,
                                hintText: 'Nhập số tiền',
                                fontSize: 14,
                                controller: amountController,
                                inputType: TextInputType.number,
                                keyboardAction: TextInputAction.next,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onSubmitted: (value) {},
                                onChange: (value) {
                                  if (amountController.text.isNotEmpty) {
                                    if (StringUtils.instance
                                        .isNumeric(amountController.text)) {
                                      provider.updateAmountErr(false);
                                      if (amountController.text.length >= 4) {
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
                                    provider.updateValidCreate(true);
                                  }
                                },
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            if (provider.isAmountErr)
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
                            const Padding(padding: EdgeInsets.only(top: 24)),
                            const Text(
                              'Nội dung thanh toán',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 8)),
                            BorderLayout(
                              height: 50,
                              isError: provider.nameErr,
                              bgColor: AppColor.WHITE,
                              borderColor:
                                  AppColor.BLACK_BUTTON.withOpacity(0.3),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFieldWidget(
                                isObscureText: false,
                                maxLines: 1,
                                fontSize: 14,
                                hintText: 'Nội dung không được quá 50 kí tự',
                                controller: contentController,
                                inputType: TextInputType.number,
                                keyboardAction: TextInputAction.done,
                                onSubmitted: (value) {},
                                onChange: (value) {},
                              ),
                            ),
                          ],
                          const Padding(padding: EdgeInsets.only(top: 32)),
                          ButtonWidget(
                            width: (provider.bankType.status == 0)
                                ? 380
                                : 380 / 2 - 10,
                            height: 40,
                            text: 'Tạo mã VietQR',
                            borderRadius: 5,
                            textColor: AppColor.WHITE,
                            bgColor: !provider.isValidCreate
                                ? AppColor.GREY_TEXT
                                : AppColor.BLUE_TEXT,
                            function: () {
                              if (!provider.isValidCreate) {
                              } else if (provider
                                  .bankType.bankCode.isNotEmpty) {
                                provider.updateBankAccountErr(
                                  (bankAccountController.text.isEmpty ||
                                      !StringUtils.instance.isNumeric(
                                          bankAccountController.text)),
                                );
                                provider.updateNameErr(
                                  nameController.text.isEmpty,
                                );
                                if (provider.isValidUnauthenticateForm()) {
                                  Map<String, dynamic> data = {};
                                  data['bankAccount'] =
                                      bankAccountController.text;
                                  data['userBankName'] = nameController.text;
                                  data['bankCode'] = provider.bankType.bankCode;
                                  data['amount'] = amountController.text;
                                  data['content'] = StringUtils.instance
                                      .removeDiacritic(contentController.text);
                                  qrCodeUnUTBloc
                                      .add(QRCodeUnUTCreateQR(data: data));
                                }
                              } else {
                                DialogWidget.instance.openMsgDialog(
                                  title: 'Không thể tạo',
                                  msg: 'Vui lòng chọn ngân hàng thụ hưởng',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListBank() {
    return Consumer<BankTypeProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            DialogWidget.instance.openPopup(
              child: const SelectBankTypeWidget(
                authenticated: false,
              ),
              width: 500,
              height: 500,
            );
          },
          child: (provider.bankType.bankCode.isEmpty)
              ? BoxLayout(
                  bgColor: AppColor.WHITE,
                  height: 80,
                  borderRadius: 5,
                  border:
                      Border.all(color: AppColor.BLACK_BUTTON.withOpacity(0.3)),
                  child: Row(
                    children: [
                      const Text(
                        'Chọn ngân hàng thụ hưởng',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Transform.rotate(
                          angle: -math.pi / 2,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 14,
                            color: AppColor.BLACK,
                          ))
                    ],
                  ),
                )
              : _buildSelectedBankType(
                  context,
                  provider.bankType,
                ),
        );
      },
    );
  }

  Widget _buildSelectedBankType(BuildContext context, BankTypeDTO dto) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.BLACK_BUTTON.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.GREY_BUTTON),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: ImageUtils.instance.getImageNetWork(dto.imageId),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dto.bankShortName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${dto.bankCode} - ${dto.bankName}',
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_drop_down_circle_outlined,
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode(
      {bool horizontalInfo = false, double horizontalInfoWidth = 400}) {
    return BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
      listener: (context, state) {
        if (state is CreateSuccessfulState) {
          qrGeneratedDTO = state.dto;
        }
      },
      builder: (context, state) {
        if (state is CreateQRLoadingState) {
          return const UnconstrainedBox(
            child: SizedBox(
              width: 360,
              height: 50,
              child: CircularProgressIndicator(
                color: AppColor.BLUE_TEXT,
              ),
            ),
          );
        }
        return (qrGeneratedDTO.qrCode.isEmpty)
            ? const SizedBox(
                width: 360,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 360,
                    child: VietQRWidget(
                      horizontalInfoWidth: horizontalInfoWidth,
                      horizontalInfo: horizontalInfo,
                      qrGeneratedDTO: qrGeneratedDTO,
                      showBankAccount:
                          Provider.of<BankTypeProvider>(context, listen: false)
                              .showBankAccount,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: horizontalInfo ? double.infinity : 360,
                    child: Row(
                      children: [
                        Expanded(
                          child: Tooltip(
                            message: 'In',
                            child: ButtonIconWidget(
                              height: 40,
                              pathIcon: AppImages.icPrintBlue,
                              title: '',
                              function: () {
                                String paramData = Session.instance
                                    .formatDataParamUrl(qrGeneratedDTO,
                                        action: 'PRINT',
                                        showBankAccount:
                                            Provider.of<BankTypeProvider>(
                                                        context,
                                                        listen: false)
                                                    .showBankAccount
                                                ? 1
                                                : 0);
                                html.window.open(
                                    Uri.base.toString().replaceFirst('/login',
                                        '/qr-generate/print$paramData'),
                                    'new tab');
                              },
                              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                              textColor: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Tooltip(
                            message: 'Lưu ảnh',
                            child: ButtonIconWidget(
                              height: 40,
                              pathIcon: AppImages.icEditAvatarSetting,
                              title: '',
                              function: () {
                                Provider.of<ActionShareProvider>(context,
                                        listen: false)
                                    .updateAction(false);
                                String paramData = Session.instance
                                    .formatDataParamUrl(qrGeneratedDTO,
                                        action: 'SAVE',
                                        showBankAccount:
                                            Provider.of<BankTypeProvider>(
                                                        context,
                                                        listen: false)
                                                    .showBankAccount
                                                ? 1
                                                : 0);
                                html.window.open(
                                    Uri.base.toString().replaceFirst(
                                        '/create-qr',
                                        '/qr-generated$paramData'),
                                    'new tab');
                              },
                              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                              textColor: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Tooltip(
                            message: 'Sao chép mã QR',
                            child: ButtonIconWidget(
                              height: 40,
                              pathIcon: AppImages.icCopyBlue,
                              title: '',
                              function: () async {
                                await FlutterClipboard.copy(ShareUtils.instance
                                        .getTextSharing(qrGeneratedDTO))
                                    .then(
                                  (value) => Fluttertoast.showToast(
                                    msg: 'Đã sao chép',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: AppColor.WHITE,
                                    textColor: AppColor.BLACK,
                                    fontSize: 15,
                                    webBgColor: 'rgba(255, 255, 255)',
                                    webPosition: 'center',
                                  ),
                                );
                              },
                              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                              textColor: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: horizontalInfo ? double.infinity : 360,
                    child: ButtonIconWidget(
                      height: 40,
                      icon: Icons.home_rounded,
                      title: 'Trang chủ',
                      textColor: AppColor.BLUE_TEXT,
                      bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                      function: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          context.go('/');
                        });
                      },
                    ),
                  )
                ],
              );
      },
    );
  }
}
