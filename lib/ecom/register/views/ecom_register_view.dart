import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/utils/user_information_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/ecom/login/model/account_login_dto.dart';
import 'package:VietQR/ecom/register/blocs/ecom_register_bloc.dart';
import 'package:VietQR/ecom/register/events/ecom_register_event.dart';
import 'package:VietQR/ecom/register/provider/ecom_register_provider.dart';
import 'package:VietQR/ecom/register/states/ecom_register_state.dart';
import 'package:VietQR/features/register/frame/register_frame.dart';
import 'package:VietQR/features/register/states/register_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ECOMRegisterView extends StatelessWidget {
  final TextEditingController _phoneNoController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _domainPassController = TextEditingController();
  final ECOMRegisterBloc _registerBloc = ECOMRegisterBloc();

  // static bool _isChangePhone = false;
  static bool _isChangePass = false;

  ECOMRegisterView({super.key});

  void initialServices(BuildContext context) {
    if (!_isChangePass) {
      _passwordController.clear();
      _confirmPassController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Scaffold(
      body: BlocProvider<ECOMRegisterBloc>(
        create: (BuildContext context) => _registerBloc,
        child: BlocListener<ECOMRegisterBloc, ECOMRegisterState>(
          bloc: _registerBloc,
          listener: ((context, state) {
            if (state is ECOMRegisterLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is ECOMRegisterFailedState) {
              //pop loading dialog
              Navigator.pop(context);
              //
              DialogWidget.instance.openMsgDialog(
                title: 'Không thể đăng ký',
                msg: state.msg,
              );
            }
            if (state is ECOMRegisterSuccessState) {
              //pop loading dialog
              Navigator.of(context).pop();
              String userId = Session.instance.userECOMId;
              context.push('/ecom/bank/create/$userId');
            }
          }),
          child: Consumer<ECOMRegisterProvider>(
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
                        padding: EdgeInsets.only(left: 10, top: 5, right: 30),
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
                        padding: EdgeInsets.only(left: 10, top: 5, right: 30),
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
                        padding: EdgeInsets.only(left: 10, top: 5, right: 30),
                        child: Text(
                          'Xác nhận Mật khẩu không trùng khớp.',
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
                        isObscureText: false,
                        maxLines: 1,
                        hintText: 'Domain',
                        controller: _domainPassController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {},
                      ),
                    ),
                    Visibility(
                      visible: value.domainErr,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, top: 5, right: 30),
                        child: Text(
                          'Domain không được trống',
                          style: TextStyle(
                              color: DefaultTheme.RED_TEXT, fontSize: 13),
                        ),
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
    );
  }

  void backToPreviousPage(BuildContext context) {
    // _isChangePhone = false;
    _isChangePass = false;
    Provider.of<ECOMRegisterProvider>(context, listen: false).reset();
    context.go('/ecom');
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
                  Provider.of<ECOMRegisterProvider>(context, listen: false)
                      .updateErrs(
                          phoneErr: !StringUtils.instance
                              .isNumeric(_phoneNoController.text),
                          passErr: (!StringUtils.instance
                                  .isNumeric(_passwordController.text) ||
                              (_passwordController.text.length != 6)),
                          confirmPassErr:
                              !StringUtils.instance.isValidConfirmText(
                            _passwordController.text,
                            _confirmPassController.text,
                          ),
                          domainErr: _domainPassController.text.isEmpty);
                  if (Provider.of<ECOMRegisterProvider>(context, listen: false)
                      .isValidValidation()) {
                    String userIP =
                        await UserInformationUtils.instance.getIPAddress();
                    ECOMAccountLoginDTO dto = ECOMAccountLoginDTO(
                        phoneNo: _phoneNoController.text,
                        email: '',
                        password: EncryptUtils.instance.encrypted(
                          _phoneNoController.text,
                          _passwordController.text,
                        ),
                        device: userIP,
                        fcmToken: '',
                        platform: 'WEB',
                        hosting: _domainPassController.text);
                    _registerBloc.add(ECOMRegisterEventSubmit(dto: dto));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
