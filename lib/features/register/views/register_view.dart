import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/utils/user_information_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/login/provider/menu_login_provider.dart';
import 'package:VietQR/features/register/blocs/register_bloc.dart';
import 'package:VietQR/features/register/events/register_event.dart';
import 'package:VietQR/features/register/states/register_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/services/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../commons/widgets/pin_code_input.dart';

class RegisterView extends StatelessWidget {
  static final TextEditingController _phoneNoController =
      TextEditingController();

  static final TextEditingController _passwordController =
      TextEditingController();

  static final TextEditingController _confirmPassController =
      TextEditingController();
  static final TextEditingController _shareCodeController =
      TextEditingController();

  final RegisterBloc _registerBloc = RegisterBloc();

  // static bool _isChangePhone = false;
  static bool _isChangePass = false;
  String shareCode = '';

  RegisterView({super.key});

  final focus = FocusNode();
  void initialServices(BuildContext context) {
    context.read<MenuLoginProvider>().changePage(6);
    if (!_isChangePass) {
      _passwordController.clear();
      _confirmPassController.clear();
    }

    if (Uri.base.queryParameters['share_code'].toString().toLowerCase() !=
        'null') {
      shareCode = Uri.base.queryParameters['share_code'] ?? '';
    }
    _shareCodeController.text = shareCode;

    // if (!_isChangePhone) {
    //   if (StringUtils.instance.isNumeric(phoneNo)) {
    //     _phoneNoController.value =
    //         _phoneNoController.value.copyWith(text: phoneNo);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
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
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT.withOpacity(0.2),
                ),
                child: const MenuLogin(),
              ),
              Expanded(
                child: BlocProvider<RegisterBloc>(
                  create: (BuildContext context) => RegisterBloc(),
                  child: BlocListener<RegisterBloc, RegisterState>(
                    bloc: _registerBloc,
                    listener: ((context, state) {
                      if (state is RegisterFailedState) {
                        //pop loading dialog
                        Navigator.pop(context);
                        //
                        DialogWidget.instance.openMsgDialog(
                          title: 'Không thể đăng ký',
                          msg: state.msg,
                        );
                      }
                      if (state is RegisterSuccessState) {
                        //pop loading dialog
                        Navigator.of(context).pop();
                        //pop to login page

                        DialogWidget.instance.openMsgSuccessDialog(
                            title: 'Thông báo',
                            msg: 'Đăng ký thành công',
                            onTapClose: () {
                              _registerBloc
                                  .add(LoginEventByPhone(dto: state.dto));
                            });
                      }
                      if (state is LoginSuccessState) {
                        toHome(context);
                      }
                      if (state is LoginFailedState) {
                        //pop loading dialog
                        Navigator.pop(context);
                        //
                        DialogWidget.instance.openMsgDialog(
                          title: 'Đã có lỗi xảy ra',
                          msg: 'Bạn vui lòng login từ màn login',
                        );
                      }
                    }),
                    child: Consumer<RegisterProvider>(
                      builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: 500,
                            height: height - 200,
                            child: Center(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  SizedBox(
                                    height:
                                        constraints.maxWidth < 750 ? 20 : 60,
                                  ),
                                  const Text(
                                    'Thông tin đăng ký',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _buildLaBle('Số điện thoại',
                                      'Số điện thoại được dùng để đăng nhập vào hệ thống VietQR VN'),
                                  BorderLayout(
                                    width: width,
                                    bgColor: AppColor.WHITE,
                                    isError: value.phoneErr,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextFieldWidget(
                                      height: 40,
                                      width: width,
                                      isObscureText: false,

                                      contentPadding: const EdgeInsets.only(
                                          bottom: 8, left: 10),
                                      maxLines: 1,
                                      // textfieldType: TextfieldType.LABEL,
                                      // title: 'Số điện thoại',
                                      // titleWidth: 100,
                                      hintText: 'Nhập số điện thoại',
                                      fontSize: 14,
                                      controller: _phoneNoController,
                                      inputType: TextInputType.number,
                                      keyboardAction: TextInputAction.next,
                                      onChange: (vavlue) {
                                        // _isChangePhone = true;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: value.phoneErr,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 5, right: 30),
                                      child: Text(
                                        'Số điện thoại không đúng định dạng.',
                                        style: TextStyle(
                                            color: AppColor.RED_TEXT,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  _buildLaBle('Mật khẩu',
                                      'Mật khẩu bao gồm 6 ký tự, không bao gồm chữ và ký tự đặc biệt'),
                                  SizedBox(
                                    height: 40,
                                    child: PinCodeInput(
                                      obscureText: true,
                                      fillWidth: 60,
                                      onCompleted: (data) {
                                        value.focusNodeConfirmPass(context);
                                      },
                                      onChanged: (value) {
                                        _passwordController.text = value;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: value.passwordErr,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 5, right: 30),
                                      child: Text(
                                        'Mật khẩu bao gồm 6 số.',
                                        style: TextStyle(
                                            color: AppColor.RED_TEXT,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  _buildLaBle('Xác nhận lại mật khẩu',
                                      'Nhập lại mật khẩu ở trên để xác nhận'),
                                  SizedBox(
                                    height: 40,
                                    child: PinCodeInput(
                                      obscureText: true,
                                      focusNode: value.confirmPassFocus,
                                      fillWidth: 60,
                                      onChanged: (value) {
                                        _confirmPassController.text = value;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: value.confirmPassErr,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 5, right: 30),
                                      child: Text(
                                        'Xác nhận Mật khẩu không trùng khớp.',
                                        style: TextStyle(
                                            color: AppColor.RED_TEXT,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  if (shareCode.isNotEmpty)
                                    _buildFiledShareCode(width)
                                  else ...[
                                    _buildLaBle('Thông tin người giới thiệu',
                                        'Mã giới thiệu của bạn bè đã chia sẻ cho bạn trước đó, nếu có.',
                                        required: false),
                                    BorderLayout(
                                      width: width,
                                      bgColor: AppColor.WHITE,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      isError: false,
                                      child: TextFieldWidget(
                                        height: 40,
                                        width: width,
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 8, left: 10),
                                        maxLines: 1,
                                        fontSize: 14,
                                        hintText:
                                            'Nhập mã giới thiệu (không bắt buộc)',
                                        controller: _shareCodeController,
                                        inputType: TextInputType.text,
                                        keyboardAction: TextInputAction.next,
                                        onChange: (vavlue) {},
                                        isObscureText: false,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  _buildButtonSubmit(context, width),
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 20)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (constraints.maxWidth < 750)
                const FooterWeb(
                  showListBank: false,
                  bgColor: AppColor.WHITE,
                )
              else
                const FooterWeb(
                  showListBank: true,
                )
            ],
          );
        }),
      ),
    );
  }

  void backToPreviousPage(BuildContext context) {
    // _isChangePhone = false;
    _isChangePass = false;
    Provider.of<RegisterProvider>(context, listen: false).reset();
    context.go('/login');
  }

  void toHome(BuildContext context) {
    // _isChangePhone = false;
    _isChangePass = false;
    Provider.of<RegisterProvider>(context, listen: false).reset();
    context.go('/home');
  }

  Widget _buildFiledShareCode(double width) {
    return Container(
      width: width,
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.GREY_BUTTON,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        shareCode,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildButtonSubmit(BuildContext context, double width) {
    return SizedBox(
      width: width,
      child: ButtonWidget(
          height: 40,
          text: 'Đăng ký',
          borderRadius: 5,
          textColor: AppColor.WHITE,
          bgColor: AppColor.BLUE_TEXT,
          function: () async {
            Provider.of<RegisterProvider>(context, listen: false).updateErrs(
              phoneErr:
                  !StringUtils.instance.isNumeric(_phoneNoController.text),
              passErr:
                  (!StringUtils.instance.isNumeric(_passwordController.text) ||
                      (_passwordController.text.length != 6)),
              confirmPassErr: !StringUtils.instance.isValidConfirmText(
                  _passwordController.text, _confirmPassController.text),
            );

            if (Provider.of<RegisterProvider>(context, listen: false)
                .isValidValidation()) {
              // Provider.of<RegisterProvider>(context, listen: false)
              //     .sendOtp(_phoneNoController.text);
              // openPinDialog(context);
              DialogWidget.instance.openLoadingDialog();
              String userIP =
                  await UserInformationUtils.instance.getIPAddress();
              AccountLoginDTO dto = AccountLoginDTO(
                phoneNo: _phoneNoController.text,
                email: '',
                password: EncryptUtils.instance.encrypted(
                  _phoneNoController.text,
                  _passwordController.text,
                ),
                device: userIP,
                fcmToken: '',
                platform: 'WEB',
                sharingCode: _shareCodeController.text,
              );
              _registerBloc.add(RegisterEventSubmit(dto: dto));
            }
          }),
    );
  }

  // void openPinDialog(BuildContext context) {
  //   if (_phoneNoController.text.isEmpty) {
  //     DialogWidget.instance.openMsgDialog(
  //         title: 'Đăng kí không thành công',
  //         msg: 'Vui lòng nhập số điện thoại để đăng kí.');
  //   } else {
  //     DialogWidget.instance.openOTPDialog(onDone: () async {
  //       Navigator.of(context).pop();
  //       DialogWidget.instance.openLoadingDialog();
  //       String userIP = await UserInformationUtils.instance.getIPAddress();
  //       AccountLoginDTO dto = AccountLoginDTO(
  //         phoneNo: _phoneNoController.text,
  //         email: '',
  //         password: EncryptUtils.instance.encrypted(
  //           _phoneNoController.text,
  //           _passwordController.text,
  //         ),
  //         device: userIP,
  //         fcmToken: '',
  //         platform: 'WEB',
  //       );
  //       _registerBloc.add(RegisterEventSubmit(dto: dto));
  //     }, reSendOtp: () {
  //       Provider.of<RegisterProvider>(context, listen: false)
  //           .sendOtp(_phoneNoController.text);
  //     });
  //   }
  // }
  Widget _buildLaBle(String laBel, String des, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                laBel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (required)
                const Text(
                  '*',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            des,
            style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
