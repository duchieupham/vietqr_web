import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/widgets/policy_bank_widget.dart';
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_name_search_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddBankStep2 extends StatefulWidget {
  final String bankId;

  const AddBankStep2({
    super.key,
    required this.bankId,
  });

  @override
  State<StatefulWidget> createState() => _AddBankView();
}

class _AddBankView extends State<AddBankStep2> {
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
    bankBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.WHITE,
              AppColor.BLUE_LIGHT,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: Row(
                children: [
                  const MenuLeft(
                    currentType: MenuHomeType.OTHER,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTitle(),
                        _buildStep(),
                        Expanded(
                          child: BlocConsumer<BankBloc, BankState>(
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
                                if (state.isAuthenticated) {
                                  String formattedName = StringUtils.instance
                                      .removeDiacritic(StringUtils.instance
                                          .capitalFirstCharacter(
                                              nameController.text));
                                  bankBloc.add(
                                    BankEventRequestOTP(
                                      dto: BankCardRequestOTP(
                                        nationalId: nationalController.text,
                                        accountNumber:
                                            bankAccountController.text,
                                        accountName: formattedName,
                                        applicationType: 'WEB_APP',
                                        phoneNumber: phoneController.text,
                                      ),
                                    ),
                                  );
                                } else {
                                  //insert bank unauthenticated
                                  String bankTypeId =
                                      Provider.of<BankTypeProvider>(context,
                                              listen: false)
                                          .bankType
                                          .id;
                                  String userId = UserInformationHelper.instance
                                      .getUserId();
                                  String formattedName = StringUtils.instance
                                      .removeDiacritic(StringUtils.instance
                                          .capitalFirstCharacter(
                                              nameController.text));
                                  BankCardInsertUnauthenticatedDTO dto =
                                      BankCardInsertUnauthenticatedDTO(
                                    bankTypeId: bankTypeId,
                                    userId: userId,
                                    userBankName: formattedName,
                                    bankAccount: bankAccountController.text,
                                  );
                                  bankBloc.add(
                                      BankEventInsertUnauthenticated(dto: dto));
                                }
                              }
                              if (state is BankCheckFailedState) {
                                //pop loading
                                Navigator.pop(context);
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Lỗi', msg: 'Vui lòng thử lại sau');
                              }
                              if (state is BankCheckExistedState) {
                                //pop loading
                                Navigator.pop(context);
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể thêm/liên kết TK',
                                    msg: state.msg);
                              }
                              if (state
                                  is BankInsertUnauthenticatedSuccessState) {
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
                                  backgroundColor: AppColor.WHITE,
                                  textColor: AppColor.BLACK,
                                  fontSize: 15,
                                  webBgColor: 'rgba(255, 255, 255)',
                                  webPosition: 'center',
                                );
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .reset();
                                context.go('/');
                              }
                              if (state
                                  is BankInsertUnauthenticatedFailedState) {
                                //pop loading
                                Navigator.pop(context);
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể thêm TK', msg: state.msg);
                              }
                              if (state is BankReuqestOTPLoadingState) {
                                DialogWidget.instance.openLoadingDialog();
                              }
                              if (state is BankRequestOTPSuccessState) {
                                Navigator.pop(context);
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .updateRequestId(state.requestId);
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .updateBankCardRequestOTP(state.dto);
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .updateBankAccount(
                                        bankAccountController.text);
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .updateName(nameController.text);
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .updateNationalId(nationalController.text);
                                Provider.of<BankTypeProvider>(context,
                                        listen: false)
                                    .updatePhone(phoneController.text);
                                context.go('/add-bank/step3');
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
                              if (state is BankInsertFailedState) {
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể thêm tài khoản',
                                    msg: state.message);
                              }
                            },
                            builder: (context, state) {
                              if (state is BankSearchNameSuccessState) {
                                nameController.clear();
                                nameController.value =
                                    nameController.value.copyWith(
                                  text: state.dto.accountName,
                                );
                                _focusNode.unfocus();
                              }
                              return Consumer<BankTypeProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        const SizedBox(
                                          height: 44,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildInputInfo(provider),
                                            if (provider.bankType.status == 1)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: _buildInputInfoConnect(
                                                    provider),
                                              )
                                          ],
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 70)),
                                        SizedBox(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ButtonWidget(
                                                width: 440,
                                                height: 40,
                                                text: 'Lưu tài khoản',
                                                borderRadius: 5,
                                                textColor:
                                                    provider.bankType.status ==
                                                            1
                                                        ? AppColor.BLUE_TEXT
                                                        : AppColor.WHITE,
                                                bgColor:
                                                    provider.bankType.status ==
                                                            1
                                                        ? AppColor.BLUE_TEXT
                                                            .withOpacity(0.2)
                                                        : AppColor.BLUE_TEXT,
                                                function: () {
                                                  if (provider
                                                      .bankType.id.isNotEmpty) {
                                                    provider
                                                        .updateBankAccountErr(
                                                      (bankAccountController
                                                              .text.isEmpty ||
                                                          !StringUtils.instance
                                                              .isNumeric(
                                                                  bankAccountController
                                                                      .text)),
                                                    );
                                                    provider.updateNameErr(
                                                      nameController
                                                          .text.isEmpty,
                                                    );
                                                    if (provider
                                                        .isValidUnauthenticateForm()) {
                                                      String bankTypeId = Provider
                                                              .of<BankTypeProvider>(
                                                                  context,
                                                                  listen: false)
                                                          .bankType
                                                          .id;
                                                      bankBloc.add(
                                                        BankCheckExistedEvent(
                                                            isAuthenticated:
                                                                false,
                                                            bankAccount:
                                                                bankAccountController
                                                                    .text,
                                                            bankTypeId:
                                                                bankTypeId),
                                                      );
                                                    }
                                                  } else {
                                                    DialogWidget.instance
                                                        .openMsgDialog(
                                                      title: 'Không thể tạo',
                                                      msg:
                                                          'Vui lòng chọn ngân hàng thụ hưởng',
                                                    );
                                                  }
                                                },
                                              ),
                                              if (provider.bankType.status ==
                                                  1) ...[
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 12)),
                                                ButtonWidget(
                                                  width: 440,
                                                  height: 40,
                                                  text: 'Liên kết',
                                                  borderRadius: 5,
                                                  textColor: AppColor.WHITE,
                                                  bgColor: AppColor.BLUE_TEXT,
                                                  function: () async {
                                                    provider
                                                        .updateBankAccountErr(
                                                      (bankAccountController
                                                              .text.isEmpty ||
                                                          !StringUtils.instance
                                                              .isNumeric(
                                                                  bankAccountController
                                                                      .text)),
                                                    );
                                                    provider.updateNameErr(
                                                      nameController
                                                          .text.isEmpty,
                                                    );
                                                    provider.updateNationalErr(
                                                        !(nationalController
                                                                    .text
                                                                    .length >=
                                                                9 &&
                                                            nationalController
                                                                    .text
                                                                    .length <=
                                                                12));
                                                    provider.updatePhoneErr(
                                                      !(phoneController.text
                                                              .isNotEmpty &&
                                                          StringUtils.instance
                                                              .isNumeric(
                                                                  phoneController
                                                                      .text)),
                                                    );
                                                    if (provider
                                                        .isValidUnauthenticateForm()) {
                                                      await DialogWidget
                                                          .instance
                                                          .openPopup(
                                                        child: PolicyBankWidget(
                                                          bankAccount:
                                                              bankAccountController
                                                                  .text,
                                                        ),
                                                        width: 600,
                                                        height: 400,
                                                      )
                                                          .then((value) {
                                                        provider
                                                            .updateAgreePolicy(
                                                                false);
                                                        bool check =
                                                            value ?? false;
                                                        if (check) {
                                                          String bankTypeId =
                                                              Provider.of<BankTypeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .bankType
                                                                  .id;
                                                          bankBloc.add(
                                                            BankCheckExistedEvent(
                                                                isAuthenticated:
                                                                    true,
                                                                bankAccount:
                                                                    bankAccountController
                                                                        .text,
                                                                bankTypeId:
                                                                    bankTypeId),
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const FooterWeb(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputInfo(BankTypeProvider provider) {
    return UnconstrainedBox(
      child: SizedBox(
        width: 440,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập thông tin tài khoản',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              children: [
                const Text(
                  'Ngân hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    DialogWidget.instance.openPopup(
                      child: const SelectBankTypeWidget(),
                      width: 500,
                      height: 500,
                    );
                  },
                  child: const Text(
                    'Chọn ngân hàng khác',
                    style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            (provider.bankType.id.isEmpty)
                ? const SizedBox.shrink()
                : _buildSelectedBankType(
                    context,
                    provider.bankType,
                  ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Số tài khoản*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: AppColor.BLACK_LIGHT.withOpacity(0.5))),
              child: TextField(
                controller: bankAccountController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.next,
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
                    BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
                      accountNumber: bankAccountController.text,
                      accountType: 'ACCOUNT',
                      transferType: transferType,
                      bankCode: bankCode,
                    );
                    bankBloc.add(BankEventSearchName(dto: bankNameSearchDTO));
                  }
                },
                onChanged: (value) {
                  provider.updateBankAccountErr(
                    (bankAccountController.text.isEmpty ||
                        !StringUtils.instance
                            .isNumeric(bankAccountController.text)),
                  );
                },
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Số tài khoản',
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  hintStyle: TextStyle(fontSize: 12),
                ),
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
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Chủ tài khoản*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: AppColor.BLACK_LIGHT.withOpacity(0.5))),
              child: TextField(
                controller: nameController,
                onChanged: (value) {
                  provider.updateBankAccountErr(
                    (bankAccountController.text.isEmpty ||
                        !StringUtils.instance
                            .isNumeric(bankAccountController.text)),
                  );
                },
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Chủ tài khoản',
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  hintStyle: TextStyle(fontSize: 12),
                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildInputInfoConnect(BankTypeProvider provider) {
    return UnconstrainedBox(
      child: SizedBox(
        width: 440,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập thông tin liên kết tài khoản',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            const Text(
              'Số điện thoại xác thực*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Số điện thoại phải trùng khớp với thông tin đăng ký tài khoản ngân hàng',
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: AppColor.BLACK_LIGHT.withOpacity(0.5))),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 12),
                onChanged: (vavlue) {
                  provider.updatePhoneErr(
                    !(phoneController.text.isNotEmpty &&
                        StringUtils.instance.isNumeric(phoneController.text)),
                  );
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập số điện thoại xác thực',
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  hintStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Visibility(
              visible: provider.phoneErr,
              child: const Text(
                'Số điệnt thoại không hợp lệ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.RED_TEXT,
                ),
              ),
            ),
            _buildItemSuggest(UserInformationHelper.instance.getPhoneNo(), () {
              setState(() {
                phoneController.text =
                    UserInformationHelper.instance.getPhoneNo();
              });
            }),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'CCD/MST*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'CCCD (Căn cước công dân)/MST (Mã số thuế) phải trùng khớp với thông tin đăng ký tài khoản ngân hàng',
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: AppColor.BLACK_LIGHT.withOpacity(0.5))),
              child: TextField(
                controller: nationalController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 12),
                onChanged: (vavlue) {
                  provider.updateNationalErr(
                      !(nationalController.text.length >= 9 &&
                          nationalController.text.length <= 12));
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập chứng minh thư/CCCD hoặc mã số thuế',
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  hintStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Visibility(
              visible: provider.nationalErr,
              child: const Text(
                'CCCD/Mã số thuế không hợp lệ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.RED_TEXT,
                ),
              ),
            ),
            if (UserInformationHelper.instance
                .getAccountInformation()
                .nationalId
                .isNotEmpty)
              _buildItemSuggest(
                  UserInformationHelper.instance
                      .getAccountInformation()
                      .nationalId, () {
                setState(() {
                  nationalController.text = UserInformationHelper.instance
                      .getAccountInformation()
                      .nationalId;
                });
              }),
            const SizedBox(
              height: 24,
            ),
            _buildNote()
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedBankType(BuildContext context, BankTypeDTO dto) {
    return SizedBox(
      height: 100,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            _buildLogo(context, 80, dto.imageId, BoxFit.contain),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  dto.bankCode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 2)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    dto.bankName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(
      BuildContext context, double size, String imageId, BoxFit fit) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size - 10),
          color: AppColor.WHITE,
          image: DecorationImage(
              fit: fit, image: ImageUtils.instance.getImageNetWork(imageId)),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              html.window.history.back();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, right: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.BLUE_TEXT,
                    size: 12,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Trở về',
                    style: TextStyle(fontSize: 11, color: AppColor.BLUE_TEXT),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'Thêm tài khoản ngân hàng',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return Consumer<BankTypeProvider>(builder: (context, provider, child) {
      if (provider.bankType.status == 1) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
              width: 750,
              child: Row(
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '1',
                      style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Chọn ngân hàng',
                      style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.BLUE_TEXT),
                  )),
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '2',
                      style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Nhập thông tin',
                      style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.GREY_TEXT),
                  )),
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: AppColor.GREY_TEXT,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '3',
                      style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Xác thực liên kết',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  ),
                ],
              )),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
            width: 550,
            child: Row(
              children: [
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '1',
                    style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Chọn ngân hàng',
                    style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColor.BLUE_TEXT),
                )),
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '2',
                    style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Nhập thông tin',
                    style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                  ),
                ),
              ],
            )),
      );
    });
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Lưu ý:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.BLUE_TEXT,
                fontSize: 12),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Thực hiện liên kết Tài khoản ngân hàng để nhận thông tin biến động số dư, chia sẻ biến động số dư với mọi người. Hệ thống giúp việc đối soát giao dịch của bạn trở nên dễ dàng hơn.',
            style: TextStyle(color: AppColor.BLUE_TEXT, fontSize: 11),
          )
        ],
      ),
    );
  }

  Widget _buildItemSuggest(String data, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColor.BLUE_TEXT),
            color: AppColor.BLUE_TEXT.withOpacity(0.2)),
        child: Text(
          data,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
