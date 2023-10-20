import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddBankStep3 extends StatefulWidget {
  const AddBankStep3({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AddBankView();
}

class _AddBankView extends State<AddBankStep3> {
  static late BankBloc bankBloc;

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
                              if (state is BankLoadingInsertState) {
                                DialogWidget.instance.openLoadingDialog();
                              }
                              if (state is BankCheckNotExistedState) {
                                // if (state.isAuthenticated) {
                                //   String formattedName = StringUtils.instance
                                //       .removeDiacritic(StringUtils.instance
                                //       .capitalFirstCharacter(
                                //       nameController.text));
                                //   bankBloc.add(
                                //     BankEventRequestOTP(
                                //       dto: BankCardRequestOTP(
                                //         nationalId: nationalController.text,
                                //         accountNumber:
                                //         bankAccountController.text,
                                //         accountName: formattedName,
                                //         applicationType: 'WEB_APP',
                                //         phoneNumber: phoneController.text,
                                //       ),
                                //     ),
                                //   );
                                // } else {
                                //   //insert bank unauthenticated
                                //   String bankTypeId =
                                //       Provider.of<BankTypeProvider>(context,
                                //           listen: false)
                                //           .bankType
                                //           .id;
                                //   String userId = UserInformationHelper.instance
                                //       .getUserId();
                                //   String formattedName = StringUtils.instance
                                //       .removeDiacritic(StringUtils.instance
                                //       .capitalFirstCharacter(
                                //       nameController.text));
                                //   BankCardInsertUnauthenticatedDTO dto =
                                //   BankCardInsertUnauthenticatedDTO(
                                //     bankTypeId: bankTypeId,
                                //     userId: userId,
                                //     userBankName: formattedName,
                                //     bankAccount: bankAccountController.text,
                                //   );
                                //   bankBloc.add(
                                //       BankEventInsertUnauthenticated(dto: dto));
                                // }
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
                                // DialogWidget.instance.openPopup(
                                //   width: 300,
                                //   height: 400,
                                //   child: ConfirmOTPWidget(
                                //     requestId: state.requestId,
                                //     phone: phoneController.text,
                                //     bankBloc: bankBloc,
                                //     dto: state.dto,
                                //   ),
                                // );
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
                                    Provider.of<BankTypeProvider>(context,
                                            listen: false)
                                        .bankType;
                                // String userId =
                                // UserInformationHelper.instance.getUserId();
                                // String formattedName = StringUtils.instance
                                //     .removeDiacritic(StringUtils.instance
                                //     .capitalFirstCharacter(
                                //     nameController.text));
                                // BankCardInsertDTO dto = BankCardInsertDTO(
                                //   bankTypeId: bankTypeDTO.id,
                                //   userId: userId,
                                //   userBankName: formattedName,
                                //   bankAccount: bankAccountController.text,
                                //   type: 0,
                                //   branchId: '',
                                //   nationalId: nationalController.text,
                                //   phoneAuthenticated: phoneController.text,
                                // );
                                // bankBloc.add(BankEventInsert(dto: dto));
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
                                Fluttertoast.showToast(
                                  msg:
                                      'Liên kết tài khoản ngân hàng thành công',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColor.WHITE,
                                  textColor: AppColor.BLACK,
                                  fontSize: 15,
                                  webBgColor: 'rgba(255, 255, 255)',
                                  webPosition: 'center',
                                );
                                context.go('/');
                              }
                              if (state is BankInsertFailedState) {
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Không thể thêm tài khoản',
                                    msg: state.message);
                              }
                            },
                            builder: (context, state) {
                              return Consumer<BankTypeProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 44,
                                        ),
                                        const Spacer(),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 70)),
                                        ButtonWidget(
                                          width: 440,
                                          height: 40,
                                          text: 'Xác thực',
                                          borderRadius: 5,
                                          textColor: AppColor.WHITE,
                                          bgColor: AppColor.BLUE_TEXT,
                                          function: () async {},
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
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
                  '3',
                  style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Xác thực liên kết',
                  style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                ),
              ),
            ],
          )),
    );
  }
}
