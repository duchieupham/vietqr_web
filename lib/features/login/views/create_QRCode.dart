import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
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
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../commons/widgets/bottom_web.dart';
import '../events/qrcode_un_authen_event.dart';

class CreateQRCode extends StatefulWidget {
  final bool isLogined;
  const CreateQRCode({super.key, this.isLogined = false});

  @override
  State<CreateQRCode> createState() => _CreateQRCodeState();
}

class _CreateQRCodeState extends State<CreateQRCode> {
  static final TextEditingController bankAccountController =
      TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController amountController =
      TextEditingController(text: '');
  static final TextEditingController contentController =
      TextEditingController(text: '');
  final FocusNode _focusNode = FocusNode();
  late QRCodeUnUTBloc qrCodeUnUTBloc;

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
    if (widget.isLogined) {
      return SizedBox(
        width: width,
        height: height - 60,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                if (PlatformUtils.instance
                    .resizeWhen(constraints.maxWidth, 800))
                  Expanded(
                    child: SizedBox(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildFormInput()),
                            Expanded(child: _buildQRCode())
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _buildFormInput(),
                  ),
                  _buildQRCode(
                    horizontalInfo: true,
                    horizontalInfoWidth: constraints.maxWidth,
                  )
                ],
              ],
            );
          },
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              if (PlatformUtils.instance.resizeWhen(constraints.maxWidth, 800))
                Expanded(
                  child: SizedBox(
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildFormInput()),
                          Expanded(child: _buildQRCode())
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: _buildFormInput(),
                ),
                _buildQRCode(
                  horizontalInfo: true,
                  horizontalInfoWidth: constraints.maxWidth,
                )
              ],
              if (PlatformUtils.instance
                  .resizeWhen(constraints.maxWidth, 800)) ...[
                const Divider(
                  color: AppColor.BLACK_DARK,
                  thickness: 0.5,
                  height: 0.5,
                ),
                const BottomWeb()
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildFormInput() {
    return Consumer<BankTypeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Thông tin thiết lập mã QR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              _buildListBank(),
              const Padding(padding: EdgeInsets.only(top: 15)),
              BorderLayout(
                height: 50,
                isError: provider.bankAccountErr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'Số tài khoản \u002A',
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
                          !StringUtils.instance
                              .isNumeric(bankAccountController.text)),
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
              const Padding(padding: EdgeInsets.only(top: 5)),
              BorderLayout(
                height: 50,
                isError: provider.nameErr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'Chủ tài khoản \u002A',
                  controller: nameController,
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.done,
                  onSubmitted: (value) {
                    if (provider.bankType.bankCode.isNotEmpty) {
                      provider.updateBankAccountErr(
                        (bankAccountController.text.isEmpty ||
                            !StringUtils.instance
                                .isNumeric(bankAccountController.text)),
                      );
                      provider.updateNameErr(
                        nameController.text.isEmpty,
                      );
                      if (provider.isValidUnauthenticateForm()) {
                        Map<String, dynamic> data = {};
                        data['bankAccount'] = bankAccountController.text;
                        data['userBankName'] = nameController.text;
                        data['bankCode'] = provider.bankType.bankCode;
                        qrCodeUnUTBloc.add(QRCodeUnUTCreateQR(data: data));
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
              const Padding(padding: EdgeInsets.only(top: 5)),
              BorderLayout(
                height: 50,
                isError: provider.nameErr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'Số tiền',
                  controller: amountController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.next,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
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
              const Padding(padding: EdgeInsets.only(top: 10)),
              BorderLayout(
                height: 50,
                isError: provider.nameErr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'Nội dung không được quá 50 kí tự',
                  controller: contentController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.done,
                  onSubmitted: (value) {},
                  onChange: (value) {},
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Switch(
                    value: !provider.showBankAccount,
                    activeColor: AppColor.GREEN,
                    onChanged: (bool value) {
                      provider.updateShowBankAccount(!value);
                    },
                  ),
                  const Expanded(
                      child: Text(
                    'Không hiển thị mã tài khoản của tôi tại mã VietQR',
                    style: TextStyle(fontSize: 12),
                  ))
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              ButtonWidget(
                width: (provider.bankType.status == 0) ? 380 : 380 / 2 - 10,
                height: 40,
                text: 'Tạo mã VietQR',
                borderRadius: 5,
                textColor: AppColor.WHITE,
                bgColor: !provider.isValidCreate
                    ? AppColor.GREY_TEXT
                    : AppColor.BLUE_TEXT,
                function: () {
                  if (!provider.isValidCreate) {
                  } else if (provider.bankType.bankCode.isNotEmpty) {
                    provider.updateBankAccountErr(
                      (bankAccountController.text.isEmpty ||
                          !StringUtils.instance
                              .isNumeric(bankAccountController.text)),
                    );
                    provider.updateNameErr(
                      nameController.text.isEmpty,
                    );
                    if (provider.isValidUnauthenticateForm()) {
                      Map<String, dynamic> data = {};
                      data['bankAccount'] = bankAccountController.text;
                      data['userBankName'] = nameController.text;
                      data['bankCode'] = provider.bankType.bankCode;
                      data['amount'] = amountController.text;
                      data['content'] = StringUtils.instance
                          .removeDiacritic(contentController.text);
                      qrCodeUnUTBloc.add(QRCodeUnUTCreateQR(data: data));
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
                  bgColor: Theme.of(context).canvasColor,
                  height: 50,
                  borderRadius: 5,
                  child: Row(
                    children: const [
                      Text(
                        'Chọn ngân hàng thụ hưởng',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: 12,
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.GREY_TOP_TAB_BAR, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ImageUtils.instance.getImageNetWork(dto.imageId),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Text(
              '${dto.bankCode} - ${dto.bankName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: AppColor.GREEN,
              ),
            ),
          );
        }
        return (qrGeneratedDTO.qrCode.isEmpty)
            ? _buildQRCodeBlank()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 380,
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
                    width: horizontalInfo ? double.infinity : 380,
                    child: Row(
                      children: [
                        Expanded(
                          child: Tooltip(
                            message: 'In',
                            child: ButtonIconWidget(
                              height: 40,
                              icon: Icons.print_rounded,
                              title: 'In',
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
                              bgColor:
                                  Theme.of(context).scaffoldBackgroundColor,
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
                              icon: Icons.photo_rounded,
                              title: 'Lưu ảnh',
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
                                        '/login', '/qr_generate$paramData'),
                                    'new tab');
                              },
                              bgColor:
                                  Theme.of(context).scaffoldBackgroundColor,
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
                              icon: Icons.copy_rounded,
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
                              bgColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              textColor: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
      },
    );
  }

  Widget _buildQRCodeBlank() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: BoxLayout(
          width: 300,
          height: 300,
          bgColor: AppColor.WHITE,
          enableShadow: true,
          padding: const EdgeInsets.all(20),
          child: Opacity(
            opacity: 0.5,
            child: QrImage(
              data: 'https://vietqr.vn',
              size: 250,
              foregroundColor: AppColor.BLACK,
              embeddedImage:
                  ImageUtils.instance.getImageNetWork(AppImages.icVietQrSmall),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(30, 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
