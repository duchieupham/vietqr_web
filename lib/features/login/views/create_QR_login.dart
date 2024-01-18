import 'dart:html' as html;
import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/menu_drawer.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_type_bloc.dart';
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/frames/create_qr_mobile_frame.dart';
import 'package:VietQR/features/login/provider/create_qr_login_provider.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/vcard_generated_dto.dart';
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
  final ScrollController _controllerScroll = ScrollController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  late QRCodeUnUTBloc qrCodeUnUTBloc;
  late BankTypeBloc bankTypeBloc;

  List<BankTypeDTO> bankTypes = [];
  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
    imgId: '58b7190b-a294-4b14-968f-cd365593893e',
  );

  VcardGenerateDto vcardGenerateDto = const VcardGenerateDto();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<CreateQRLoginProvider>(
      create: (context) => CreateQRLoginProvider(),
      child: (PlatformUtils.instance.resizeWhen(width, 750))
          ? CreateQRLoginFrame(
              width: width,
              height: height,
              controller: _controllerScroll,
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
            )
          : CreateQRMobileFrame(
              width: width,
              height: height,
              controller: _controllerScroll,
              widget1: _buildFormInput(),
              widget2: _buildQRCode(),
              menuTop: const MenuDrawer(),
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 550) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _controllerScroll.animateTo(
                  _controllerScroll.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Tạo mã QR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Chọn loại QR muốn tạo',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _buildForm(),
          ],
        );
      }

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
          Expanded(child: _buildForm()),
        ],
      );
    });
  }

  Widget _buildForm() {
    return Consumer<CreateQRLoginProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                ButtonIconWidget(
                  height: 30,
                  width: 100,
                  iconSize: 16,
                  title: 'VietQR',
                  function: () {
                    provider.changePage(0);
                    setState(() {
                      vcardGenerateDto = const VcardGenerateDto();
                    });
                  },
                  textSize: 12,
                  bgColor:
                      provider.page == 0 ? AppColor.BLUE_TEXT : AppColor.WHITE,
                  textColor:
                      provider.page == 0 ? AppColor.WHITE : AppColor.BLACK,
                  pathIcon: AppImages.icVietQrSmall,
                ),
                const SizedBox(
                  width: 12,
                ),
                ButtonIconWidget(
                  height: 30,
                  width: 100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  iconSize: 28,
                  title: 'VCard',
                  function: () {
                    provider.changePage(1);
                    setState(() {
                      qrGeneratedDTO = const QRGeneratedDTO();
                    });
                  },
                  textSize: 12,
                  iconPathColor:
                      provider.page == 1 ? AppColor.WHITE : AppColor.BLUE_TEXT,
                  bgColor:
                      provider.page == 1 ? AppColor.BLUE_TEXT : AppColor.WHITE,
                  textColor:
                      provider.page == 1 ? AppColor.WHITE : AppColor.BLACK,
                  pathIcon: AppImages.icContactBankBlue,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          provider.page == 1
              ? _buildFormInputVcard(provider)
              : Consumer<BankTypeProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin tạo mã',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 24)),
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
                          const Padding(padding: EdgeInsets.only(top: 12)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Số tài khoản *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 8)),
                                    BorderLayout(
                                      height: 50,
                                      isError: provider.bankAccountErr,
                                      bgColor: AppColor.WHITE,
                                      borderColor: AppColor.BLACK_BUTTON
                                          .withOpacity(0.3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                            (bankAccountController
                                                    .text.isEmpty ||
                                                !StringUtils.instance.isNumeric(
                                                    bankAccountController
                                                        .text)),
                                          );
                                        },
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
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
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tên chủ tài khoản *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 8)),
                                    BorderLayout(
                                      height: 50,
                                      isError: provider.nameErr,
                                      bgColor: AppColor.WHITE,
                                      borderColor: AppColor.BLACK_BUTTON
                                          .withOpacity(0.3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFieldWidget(
                                        isObscureText: false,
                                        maxLines: 1,
                                        fontSize: 14,
                                        hintText: 'Nhập tên chủ tài khoản',
                                        controller: nameController,
                                        inputType: TextInputType.text,
                                        keyboardAction: TextInputAction.done,
                                        onSubmitted: (value) {
                                          if (provider
                                              .bankType.bankCode.isNotEmpty) {
                                            provider.updateBankAccountErr(
                                              (bankAccountController
                                                      .text.isEmpty ||
                                                  !StringUtils.instance
                                                      .isNumeric(
                                                          bankAccountController
                                                              .text)),
                                            );
                                            provider.updateNameErr(
                                              nameController.text.isEmpty,
                                            );
                                            if (provider
                                                .isValidUnauthenticateForm()) {
                                              Map<String, dynamic> data = {};
                                              data['bankAccount'] =
                                                  bankAccountController.text;
                                              data['userBankName'] =
                                                  nameController.text;
                                              data['bankCode'] =
                                                  provider.bankType.bankCode;
                                              qrCodeUnUTBloc.add(
                                                  QRCodeUnUTCreateQR(
                                                      data: data));
                                            }
                                          } else {
                                            DialogWidget.instance.openMsgDialog(
                                              title: 'Không thể tạo',
                                              msg:
                                                  'Vui lòng chọn ngân hàng thụ hưởng',
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
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // const Padding(padding: EdgeInsets.only(top: 12)),
                          // Row(
                          //   children: [
                          //     const Spacer(),
                          //     InkWell(
                          //       onTap: () {
                          //         provider.updateShowMoreOption(
                          //             !provider.showMoreOption);
                          //       },
                          //       child: Text(
                          //         provider.showMoreOption
                          //             ? 'Đóng tùy chọn'
                          //             : 'Tùy chọn thêm',
                          //         style: const TextStyle(
                          //             fontSize: 12, color: AppColor.BLUE_TEXT),
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 4,
                          //     ),
                          //     Transform.rotate(
                          //         angle: provider.showMoreOption
                          //             ? math.pi / 2
                          //             : -math.pi / 2,
                          //         child: const Icon(
                          //           Icons.arrow_back_ios_new,
                          //           size: 12,
                          //           color: AppColor.BLUE_TEXT,
                          //         ))
                          //   ],
                          // ),
                          if (!provider.showMoreOption) ...[
                            const Padding(padding: EdgeInsets.only(top: 12)),
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
                                hintText: 'Nhập số tiền (không bắt buộc)',
                                fontSize: 14,
                                controller: amountController,
                                inputType: TextInputType.number,
                                keyboardAction: TextInputAction.done,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                                      data['userBankName'] =
                                          nameController.text;
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
                            const Padding(padding: EdgeInsets.only(top: 12)),
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
                                hintText:
                                    'Nội dung không được quá 50 kí tự (không bắt buộc)',
                                controller: contentController,
                                inputType: TextInputType.number,
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
                                      data['userBankName'] =
                                          nameController.text;
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
                                onChange: (value) {},
                              ),
                            ),
                          ],
                          const Padding(padding: EdgeInsets.only(top: 24)),
                          ButtonWidget(
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
        ],
      );
    });
  }

  Widget _buildFormInputVcard(CreateQRLoginProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Text(
            'Thông tin tạo mã',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Padding(padding: EdgeInsets.only(top: 24)),
          const Text(
            'Số điện thoại*',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          BorderLayout(
            height: 50,
            isError: provider.isPhoneNumberErr,
            bgColor: AppColor.WHITE,
            borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldWidget(
              isObscureText: false,
              maxLines: 1,
              hintText: 'Nhập số điện thoại',
              fontSize: 14,
              controller: phoneNumberController,
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
                provider.updatePhoneNumberErr(
                  (phoneNumberController.text.isEmpty ||
                      !StringUtils.instance
                          .isNumeric(phoneNumberController.text)),
                );
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          if (provider.isPhoneNumberErr)
            const Text(
              'Số tài khoản không hợp lệ',
              style: TextStyle(
                fontSize: 12,
                color: AppColor.RED_TEXT,
              ),
            ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          const Text(
            'Họ tên*',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          BorderLayout(
            height: 50,
            isError: provider.isNameErr,
            bgColor: AppColor.WHITE,
            borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldWidget(
              isObscureText: false,
              maxLines: 1,
              fontSize: 14,
              hintText: 'Nhập họ và tên',
              controller: nameController,
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.done,
              onSubmitted: (value) {
                provider.updateNameErr(
                  nameController.text.isEmpty,
                );
                if (!provider.isNameErr && !provider.isPhoneNumberErr) {
                  print('dadada');
                  Map<String, dynamic> data = {};
                  data['fullname'] = nameController.text;
                  data['phoneNo'] = phoneNumberController.text;
                  data['email'] = emailController.text;
                  data['companyName'] = nameCompanyController.text;
                  data['website'] = websiteController.text;
                  data['address'] = addressController.text;
                  qrCodeUnUTBloc.add(QRVCardCreateQR(data: data));
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
          if (provider.isNameErr)
            const Text(
              'Họ và tên không được để trống',
              style: TextStyle(
                fontSize: 12,
                color: AppColor.RED_TEXT,
              ),
            ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  provider.updateShowMoreOption(!provider.showMoreOption);
                },
                child: Text(
                  provider.showMoreOption ? 'Đóng tùy chọn' : 'Tùy chọn thêm',
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Transform.rotate(
                  angle: provider.showMoreOption ? math.pi / 2 : -math.pi / 2,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 12,
                    color: AppColor.BLUE_TEXT,
                  ))
            ],
          ),
          if (provider.showMoreOption) ...[
            const Padding(padding: EdgeInsets.only(top: 12)),
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            BorderLayout(
              height: 50,
              bgColor: AppColor.WHITE,
              borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
              isError: false,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                hintText: 'Nhập email',
                fontSize: 14,
                controller: emailController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onSubmitted: (value) {},
                onChange: (value) {},
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            const Text(
              'Website',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            BorderLayout(
              height: 50,
              isError: false,
              bgColor: AppColor.WHITE,
              borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                fontSize: 14,
                hintText: 'Nhập Website',
                controller: websiteController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onSubmitted: (value) {},
                onChange: (value) {
                  provider.updateWebsiteErr(websiteController.text);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            if (provider.isWebsiteErr)
              const Text(
                'Website không đúng định dạng',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.RED_TEXT,
                ),
              ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            const Text(
              'Tên công ty',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            BorderLayout(
              height: 50,
              isError: false,
              bgColor: AppColor.WHITE,
              borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                fontSize: 14,
                hintText: 'Nhập tên công ty',
                controller: nameCompanyController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onSubmitted: (value) {},
                onChange: (value) {},
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            const Text(
              'Địa chỉ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            BorderLayout(
              height: 50,
              isError: false,
              bgColor: AppColor.WHITE,
              borderColor: AppColor.BLACK_BUTTON.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                fontSize: 14,
                hintText: 'Nhập địa chỉ',
                controller: addressController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onSubmitted: (value) {},
                onChange: (value) {},
              ),
            ),
          ],
          const Padding(padding: EdgeInsets.only(top: 24)),
          ButtonWidget(
            width: 380,
            height: 40,
            text: 'Tạo mã Vcard',
            borderRadius: 5,
            textColor: AppColor.WHITE,
            bgColor: provider.isPhoneNumberErr || provider.isNameErr
                ? AppColor.GREY_TEXT
                : AppColor.BLUE_TEXT,
            function: () {
              provider.updatePhoneNumberErr(
                (phoneNumberController.text.isEmpty ||
                    !StringUtils.instance
                        .isNumeric(phoneNumberController.text)),
              );
              provider.updateNameErr(
                nameController.text.isEmpty,
              );
              if (provider.isPhoneNumberErr ||
                  provider.isNameErr ||
                  provider.isWebsiteErr) {
              } else {
                Map<String, dynamic> data = {};
                data['fullname'] = nameController.text;
                data['phoneNo'] = phoneNumberController.text;
                data['email'] = emailController.text;
                data['companyName'] = nameCompanyController.text;
                data['website'] = websiteController.text;
                data['address'] = addressController.text;
                qrCodeUnUTBloc.add(QRVCardCreateQR(data: data));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListBank() {
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<BankTypeProvider>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () {
              DialogWidget.instance.openPopup(
                child: const SelectBankTypeWidget(
                  authenticated: false,
                ),
                width: constraints.maxWidth >= 700
                    ? 500
                    : constraints.maxWidth * 0.9,
                height: 500,
              );
            },
            child: (provider.bankType.bankCode.isEmpty)
                ? BoxLayout(
                    bgColor: AppColor.WHITE,
                    height: 50,
                    borderRadius: 5,
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.3)),
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
    });
  }

  Widget _buildSelectedBankType(BuildContext context, BankTypeDTO dto) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.BLACK_BUTTON.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
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

          Future.delayed(const Duration(milliseconds: 500), () {
            _controllerScroll.animateTo(
              _controllerScroll.position.maxScrollExtent - 80,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          });

          vcardGenerateDto = const VcardGenerateDto();
        }
        if (state is CreateVcardSuccessfulState) {
          vcardGenerateDto = state.dto;
          Future.delayed(const Duration(milliseconds: 500), () {
            _controllerScroll.animateTo(
              _controllerScroll.position.maxScrollExtent - 80,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          });
          qrGeneratedDTO = const QRGeneratedDTO(
            imgId: '58b7190b-a294-4b14-968f-cd365593893e',
          );
        }
      },
      builder: (context, state) {
        if (state is CreateQRLoadingState || state is CreateVcardLoadingState) {
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
        if (vcardGenerateDto.qr.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  width: 360,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFEECDFF),
                          Color(0xFF49558A),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.only(top: 16),
                  margin: const EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                    image: ImageUtils.instance.getImageNetWork(
                                        AppImages.icVietQrSmall),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vcardGenerateDto.fullname,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.BLACK),
                                ),
                                const Text(
                                  'VCard',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 80, right: 80, top: 20),
                        decoration: const BoxDecoration(color: AppColor.WHITE),
                        child: Stack(
                          children: [
                            QrImage(
                              data: vcardGenerateDto.qr,
                              version: QrVersions.auto,
                              size: 200,
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColor.WHITE,
                                    borderRadius: BorderRadius.circular(40),
                                    image: DecorationImage(
                                        image: ImageUtils.instance
                                            .getImageNetWork(
                                                AppImages.icVietQrSmall),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          vcardGenerateDto.fullname,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.WHITE),
                        ),
                      ),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Số điện thoại', vcardGenerateDto.phoneNo),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem(
                          'Email',
                          vcardGenerateDto.email.isNotEmpty
                              ? vcardGenerateDto.email
                              : '-'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem(
                          'Website',
                          vcardGenerateDto.website.isNotEmpty
                              ? vcardGenerateDto.website
                              : '-'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem(
                          'Công ty',
                          vcardGenerateDto.companyName.isNotEmpty
                              ? vcardGenerateDto.companyName
                              : '-'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem(
                          'Địa chỉ',
                          vcardGenerateDto.address.isNotEmpty
                              ? vcardGenerateDto.address
                              : '-'),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: 360,
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ButtonIconWidget(
                          height: 40,
                          pathIcon: AppImages.icPrintBlue,
                          title: '',
                          bgColor: AppColor.WHITE.withOpacity(0.4),
                          textColor: AppColor.ORANGE,
                          function: () async {
                            String paramData =
                                Session.instance.formatDataParamUrl(
                              qrGeneratedDTO,
                              action: 'PRINT',
                            );
                            html.window.open(
                                Uri.base.toString().replaceFirst('/create-qr',
                                    '/qr-generate/print$paramData'),
                                'new tab');
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Expanded(
                        child: ButtonIconWidget(
                          height: 40,
                          pathIcon: AppImages.icEditAvatarSetting,
                          title: '',
                          function: () {
                            String paramData =
                                Session.instance.formatDataParamUrl(
                              qrGeneratedDTO,
                              action: 'SAVE',
                            );
                            html.window.open(
                                Uri.base.toString().replaceFirst(
                                    '/create-qr', '/qr_generate$paramData'),
                                'new tab');
                          },
                          bgColor: AppColor.WHITE.withOpacity(0.4),
                          textColor: AppColor.RED_CALENDAR,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Expanded(
                        child: ButtonIconWidget(
                          height: 40,
                          pathIcon: AppImages.icCopyBlue,
                          title: '',
                          function: () async {
                            await FlutterClipboard.copy(vcardGenerateDto.qr)
                                .then(
                              (value) => Fluttertoast.showToast(
                                msg: 'Đã sao chép',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Theme.of(context).cardColor,
                                textColor: Theme.of(context).hintColor,
                                fontSize: 15,
                                webBgColor: 'rgba(255, 255, 255)',
                                webPosition: 'center',
                              ),
                            );
                          },
                          bgColor: AppColor.WHITE.withOpacity(0.4),
                          textColor: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return (qrGeneratedDTO.qrCode.isEmpty)
            ? UnconstrainedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 46,
                    ),
                    const Text(
                      'Mã QR của bạn',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: 280,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColor.BLACK.withOpacity(0.2))),
                      child: Opacity(
                        opacity: 0.5,
                        child: QrImage(
                          data: 'https://vietqr.vn',
                          size: 260,
                          foregroundColor: AppColor.BLACK,
                          embeddedImage: ImageUtils.instance
                              .getImageNetWork(AppImages.icVietQrSmall),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(30, 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 42,
                  ),
                  const Text(
                    'Mã QR của bạn',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                                    Uri.base.toString().replaceFirst(
                                        '/create-qr',
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
                    child: ButtonWidget(
                      height: 40,
                      text: 'Tạo lại mã VietQR',
                      borderRadius: 5,
                      textColor: AppColor.BLUE_TEXT,
                      bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                      function: () {
                        _controllerScroll.animateTo(
                          _controllerScroll.position.minScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                    ),
                  )
                ],
              );
      },
    );
  }

  Widget _buildItem(String title, String content,
      {GestureTapCallback? onTap, TextStyle? style}) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: height < 750 ? 2 : 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.WHITE,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                content,
                style: style ??
                    const TextStyle(
                      color: AppColor.WHITE,
                      fontSize: 12,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
