import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/login/blocs/login_bloc.dart';
import 'package:VietQR/features/login/events/login_event.dart';
import 'package:VietQR/features/login/frames/login_frame.dart';
import 'package:VietQR/features/login/states/login_state.dart';
import 'package:VietQR/features/login/views/create_QRCode.dart';
import 'package:VietQR/features/login/widgets/login_by_card_widget.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/models/account_login_method_dto.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  static final TextEditingController phoneNoController =
      TextEditingController();

  static late LoginBloc _loginBloc;
  static String code = '';
  static const Uuid uuid = Uuid();

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
      body: BlocListener<LoginBloc, LoginState>(
        listener: ((context, state) {
          if (state is LoginLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is LoginSuccessfulState) {
            // _loginBloc.add(LoginEventGetUserInformation(userId: state.userId));
            //pop loading dialog
            Navigator.of(context).pop();
            //   //navigate to home screen
            //   Navigator.of(context).popUntil((route) => route.isFirst);
            //   Navigator.of(context).pushReplacementNamed(Routes.HOME,
            //       arguments: {'isFromLogin': true});
            context.push('/home');
          }
          if (state is LoginFailedState) {
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
        child: LoginFrame(
          width: width,
          height: height,
          widget1: _buildWidget1(
            width: width,
            isResized: PlatformUtils.instance.resizeWhen(width, 750),
          ),
          widget2: const CreateQRCode(),
        ),
      ),
    );
  }

  void openPinDialog(BuildContext context) {
    if (phoneNoController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Đăng nhập không thành công',
          msg: 'Vui lòng nhập số điện thoại để đăng nhập.');
    } else {
      String phoneNo = '';
      String email = '';
      if (StringUtils.instance.isNumeric(phoneNoController.text.trim())) {
        phoneNo = phoneNoController.text.trim();
      } else {
        email = phoneNoController.text.trim();
      }
      DialogWidget.instance.openPINDialog(
          title: 'Nhập Mật khẩu',
          onDone: (pin) {
            Navigator.of(context).pop();
            AccountLoginDTO dto = AccountLoginDTO(
              phoneNo: phoneNo,
              email: email,
              password: EncryptUtils.instance.encrypted(
                phoneNoController.text,
                pin,
              ),
              device: '',
              fcmToken: '',
              platform: '',
            );
            _loginBloc.add(
              LoginEventByPhone(dto: dto),
            );
          });
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
          height: 20,
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
            onSubmitted: (value) {
              openPinDialog(context);
            },
            onChange: (vavlue) {},
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                DialogWidget.instance.openMsgDialog(
                  title: 'Tính năng bảo trì',
                  msg:
                      'Chúng tôi đang thực hiện bảo trì tính năng này. Vui lòng thử lại sau.',
                );
              },
              child: const Text(
                'Quên mật khẩu?',
              ),
            ),
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
        const Padding(padding: EdgeInsets.only(top: 10)),
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
                  openPinDialog(context);
                },
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 15)),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: SizedBox(
            width: width,
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: _buildButtonSignIn(
                    assetImage: 'assets/images/logo-google.png',
                    text: 'Đăng nhập với Google',
                    function: () {
                      DialogWidget.instance.openMsgDialog(
                        title: 'Tính năng bảo trì',
                        msg:
                            'Chúng tôi đang thực hiện bảo trì tính năng này. Vui lòng thử lại sau.',
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: _buildButtonSignIn(
                    assetImage: 'assets/images/ic-card.png',
                    text: 'VietQR ID',
                    bgColor: DefaultTheme.PURPLE_NEON,
                    textColor: DefaultTheme.WHITE,
                    function: () async {
                      await DialogWidget.instance
                          .openPopup(
                        child: LoginByCardWidget(),
                        width: 500,
                        height: 500,
                      )
                          .then((value) {
                        if (value != null) {
                          AccountLoginMethodDTO accountLoginMethodDTO =
                              AccountLoginMethodDTO(
                            method: 'CARD',
                            cardNumber: value,
                            userId: '',
                            platform: '',
                            device: '',
                            fcmToken: '',
                          );
                          _loginBloc.add(LoginEventByCardNumber(
                              dto: accountLoginMethodDTO));
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        ButtonWidget(
          width: width,
          height: 40,
          text: 'Đăng ký',
          borderRadius: 5,
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.BLUE_TEXT,
          function: () {
            context.go('/register');
          },
        ),

        if (PlatformUtils.instance.resizeWhen(width, 850)) ...[
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildQrLogin(),
        ],
      ],
    );
  }

  Widget _buildButtonSignIn({
    required String assetImage,
    required String text,
    required VoidCallback function,
    Color? bgColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: function,
      child: BoxLayout(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        enableShadow: true,
        borderRadius: 5,
        bgColor: bgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetImage,
              width: 30,
              height: 30,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BoxLayout(
              width: 190,
              height: 190,
              borderRadius: 5,
              enableShadow: true,
              alignment: Alignment.center,
              bgColor: DefaultTheme.WHITE,
              padding: const EdgeInsets.all(0),
              child: QrImage(
                data: code,
                size: 200,
                embeddedImage:
                    const AssetImage('assets/images/ic-viet-qr-login.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(30, 30),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            const Text(
              'Đăng nhập bằng QR Code',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const SizedBox(
              width: 250,
              child: Text(
                'Sử dụng ứng dụng VietQR trên điện thoại để quét mã đăng nhập.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
