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
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_card_insert_unauthenticated.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBankView extends StatelessWidget {
  final String userId;
  static final TextEditingController phoneController = TextEditingController();
  static final TextEditingController nationalController =
      TextEditingController();
  static final TextEditingController bankAccountController =
      TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  static late BankBloc bankBloc;

  const AddBankView({
    super.key,
    required this.userId,
  });

  void initialServices(BuildContext context) {
    Provider.of<BankTypeProvider>(context, listen: false).reset();
    bankBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      body: BlocListener<BankBloc, BankState>(
        listener: (context, state) {
          if (state is BankLoadingInsertState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is BankCheckNotExistedState) {
            //pop loading
            Navigator.pop(context);
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
          if (state is BankCheckFailedState) {
            //pop loading
            Navigator.pop(context);
            DialogWidget.instance
                .openMsgDialog(title: 'Lỗi', msg: 'Vui lòng thử lại sau');
          }
          if (state is BankCheckExistedState) {
            //pop loading
            Navigator.pop(context);
            DialogWidget.instance
                .openMsgDialog(title: 'Không thể thêm TK', msg: state.msg);
          }
          if (state is BankInsertUnauthenticatedSuccessState) {
            //pop loading
            Navigator.pop(context);
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
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
              webBgColor: 'rgba(255, 255, 255, 0.5)',
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
        },
        child: AddBankFrame(
          widget1: ListView(
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
                '-   Khi thực hiện liên kết, CMT/CCCD và Số điện thoại xác thực là bắt buộc.',
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
                      keyboardAction: TextInputAction.next,
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
                          !StringUtils.instance
                              .isValidFullName(nameController.text),
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
                      // isError: value.phoneErr,
                      isError: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        width: width,
                        isObscureText: false,
                        maxLines: 1,
                        hintText: 'CMT/CCCD \u002A',
                        controller: nationalController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {
                          // _isChangePhone = true;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    BorderLayout(
                      width: width,
                      height: 50,
                      // isError: value.phoneErr,
                      isError: false,
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
                          // _isChangePhone = true;
                        },
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
                              ? 380
                              : 380 / 2 - 10,
                          height: 40,
                          text: 'Thêm',
                          borderRadius: 5,
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          function: () {
                            if (provider.bankType.id.isNotEmpty) {
                              provider.updateBankAccountErr(
                                (bankAccountController.text.isEmpty ||
                                    !StringUtils.instance
                                        .isNumeric(bankAccountController.text)),
                              );
                              provider.updateNameErr(
                                !StringUtils.instance
                                    .isValidFullName(nameController.text),
                              );
                              if (provider.isValidUnauthenticateForm()) {
                                String bankTypeId =
                                    Provider.of<BankTypeProvider>(context,
                                            listen: false)
                                        .bankType
                                        .id;
                                bankBloc.add(
                                  BankCheckExistedEvent(
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
                            bgColor: DefaultTheme.PURPLE_NEON,
                            function: () {},
                          ),
                        ],
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
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
