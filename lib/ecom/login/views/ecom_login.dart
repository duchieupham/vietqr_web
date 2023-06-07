import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/ecom/login/events/ecom_login_event.dart';
import 'package:VietQR/ecom/login/frames/ecom_login_frame.dart';
import 'package:VietQR/ecom/login/model/account_login_dto.dart';
import 'package:VietQR/ecom/login/states/ecom_login_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ecom_login_bloc.dart';

class ECOMLogin extends StatefulWidget {
  const ECOMLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<ECOMLogin> {
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late ECOMLoginBloc _loginBloc;
  String code = '';
  Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    code = uuid.v1();
    _loginBloc = BlocProvider.of(context);
    // _loginBloc.add(LoginEventInsertCode(code: code, loginBloc: _loginBloc));
  }

  @override
  void dispose() {
    // LoginRepository.codeLoginController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocListener<ECOMLoginBloc, ECOMLoginState>(
        listener: ((context, state) {
          if (state is ECOMLoginLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is ECOMLoginSuccessfulState) {
            Navigator.of(context).pop();
            context.push('/ecom/home');
          }
          if (state is ECOMLoginFailedState) {
            FocusManager.instance.primaryFocus?.unfocus();
            //pop loading dialog
            Navigator.of(context).pop();

            //show msg dialog
            DialogWidget.instance.openMsgDialog(
              title: 'Đăng nhập không thành công',
              msg:
                  'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
            );
          }
        }),
        child: ECOMLoginFrame(
          width: width,
          height: height,
          widget1: _buildWidget1(
            width: width,
            isResized: PlatformUtils.instance.resizeWhen(width, 750),
          ),
          widget2: const SizedBox.shrink(),
        ),
      ),
    );
  }

  void login(BuildContext context) {
    if (phoneNoController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Đăng nhập không thành công',
          msg: 'Vui lòng nhập số điện thoại để đăng nhập.');
    } else if (passwordController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Đăng nhập không thành công',
          msg: 'Vui lòng nhập mật khẩu để đăng nhập.');
    } else if (domainController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Đăng nhập không thành công',
          msg: 'Vui lòng nhập domain để đăng nhập.');
    } else {
      String phoneNo = '';
      String email = '';
      if (StringUtils.instance.isNumeric(phoneNoController.text.trim())) {
        phoneNo = phoneNoController.text.trim();
      } else {
        email = phoneNoController.text.trim();
      }
      ECOMAccountLoginDTO dto = ECOMAccountLoginDTO(
          phoneNo: phoneNo,
          email: email,
          password: EncryptUtils.instance.encrypted(
            phoneNoController.text,
            passwordController.text,
          ),
          device: '',
          fcmToken: '',
          platform: '',
          hosting: domainController.text);
      _loginBloc.add(
        ECOMLoginEventByPhone(dto: dto),
      );
    }
  }

  Widget _buildWidget1({required bool isResized, required double width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Image.asset(
          'assets/images/logo-vietqr-vn.png',
          width: 200,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(
          height: 30,
        ),
        BorderLayout(
          width: width,
          isError: false,
          child: TextFieldWidget(
            width: width,
            isObscureText: false,
            autoFocus: true,
            hintText: 'Số điện thoại',
            controller: phoneNoController,
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.done,
            onChange: (vavlue) {},
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BorderLayout(
          width: width,
          isError: false,
          child: TextFieldWidget(
            width: width,
            isObscureText: true,
            autoFocus: true,
            hintText: 'Password',
            controller: passwordController,
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.done,
            onChange: (vavlue) {},
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BorderLayout(
          width: width,
          isError: false,
          child: TextFieldWidget(
            width: width,
            isObscureText: false,
            autoFocus: true,
            hintText: 'Domain',
            controller: domainController,
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.done,
            onChange: (vavlue) {},
          ),
        ),
        // const Padding(padding: EdgeInsets.only(top: 15)),
        // const Text(
        //   'Quên mật khẩu?',
        //   style: TextStyle(
        //     color: DefaultTheme.GREEN,
        //     fontSize: 15,
        //   ),
        // ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Row(
          children: [
            Expanded(
              child: ButtonWidget(
                width: width,
                height: 40,
                text: 'Đăng nhập',
                borderRadius: 5,
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  login(context);
                },
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DividerWidget(width: width),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'hoặc',
                  style: TextStyle(
                    fontSize: 13,
                    color: DefaultTheme.GREY_TEXT,
                  ),
                ),
              ),
              Expanded(
                child: DividerWidget(width: width),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        ButtonWidget(
          width: width,
          height: 40,
          text: 'Đăng ký',
          borderRadius: 5,
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.BLUE_TEXT,
          function: () {
            context.go('/ecom/register');
          },
        ),

        if (PlatformUtils.instance.resizeWhen(width, 850)) ...[
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ],
    );
  }
}
