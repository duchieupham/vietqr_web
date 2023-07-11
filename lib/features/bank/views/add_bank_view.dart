import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/frames/add_bank_frame.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/widgets/confirm_opt_widget.dart';
import 'package:VietQR/features/bank/widgets/policy_bank_widget.dart';
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_card_insert_dto.dart';
import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_search_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBankView extends StatefulWidget {
  final String userId;

  const AddBankView({
    super.key,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _AddBankView();
}

class _AddBankView extends State<AddBankView> {
  static final TextEditingController phoneController = TextEditingController();
  static final TextEditingController nationalController =
      TextEditingController();
  static final TextEditingController bankAccountController =
      TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  static late BankBloc bankBloc;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Provider.of<BankTypeProvider>(context, listen: false).reset();
    bankBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<BankBloc, BankState>(
      listener: (context, state) {
        if (state is BankSearchingNameState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is BankSearchNameSuccessState ||
            state is BankSearchNameFailedState) {
          Navigator.pop(context);
          _focusNode.unfocus();
        }
        if (state is BankLoadingInsertState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is BankCheckNotExistedState) {
          //pop loading
          if (state.isAuthenticated) {
            //add event request OTP
            String formattedName = StringUtils.instance.removeDiacritic(
                StringUtils.instance
                    .capitalFirstCharacter(nameController.text));
            bankBloc.add(
              BankEventRequestOTP(
                dto: BankCardRequestOTP(
                  nationalId: nationalController.text,
                  accountNumber: bankAccountController.text,
                  accountName: formattedName,
                  applicationType: 'WEB_APP',
                  phoneNumber: phoneController.text,
                ),
              ),
            );
          } else {
            //insert bank unauthenticated
            String bankTypeId =
                Provider.of<BankTypeProvider>(context, listen: false)
                    .bankType
                    .id;
            String userId = UserInformationHelper.instance.getUserId();
            String formattedName = StringUtils.instance.removeDiacritic(
                StringUtils.instance
                    .capitalFirstCharacter(nameController.text));
            BankCardInsertUnauthenticatedDTO dto =
                BankCardInsertUnauthenticatedDTO(
              bankTypeId: bankTypeId,
              userId: userId,
              userBankName: formattedName,
              bankAccount: bankAccountController.text,
            );
            bankBloc.add(BankEventInsertUnauthenticated(dto: dto));
          }
        }
        if (state is BankCheckFailedState) {
          //pop loading
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Lỗi', msg: 'Vui lòng thử lại sau');
        }
        if (state is BankCheckExistedState) {
          //pop loading
          Navigator.pop(context);
          DialogWidget.instance.openMsgDialog(
              title: 'Không thể thêm/liên kết TK', msg: state.msg);
        }
        if (state is BankInsertUnauthenticatedSuccessState) {
          //pop loading
          phoneController.clear();
          nameController.clear();
          nationalController.clear();
          bankAccountController.clear();
          //navigate
          Fluttertoast.showToast(
            msg: 'Thêm tài khoản ngân hàng thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: DefaultTheme.WHITE,
            textColor: DefaultTheme.BLACK,
            fontSize: 15,
            webBgColor: 'rgba(255, 255, 255)',
            webPosition: 'center',
          );
          context.go('/');
        }
        if (state is BankInsertUnauthenticatedFailedState) {
          //pop loading
          Navigator.pop(context);
          DialogWidget.instance
              .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg);
        }
        if (state is BankReuqestOTPLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is BankRequestOTPSuccessState) {
          Navigator.pop(context);
          DialogWidget.instance.openPopup(
            width: 300,
            height: 400,
            child: ConfirmOTPWidget(
              requestId: state.requestId,
              phone: phoneController.text,
              bankBloc: bankBloc,
              dto: state.dto,
            ),
          );
        }
        if (state is BankRequestOTPFailedState) {
          Navigator.pop(context);
          DialogWidget.instance.openMsgDialog(
            title: 'Xác thực thất bại',
            msg: state.message,
            function: () {
              Navigator.pop(context);
            },
          );
        }
        if (state is BankConfirmOTPLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is BankConfirmOTPSuccessState) {
          // Navigator.pop(context);
          // String bankId =
          //     Provider.of<AddBankProvider>(context, listen: false).bankId;
          // if (bankId.trim().isEmpty) {
          BankTypeDTO bankTypeDTO =
              Provider.of<BankTypeProvider>(context, listen: false).bankType;
          String userId = UserInformationHelper.instance.getUserId();
          String formattedName = StringUtils.instance.removeDiacritic(
              StringUtils.instance.capitalFirstCharacter(nameController.text));
          BankCardInsertDTO dto = BankCardInsertDTO(
            bankTypeId: bankTypeDTO.id,
            userId: userId,
            userBankName: formattedName,
            bankAccount: bankAccountController.text,
            type: 0,
            branchId: '',
            nationalId: nationalController.text,
            phoneAuthenticated: phoneController.text,
          );
          bankBloc.add(BankEventInsert(dto: dto));
          // } else {
          //   RegisterAuthenticationDTO dto = RegisterAuthenticationDTO(
          //     bankId: bankId,
          //     nationalId: nationalController.text,
          //     phoneAuthenticated: phoneAuthenController.text,
          //     bankAccountName: nameController.text,
          //     bankAccount: bankAccountController.text,
          //   );
          //   bankCardBloc.add(BankEventRegisterAuthentication(dto: dto));
          // }
        }
        if (state is BankConfirmOTPFailedState) {
          Navigator.pop(context);
          DialogWidget.instance.openMsgDialog(
            title: 'Lỗi',
            msg: state.message,
          );
        }
        if (state is BankInsertSuccessfulState) {
          //pop loading
          Navigator.pop(context);
          phoneController.clear();
          nameController.clear();
          nationalController.clear();
          bankAccountController.clear();
          //navigate
          Fluttertoast.showToast(
            msg: 'Liên kết tài khoản ngân hàng thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: DefaultTheme.WHITE,
            textColor: DefaultTheme.BLACK,
            fontSize: 15,
            webBgColor: 'rgba(255, 255, 255)',
            webPosition: 'center',
          );
          context.go('/');
        }
        if (state is BankInsertFailedState) {
          DialogWidget.instance.openMsgDialog(
              title: 'Không thể thêm tài khoản', msg: state.message);
        }
      },
      builder: (context, state) {
        if (state is BankSearchNameSuccessState) {
          nameController.clear();
          nameController.value = nameController.value.copyWith(
            text: state.dto.accountName,
          );
          _focusNode.unfocus();
        }
        return AddBankFrame(
          widget1: ListView(
            shrinkWrap: true,
            children: [
              //image
              Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: Image.asset('assets/images/ads-1.jpg').image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              const Text(
                'Hệ thống hỗ trợ: ',
                style: TextStyle(
                  fontSize: 13,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text(
                '-   Tạo mã VietQR thanh toán.',
                style: TextStyle(
                  fontSize: 13,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              const Text(
                '-   Đối với TK MB Bank sau khi được liên kết, hệ thống hỗ trợ đối soát thanh toán.',
                style: TextStyle(
                  fontSize: 13,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              const Text(
                '-   Khi thực hiện liên kết, CCCD/Mã số thuế và Số điện thoại xác thực là bắt buộc.',
                style: TextStyle(
                  fontSize: 13,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
            ],
          ),
          widget2: Consumer<BankTypeProvider>(
            builder: (context, provider, child) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Consumer<BankTypeProvider>(
                    builder: (context, provider, child) {
                      return InkWell(
                        onTap: () {
                          DialogWidget.instance.openPopup(
                            child: const SelectBankTypeWidget(),
                            width: 500,
                            height: 500,
                          );
                        },
                        child: (provider.bankType.id.isEmpty)
                            ? BoxLayout(
                                width: width,
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
                                width,
                                provider.bankType,
                              ),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Thông tin tài khoản',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  BorderLayout(
                    width: width,
                    height: 50,
                    isError: provider.bankAccountErr,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFieldWidget(
                      width: width,
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
                          String transferType = '';
                          String bankCode = provider.bankType.caiValue;
                          if (provider.bankType.bankCode == 'MB') {
                            transferType = 'INHOUSE';
                          } else {
                            transferType = 'NAPAS';
                          }
                          BankNameSearchDTO bankNameSearchDTO =
                              BankNameSearchDTO(
                            accountNumber: bankAccountController.text,
                            accountType: 'ACCOUNT',
                            transferType: transferType,
                            bankCode: bankCode,
                          );
                          bankBloc
                              .add(BankEventSearchName(dto: bankNameSearchDTO));
                        }
                      },
                      onChange: (vavlue) {
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
                        color: DefaultTheme.RED_TEXT,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  BorderLayout(
                    width: width,
                    height: 50,
                    isError: provider.nameErr,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFieldWidget(
                      width: width,
                      isObscureText: false,
                      maxLines: 1,
                      hintText: 'Chủ tài khoản \u002A',
                      controller: nameController,
                      inputType: TextInputType.number,
                      keyboardAction: TextInputAction.next,
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
                        color: DefaultTheme.RED_TEXT,
                      ),
                    ),
                  ),
                  if (provider.bankType.status == 1) ...[
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    BorderLayout(
                      width: width,
                      height: 50,
                      isError: provider.phoneErr,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        width: width,
                        isObscureText: false,
                        maxLines: 1,
                        hintText: 'Số điện thoại xác thực \u002A',
                        controller: phoneController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {
                          provider.updatePhoneErr(
                            !(phoneController.text.isNotEmpty &&
                                StringUtils.instance
                                    .isNumeric(phoneController.text)),
                          );
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    BorderLayout(
                      width: width,
                      height: 50,
                      isError: provider.nationalErr,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        width: width,
                        isObscureText: false,
                        maxLines: 1,
                        hintText: 'CCCD/Mã số thuế \u002A',
                        controller: nationalController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {
                          provider.updateNationalErr(
                              !(nationalController.text.length >= 9 &&
                                  nationalController.text.length <= 12));
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Visibility(
                      visible: provider.nationalErr,
                      child: const Text(
                        'CCCD/Mã số thuế không hợp lệ',
                        style: TextStyle(
                          fontSize: 12,
                          color: DefaultTheme.RED_TEXT,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Visibility(
                      visible: provider.phoneErr,
                      child: const Text(
                        'Số điện thoại xác thực không hợp lệ',
                        style: TextStyle(
                          fontSize: 12,
                          color: DefaultTheme.RED_TEXT,
                        ),
                      ),
                    ),
                  ],
                  const Padding(padding: EdgeInsets.only(top: 50)),
                  SizedBox(
                    width: width,
                    child: Row(
                      children: [
                        ButtonWidget(
                          width: (provider.bankType.status == 0)
                              ? 460
                              : 460 / 2 - 10,
                          height: 40,
                          text: 'Lưu tài khoản',
                          borderRadius: 5,
                          textColor: DefaultTheme.GREEN,
                          bgColor: Theme.of(context).cardColor,
                          function: () {
                            if (provider.bankType.id.isNotEmpty) {
                              provider.updateBankAccountErr(
                                (bankAccountController.text.isEmpty ||
                                    !StringUtils.instance
                                        .isNumeric(bankAccountController.text)),
                              );
                              provider.updateNameErr(
                                nameController.text.isEmpty,
                              );
                              if (provider.isValidUnauthenticateForm()) {
                                String bankTypeId =
                                    Provider.of<BankTypeProvider>(context,
                                            listen: false)
                                        .bankType
                                        .id;
                                bankBloc.add(
                                  BankCheckExistedEvent(
                                      isAuthenticated: false,
                                      bankAccount: bankAccountController.text,
                                      bankTypeId: bankTypeId),
                                );
                              }
                            } else {
                              DialogWidget.instance.openMsgDialog(
                                title: 'Không thể tạo',
                                msg: 'Vui lòng chọn ngân hàng thụ hưởng',
                              );
                            }
                          },
                        ),
                        if (provider.bankType.status == 1) ...[
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          ButtonWidget(
                            width: 380 / 2 - 10,
                            height: 40,
                            text: 'Liên kết',
                            borderRadius: 5,
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            function: () async {
                              provider.updateBankAccountErr(
                                (bankAccountController.text.isEmpty ||
                                    !StringUtils.instance
                                        .isNumeric(bankAccountController.text)),
                              );
                              provider.updateNameErr(
                                nameController.text.isEmpty,
                              );
                              provider.updateNationalErr(
                                  !(nationalController.text.length >= 9 &&
                                      nationalController.text.length <= 12));
                              provider.updatePhoneErr(
                                !(phoneController.text.isNotEmpty &&
                                    StringUtils.instance
                                        .isNumeric(phoneController.text)),
                              );
                              if (provider.isValidUnauthenticateForm()) {
                                await DialogWidget.instance
                                    .openPopup(
                                  child: PolicyBankWidget(
                                    bankAccount: bankAccountController.text,
                                  ),
                                  width: 600,
                                  height: 400,
                                )
                                    .then((value) {
                                  provider.updateAgreePolicy(false);
                                  bool check = value ?? false;
                                  if (check) {
                                    String bankTypeId =
                                        Provider.of<BankTypeProvider>(context,
                                                listen: false)
                                            .bankType
                                            .id;
                                    bankBloc.add(
                                      BankCheckExistedEvent(
                                          isAuthenticated: true,
                                          bankAccount:
                                              bankAccountController.text,
                                          bankTypeId: bankTypeId),
                                    );
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectedBankType(
      BuildContext context, double width, BankTypeDTO dto) {
    return SizedBox(
      width: width,
      height: 120,
      child: Stack(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  dto.bankCode,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 2)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    dto.bankName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _buildLogo(context, 70, dto.imageId, BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(
      BuildContext context, double size, String imageId, BoxFit fit) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: UnconstrainedBox(
        child: Container(
          width: size - 10,
          height: size - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size - 10),
            color: DefaultTheme.WHITE,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
            image: DecorationImage(
                fit: fit, image: ImageUtils.instance.getImageNetWork(imageId)),
          ),
        ),
      ),
    );
  }
}
