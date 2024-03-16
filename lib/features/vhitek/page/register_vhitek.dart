import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/vhitek/blocs/vhitek_bloc.dart';
import 'package:VietQR/features/vhitek/events/vhitek_event.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterVhitek extends StatefulWidget {
  final Function(int) edit;
  final Function(String, String, String, String, String) onChanged;
  final String mid;

  const RegisterVhitek(
      {super.key, required this.edit, this.mid = '', required this.onChanged});

  @override
  State<RegisterVhitek> createState() => _RegisterVhitekState();
}

class _RegisterVhitekState extends State<RegisterVhitek> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveVhitekProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kết nối máy bán hàng',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.mid.isEmpty ? widget.mid : provider.mid,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.edit(0),
                    child: const Icon(
                      Icons.edit,
                      color: AppColor.BLUE_TEXT,
                      size: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            DividerWidget(
              width: double.infinity,
              color: AppColor.BLACK_BUTTON.withOpacity(0.2),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 8),
                  const Text(
                    'Đăng ký tài khoản quản lý',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Email*',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Địa chỉ Email được sử dụng để kết nối máy bán hàng',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  BorderLayout(
                    height: 50,
                    isError: false,
                    borderColor: AppColor.WHITE,
                    bgColor: AppColor.WHITE,
                    child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: true,
                        hintText: 'Địa chỉ Email',
                        fontSize: 12,
                        maxLength: 50,
                        controller: emailController,
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          provider.changeEmail(value.toString());
                        },
                        onSubmitted: (value) {}),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Họ tên*',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Nhập họ tên của bạn',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BorderLayout(
                    height: 50,
                    isError: false,
                    borderColor: AppColor.WHITE,
                    bgColor: AppColor.WHITE,
                    child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: true,
                        hintText: 'Ví dụ: Nguyễn Văn A',
                        fontSize: 12,
                        maxLength: 50,
                        controller: userNameController,
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          provider.changeUserName(value.toString());
                        },
                        onSubmitted: (value) {}),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Số điện thoại*',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Nhập số điện thoại của bạn',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BorderLayout(
                    height: 50,
                    isError: false,
                    borderColor: AppColor.WHITE,
                    bgColor: AppColor.WHITE,
                    child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: true,
                        hintText: 'Ví dụ: 090 999 9999',
                        fontSize: 12,
                        maxLength: 50,
                        controller: phoneController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          provider.changePhoneNumber(value.toString());
                        },
                        onSubmitted: (value) {}),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Mật khẩu*',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Nhập mật khẩu cho tài khoản quản lý của bạn',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BorderLayout(
                    height: 50,
                    isError: false,
                    borderColor: AppColor.WHITE,
                    bgColor: AppColor.WHITE,
                    child: TextFieldWidget(
                        isObscureText: true,
                        autoFocus: true,
                        hintText: '******',
                        fontSize: 12,
                        maxLength: 50,
                        controller: passController,
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          provider.changePassword(value.toString());
                        },
                        onSubmitted: (value) {}),
                  ),
                  if (provider.isErrPassword) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      provider.errorPass,
                      style: const TextStyle(color: AppColor.RED_TEXT),
                    )
                  ],
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Xác nhận lại mật khẩu*',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Xác nhận lại mật khẩu ở trên',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BorderLayout(
                    height: 50,
                    isError: provider.isErrPasswordConfirm,
                    borderColor: AppColor.WHITE,
                    bgColor: AppColor.WHITE,
                    child: TextFieldWidget(
                        isObscureText: true,
                        autoFocus: true,
                        hintText: '******',
                        fontSize: 12,
                        maxLength: 50,
                        inputType: TextInputType.text,
                        controller: TextEditingController(
                            text: provider.passwordConfirm),
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {
                          provider.changePasswordConfirm(value.toString());
                        },
                        onSubmitted: (value) {}),
                  ),
                  if (provider.isErrPasswordConfirm) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Mật khẩu không trùng nhau, vui lòng kiểm tra lại!',
                      style: TextStyle(color: AppColor.RED_TEXT),
                    )
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
            ButtonWidget(
              text: 'Đăng kí',
              textColor: AppColor.WHITE,
              borderRadius: 5,
              bgColor: AppColor.BLUE_TEXT,
              function: () => onRegister(provider),
            ),
          ],
        );
      },
    );
  }

  void onRegister(ActiveVhitekProvider provider) {
    provider.checkErrPassword();
    if (provider.email.isEmpty ||
        provider.userName.isEmpty ||
        provider.phoneNumber.isEmpty ||
        provider.password.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng nhập đầy đủ thông tin trên form');
    } else if (provider.isErrPasswordConfirm) {
      DialogWidget.instance
          .openMsgDialog(title: 'Cảnh báo', msg: 'Mật khẩu không trùng nhau');
    } else {
      String userId = UserInformationHelper.instance.getUserId().trim();
      if (!provider.isErrPassword) {
        Map<String, dynamic> param = {};
        param['userId'] = userId;
        param['email'] = provider.email;
        param['phoneNo'] = provider.phoneNumber;
        param['password'] = provider.password;
        param['name'] = provider.userName;
        widget.onChanged(userId, provider.email, provider.phoneNumber,
            provider.password, provider.userName);
        context.read<VhitekBloc>().add(CreateUserEvent(param: param));
      }
    }
  }
}
