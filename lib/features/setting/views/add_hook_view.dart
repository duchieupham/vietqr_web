import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/widgets/select_my_bank_account.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AddHookView extends StatelessWidget {
  AddHookView({Key? key}) : super(key: key);
  final TextEditingController endpointController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    _buildFiledListBank(),
                    const Text(
                      'Endpoint*',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BorderLayout(
                      height: 42,
                      isError: false,
                      borderWidth: 1,
                      child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: true,
                        fontSize: 13,
                        textStyle: const TextStyle(fontSize: 13),
                        contentPadding:
                            const EdgeInsets.only(left: 20, bottom: 8),
                        controller: endpointController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {},
                        hintText: 'http://example.com',
                      ),
                    ),
                    Consumer<SettingProvider>(
                        builder: (context, provider, child) {
                      if (provider.validateEndpoint) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Endpoint không được để trống',
                            style: TextStyle(
                                color: AppColor.RED_TEXT, fontSize: 13),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Tiêu đề thông báo nhận biến động số dư',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BorderLayout(
                      height: 40,
                      isError: false,
                      borderWidth: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Text(
                              '🎉',
                            ),
                            Expanded(
                              child: TextFieldWidget(
                                isObscureText: false,
                                autoFocus: true,
                                fontSize: 13,
                                textStyle: const TextStyle(fontSize: 13),
                                contentPadding:
                                    const EdgeInsets.only(left: 4, bottom: 8),
                                controller: titleController,
                                inputType: TextInputType.text,
                                keyboardAction: TextInputAction.next,
                                onChange: (vavlue) {},
                                hintText: 'Giao dịch thành công',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox.shrink())
            ],
          ),
          const Text(
            'Token',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: BorderLayout(
                  height: 42,
                  isError: false,
                  borderWidth: 1,
                  child: TextFieldWidget(
                    isObscureText: false,
                    autoFocus: true,
                    fontSize: 13,
                    textStyle: const TextStyle(fontSize: 13),
                    contentPadding: const EdgeInsets.only(left: 20, bottom: 8),
                    controller: tokenController,
                    inputType: TextInputType.number,
                    keyboardAction: TextInputAction.next,
                    onChange: (vavlue) {},
                    hintText: 'Token xác minh dữ liệu được gửi từ hệ thống',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      ButtonWidget(
                        height: 40,
                        width: 120,
                        textColor: AppColor.BLUE_TEXT,
                        bgColor: AppColor.ITEM_MENU_SELECTED,
                        borderRadius: 5,
                        function: () {
                          DialogWidget.instance.openMsgDialog(
                            title: 'Tính năng đang bảo trì',
                            msg: 'Vui lòng thử lại sau',
                          );
                        },
                        text: 'Tạo Token',
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 120,
            child: Tooltip(
              message: 'Thêm Hook',
              child: ButtonWidget(
                height: 40,
                textColor: AppColor.WHITE,
                bgColor: AppColor.BLUE_CARD,
                borderRadius: 5,
                function: () {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Tính năng đang bảo trì',
                    msg: 'Vui lòng thử lại sau',
                  );
                  // if (endpointController.text.isEmpty) {
                  //   Provider.of<SettingProvider>(context,
                  //           listen: false)
                  //       .updateValidEndpoint(true);
                  // } else {
                  //   Provider.of<SettingProvider>(context,
                  //           listen: false)
                  //       .updateValidEndpoint(false);
                  //
                  // }
                },
                text: 'Thêm Hook',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiledListBank() {
    return BlocConsumer<BankBloc, BankState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn tài khoản đã liên kết',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              Consumer<SettingProvider>(builder: (context, provider, child) {
                return InkWell(
                    onTap: () {
                      DialogWidget.instance.openPopup(
                        child: SelectMyBankAccountWidget(
                          bankAccounts: provider.bankAccounts,
                          chooseBank: (dto) {
                            provider.updateBankAccountSelected(dto);
                          },
                        ),
                        width: 500,
                        height: 500,
                      );
                    },
                    child: (provider.bankAccountSelected.userId?.isEmpty ??
                            true)
                        ? BorderLayout(
                            height: 40,
                            isError: false,
                            borderWidth: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 16),
                              child: Row(
                                children: const [
                                  Expanded(child: Text('Chọn tài khoản')),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _buildItemSelected(provider.bankAccountSelected));
              }),
              const SizedBox(
                height: 20,
              )
            ],
          );
        });
  }

  Widget _buildItemSelected(BankAccountDTO dto) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            image: DecorationImage(
              image: ImageUtils.instance.getImageNetWork(
                dto.imgId,
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${dto.bankCode} - ${dto.bankAccount}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK,
                    fontSize: 13),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                dto.userBankName.toUpperCase(),
                style: const TextStyle(
                  color: AppColor.BLACK,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
