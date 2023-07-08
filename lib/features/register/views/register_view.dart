import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/utils/user_information_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/register/blocs/register_bloc.dart';
import 'package:VietQR/features/register/events/register_event.dart';
import 'package:VietQR/features/register/frame/register_frame.dart';
import 'package:VietQR/features/register/states/register_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/services/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  void initialServices(BuildContext context) {
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
      body: Column(
        children: [
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
                        function: () {
                          Navigator.of(context).pop();
                          _registerBloc.add(LoginEventByPhone(dto: state.dto));
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
                    return RegisterFrame(
                      width: width,
                      height: height,
                      mobileChildren: const SizedBox(),
                      webChildren: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                const Text(
                                  'Đăng ký tài khoản',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/logo-vietqr-vn.png',
                                  width: 100,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          BorderLayout(
                            width: width,
                            height: 50,
                            isError: value.phoneErr,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              maxLines: 1,
                              // textfieldType: TextfieldType.LABEL,
                              // title: 'Số điện thoại',
                              // titleWidth: 100,
                              hintText: 'Số điện thoại',
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
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Số điện thoại không đúng định dạng.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          BorderLayout(
                            width: width,
                            height: 50,
                            isError: value.passwordErr,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldWidget(
                              width: width,
                              isObscureText: true,
                              maxLines: 1,
                              // textfieldType: TextfieldType.LABEL,
                              // title: 'Mật khẩu',
                              // titleWidth: 100,
                              hintText: 'Mật khẩu (6 số)',
                              controller: _passwordController,
                              inputType: TextInputType.number,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {
                                _isChangePass = true;
                              },
                            ),
                          ),
                          Visibility(
                            visible: value.passwordErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Mật khẩu bao gồm 6 số.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          BorderLayout(
                            width: width,
                            height: 50,
                            isError: value.confirmPassErr,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFieldWidget(
                              width: width,
                              isObscureText: true,
                              maxLines: 1,
                              // textfieldType: TextfieldType.LABEL,
                              // title: 'Xác nhận lại',
                              // titleWidth: 100,
                              hintText: 'Xác nhận lại Mật khẩu',
                              controller: _confirmPassController,
                              inputType: TextInputType.number,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {
                                _isChangePass = true;
                              },
                            ),
                          ),
                          Visibility(
                            visible: value.confirmPassErr,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 5, right: 30),
                              child: Text(
                                'Xác nhận Mật khẩu không trùng khớp.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          shareCode.isNotEmpty
                              ? _buildFiledShareCode(width)
                              : BorderLayout(
                                  width: width,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  isError: false,
                                  child: TextFieldWidget(
                                    width: width,
                                    maxLines: 1,
                                    hintText: 'Mã giới thiệu',
                                    controller: _shareCodeController,
                                    inputType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    onChange: (vavlue) {},
                                    isObscureText: false,
                                  ),
                                ),
                          const Spacer(),
                          _buildButtonSubmit(context, width),
                          const Padding(padding: EdgeInsets.only(bottom: 20)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
        color: DefaultTheme.GREY_BUTTON,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ButtonWidget(
              height: 40,
              text: 'Trang chủ',
              borderRadius: 5,
              textColor: DefaultTheme.GREEN,
              bgColor: Theme.of(context).canvasColor,
              function: () {
                backToPreviousPage(context);
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ButtonWidget(
                height: 40,
                text: 'Đăng ký',
                borderRadius: 5,
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () async {
                  Provider.of<RegisterProvider>(context, listen: false)
                      .updateErrs(
                    phoneErr: !StringUtils.instance
                        .isNumeric(_phoneNoController.text),
                    passErr: (!StringUtils.instance
                            .isNumeric(_passwordController.text) ||
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
          ),
        ],
      ),
    );
  }

  void openPinDialog(BuildContext context) {
    if (_phoneNoController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Đăng kí không thành công',
          msg: 'Vui lòng nhập số điện thoại để đăng kí.');
    } else {
      DialogWidget.instance.openOTPDialog(onDone: () async {
        Navigator.of(context).pop();
        DialogWidget.instance.openLoadingDialog();
        String userIP = await UserInformationUtils.instance.getIPAddress();
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
        );
        _registerBloc.add(RegisterEventSubmit(dto: dto));
      }, reSendOtp: () {
        Provider.of<RegisterProvider>(context, listen: false)
            .sendOtp(_phoneNoController.text);
      });
    }
  }
}
