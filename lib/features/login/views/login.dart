import 'dart:async';

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/numeral.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/descede.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/header/menu_drawer.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/commons/widgets/n_pin_widget.dart';
import 'package:VietQR/commons/widgets/pin_code_input.dart';
import 'package:VietQR/commons/widgets/pin_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/login/blocs/login_bloc.dart';
import 'package:VietQR/features/login/events/login_event.dart';
import 'package:VietQR/features/login/frames/login_frame.dart';
import 'package:VietQR/features/login/frames/login_mobile_frame.dart';
import 'package:VietQR/features/login/provider/login_provider.dart';
import 'package:VietQR/features/login/states/login_state.dart';
import 'package:VietQR/features/login/widgets/popup_qr_widget.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/models/info_user_dto.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../models/account_login_method_dto.dart';
import '../widgets/login_by_card_widget.dart';
import 'dart:html' as html;

class Login extends StatefulWidget {
  final String pathHistory;

  const Login({Key? key, this.pathHistory = ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  static final TextEditingController phoneNoController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginBloc _loginBloc = LoginBloc();
  AESConvert des = AESConvert();
  InfoUserDTO _userDTO = InfoUserDTO();
  String qrValue = '';
  late PageController pageController = PageController();
  List<InfoUserDTO> _listInfoUsers = [];
  bool isMobileWeb = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool isLoginSelected = true;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _listInfoUsers = UserInformationHelper.instance.getLoginAccount();
    if (_listInfoUsers.isNotEmpty) {
      pageController = PageController(initialPage: 1);
    }

    String loginID = des.getLoginID();
    String randomKey = des.getRandomKey();
    String encrypted = des.getEncryptedString(loginID, randomKey);
    qrValue = des.encrypt(encrypted);
    WebSocketHelper.instance.listenLoginSocket(loginID, (data) {
      if (data['loginId'] == loginID && data['randomKey'] == randomKey) {
        _loginBloc.add(LoginQREvent(userId: data['userId']));
      }
    });
  }

  @override
  void dispose() {
    // LoginRepository.codeLoginController.close();
    _timer?.cancel();
    _pageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _containers.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        Future.delayed(Duration(seconds: 3), () {
          _currentPage = 0;
          _pageController.jumpToPage(_currentPage);
        });
      }
    });
  }
  // void _startAutoSlide() {
  //   _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
  //     if (_currentPage < _containers.length - 1) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }

  //     _pageController.animateToPage(
  //       _currentPage,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width < 750) {
      isMobileWeb = true;
    } else {
      isMobileWeb = false;
    }

    return Scaffold(
      body: ChangeNotifierProvider<LoginProvider>(
        create: (context) => LoginProvider()..init(),
        child: BlocProvider<LoginBloc>(
          create: (BuildContext context) => _loginBloc,
          child: Consumer<LoginProvider>(builder: (context, provider, child) {
            return BlocListener<LoginBloc, LoginState>(
              listener: ((context, state) async {
                if (state is LoginLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is LoginSuccessfulState) {
                  Navigator.of(context).pop();
                  List<String> list = [];
                  List<InfoUserDTO> listCheck =
                      UserInformationHelper.instance.getLoginAccount();

                  if (listCheck.isNotEmpty) {
                    if (listCheck.length == 3) {
                      listCheck.removeWhere((element) =>
                          element.phoneNo.trim() == _userDTO.phoneNo);

                      if (listCheck.length < 3) {
                        listCheck.add(_userDTO);
                      } else {
                        listCheck.sort((a, b) =>
                            a.expiryAsDateTime.compareTo(b.expiryAsDateTime));

                        listCheck.removeAt(2);
                        listCheck.add(_userDTO);
                      }
                    } else {
                      listCheck.removeWhere((element) =>
                          element.phoneNo.trim() == _userDTO.phoneNo);

                      listCheck.add(_userDTO);
                    }
                  } else {
                    listCheck.add(_userDTO);
                  }

                  if (listCheck.length >= 2) {
                    listCheck.sort((a, b) =>
                        a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
                  }
                  for (var element in listCheck) {
                    list.add(element.toSPJson().toString());
                  }

                  provider.updateListInfoUser(list);
                  if (widget.pathHistory.isNotEmpty) {
                    context.push(widget.pathHistory);
                  } else {
                    context.push('/transactions/list');
                  }
                }
                if (state is LoginQRSuccessfulState) {
                  Navigator.of(context).pop();
                  context.push('/transactions/list');
                }
                if (state is ExistPhoneState) {
                  Navigator.of(context).pop();
                  _userDTO = state.infoUserDTO;
                  if (isMobileWeb) {
                    setState(() {
                      pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOutQuart,
                      );
                    });
                  } else {
                    openPinDialog(context);
                  }
                }
                if (state is NotExistPhoneState) {
                  Navigator.of(context).pop();

                  //show msg dialog

                  context.go('/register?phone_number=${phoneNoController.text}',
                      extra: phoneNoController.text);
                  // DialogWidget.instance.openMsgDialog(
                  //   title: 'Đăng nhập không thành công',
                  //   msg: 'Tài khoản không tồn tại',
                  // );
                }
                if (state is LoginFailedState) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    _passwordController.clear();
                    // focusNode.dispose();
                    Provider.of<PinProvider>(context, listen: false).reset();
                  });
                  //pop loading dialog
                  Navigator.of(context).pop();

                  //show msg dialog
                  DialogWidget.instance.openMsgDialog(
                    title: 'Đăng nhập không thành công',
                    msg: 'Tài khoản đăng nhập hoặc mật khẩu không hợp lệ',
                  );
                }
              }),
              child: (PlatformUtils.instance.resizeWhen(width, 750))
                  ? LoginFrame(
                      width: width,
                      height: height,
                      menuTop: const MenuLogin(),
                      // widget1: _buildWidget1(
                      //     width: width,
                      //     isResized:
                      //         PlatformUtils.instance.resizeWhen(width, 750),
                      //     height: 604,
                      //     provider: provider),
                      // widget2: _buildQrLogin(),
                      // widget2: _buildSlide(),
                      widget1: _buildSlide(),
                      widget2: _buildLogin(
                          width: width,
                          isResized:
                              PlatformUtils.instance.resizeWhen(width, 750),
                          height: 604,
                          provider: provider),
                    )
                  : LoginMobileFrame(
                      width: width,
                      height: height,
                      menuTop: const MenuDrawer(),
                      widget1: _buildLoginMobileWeb(provider),
                    ),
            );
          }),
        ),
      ),
    );
  }

  void openPinDialog(BuildContext context) {
    print(
        '-------------------------------------${EncryptUtils.instance.encrypted(
      '0982125822',
      '000000',
    )}');
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

  Widget _buildLogin(
      {required bool isResized,
      required double width,
      required double height,
      required LoginProvider provider}) {
    final FocusNode focusNode = FocusNode();
    String phoneNo = '';
    String email = '';
    if (StringUtils.instance.isNumeric(phoneNoController.text.trim())) {
      phoneNo = phoneNoController.text.trim();
    } else {
      email = phoneNoController.text.trim();
    }
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: ImageUtils.instance
                              .getImageNetWork(AppImages.icInfoBlack),
                          width: 30,
                          height: 30,
                        ),
                        Text(
                          'VietQR ID Card',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BorderLayout(
              width: width,
              height: 50,
              borderColor: AppColor.GREY_DADADA,
              isError: false,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Image(
                    image: ImageUtils.instance
                        .getImageNetWork(AppImages.icPhoneBlack),
                    width: 30,
                    height: 30,
                  ),
                  Expanded(
                    child: TextFieldWidget(
                      height: 46,
                      width: width,
                      isObscureText: false,
                      autoFocus: true,
                      hintText: 'Số điện thoại*',
                      fontSize: 14,
                      controller: phoneNoController,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.done,
                      inputFormatter: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onSubmitted: (value) {
                        // _loginBloc.add(CheckExistPhone(
                        //     phone: phoneNoController.text.trim()));
                      },
                      onChange: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BorderLayout(
              width: width,
              height: 50,
              borderColor: AppColor.GREY_DADADA,
              isError: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Image(
                    image: ImageUtils.instance
                        .getImageNetWork(AppImages.icLockBlack),
                    width: 30,
                    height: 30,
                  ),
                  Expanded(
                    child: NPinWidget(
                      pinController: _passwordController,
                      alignment: Alignment.centerLeft,
                      width: 300,
                      pinSize: 15,
                      pinLength: Numeral.DEFAULT_PIN_LENGTH,
                      focusNode: focusNode,
                      onDone: (pin) {
                        AccountLoginDTO dto = AccountLoginDTO(
                          phoneNo: phoneNoController.text,
                          email: phoneNoController.text,
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
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Quên mật khẩu đăng nhập?',
              style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: () {
                AccountLoginDTO dto = AccountLoginDTO(
                  phoneNo: phoneNoController.text,
                  email: phoneNoController.text,
                  password: EncryptUtils.instance.encrypted(
                    phoneNoController.text,
                    _passwordController.text,
                  ),
                  device: '',
                  fcmToken: '',
                  platform: '',
                );

                _loginBloc.add(
                  LoginEventByPhone(dto: dto),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                ),
                child: const Center(
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 15, color: AppColor.WHITE),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                context.go('/register');
              },
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Center(
                  child: const Text(
                    'Đăng ký tài khoản mới',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: PopupQrWidget(
                        qrValue: qrValue,
                      ),
                    );
                  },
                );
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: ImageUtils.instance
                          .getImageNetWork(AppImages.icSuggest),
                      width: 30,
                      height: 30,
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF458BF8),
                          Color(0xFFFF8021),
                          Color(0xFFFF3751),
                          Color(0xFFC958DB)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Quét mã QR để đăng nhập vào website',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget1(
      {required bool isResized,
      required double width,
      required double height,
      required LoginProvider provider}) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // SizedBox(
            //     height: 200, width: 600, child: const MyEmbeddedScriptWidget()),
            if (provider.listInfoUsers.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Đăng nhập gần đây',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Chọn ảnh đại diện để đăng nhập lại',
                    style: TextStyle(fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.listInfoUsers.map((e) {
                        int index = provider.listInfoUsers.indexOf(e);
                        return Expanded(child: _buildItemUser(e, index));
                      }).toList(),
                    ),
                  ),
                  DividerWidget(
                    width: width,
                    color: AppColor.BLACK_BUTTON.withOpacity(0.3),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            else
              const SizedBox(),
            const Text(
              'Đăng nhập',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: provider.listInfoUsers.isNotEmpty ? 20 : 60,
            ),
            BorderLayout(
              width: width,
              borderColor: AppColor.BLACK_BUTTON.withOpacity(0.5),
              isError: false,
              child: TextFieldWidget(
                height: 46,
                width: width,
                isObscureText: false,
                autoFocus: true,
                hintText: 'Số điện thoại hoặc email',
                fontSize: 14,
                controller: phoneNoController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                inputFormatter: [
                  LengthLimitingTextInputFormatter(10),
                ],
                onSubmitted: (value) {
                  _loginBloc.add(
                      CheckExistPhone(phone: phoneNoController.text.trim()));
                },
                onChange: (value) {},
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 24)),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    width: width,
                    height: 40,
                    text: 'Tiếp tục',
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      print(
                          'hehhee-------------------------------------${EncryptUtils.instance.encrypted(
                        '0963223959',
                        '000000',
                      )}');
                      _loginBloc
                          .add(CheckExistPhone(phone: phoneNoController.text));
                    },
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 28)),
            SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DividerWidget(
                      width: width,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'hoặc',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.GREY_TEXT,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DividerWidget(
                      width: width,
                    ),
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
                        assetsIcon: AppImages.icCard,
                        text: 'VietQR ID Card',
                        bgColor: AppColor.WHITE,
                        textColor: AppColor.BLACK,
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
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 10, bottom: 12),
            //     child: InkWell(
            //       onTap: () {
            //         DialogWidget.instance.openMsgDialog(
            //           title: 'Tính năng bảo trì',
            //           msg:
            //               'Chúng tôi đang thực hiện bảo trì tính năng này. Vui lòng thử lại sau.',
            //         );
            //       },
            //       child: const Text(
            //         'Quên mật khẩu?',
            //         style: TextStyle(
            //             decoration: TextDecoration.underline,
            //             color: AppColor.BLUE_TEXT),
            //       ),
            //     ),
            //   ),
            // ),
            ButtonWidget(
              width: width,
              height: 40,
              text: 'Đăng ký tài khoản mới',
              borderRadius: 5,
              textColor: AppColor.BLUE_TEXT,
              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
              function: () {
                context.go('/register');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormLogin(
      {required bool isResized,
      required double width,
      required double height,
      required LoginProvider provider}) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
              width: 170,
            ),
            if (provider.listInfoUsers.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Đăng nhập gần đây',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Chọn ảnh đại diện để đăng nhập lại',
                    style: TextStyle(fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.listInfoUsers.map((e) {
                        int index = provider.listInfoUsers.indexOf(e);
                        return Expanded(child: _buildItemUser(e, index));
                      }).toList(),
                    ),
                  ),
                  DividerWidget(
                    width: width,
                    color: AppColor.BLACK_BUTTON.withOpacity(0.3),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            else
              const SizedBox(),
            SizedBox(
              height: provider.listInfoUsers.isNotEmpty ? 20 : 60,
            ),
            BorderLayout(
              width: width,
              borderColor: AppColor.BLACK_BUTTON.withOpacity(0.5),
              isError: false,
              child: TextFieldWidget(
                height: 46,
                width: width,
                isObscureText: false,
                autoFocus: true,
                hintText: 'Số điện thoại hoặc email',
                fontSize: 14,
                controller: phoneNoController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                inputFormatter: [
                  LengthLimitingTextInputFormatter(10),
                ],
                onSubmitted: (value) {
                  _loginBloc.add(
                      CheckExistPhone(phone: phoneNoController.text.trim()));
                },
                onChange: (value) {},
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 24)),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    width: width,
                    height: 40,
                    text: 'Tiếp tục',
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      _loginBloc
                          .add(CheckExistPhone(phone: phoneNoController.text));
                    },
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSignIn({
    String urlIcon = '',
    String assetsIcon = '',
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
        border: Border.all(color: AppColor.BLUE_TEXT),
        borderRadius: 5,
        bgColor: bgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: ImageUtils.instance.getImageNetWork(assetsIcon),
              width: 30,
              height: 30,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  final List<Widget> _containers = [
    Container(
      width: 600,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.step1Login),
            width: 400,
            height: 400,
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF9CD740),
                Color(0xFF2BACE6),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: const Text(
              'Ứng dụng Tiện ích, Đơn giản\ncho cuộc sống hiện đại',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    Container(
      width: 600,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF4260ED),
                Color(0xFFFC7218),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: const Text(
              'Thanh toán nhanh gọn,\nđối soát nhanh chóng',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quét mã VietQR thanh toán tức thì.\nHỗ trợ quét mã thanh toán cho tất cả  các ứng dụng ngân hàng và ví điện tử.',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.step2Login),
            width: 400,
            height: 260,
          ),
        ],
      ),
    ),
    Container(
      width: 600,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.step3Login),
            width: 400,
            height: 260,
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF3C5FFF),
                Color(0xFFEB5BEE),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: const Text(
              'Quản lý cửa hàng hiệu quả',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dữ liệu thống kê trực quan, đáng tin cậy.',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    ),
    Container(
      width: 600,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFFD711A),
                Color(0xFFDF263C),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: const Text(
              'Chia sẻ thông tin số dư\nqua nền tảng mạng xã hội',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.step4Login),
            width: 400,
            height: 260,
          ),
          const SizedBox(height: 8),
          Text(
            'Chia sẻ thông tin giao dịch với nhóm nhân viên của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoDiscord),
                width: 40,
                height: 40,
              ),
              Image(
                image: ImageUtils.instance.getImageNetWork(AppImages.logoSlark),
                width: 40,
                height: 40,
              ),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoGGSheet),
                width: 40,
                height: 40,
              ),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoGGChat),
                width: 40,
                height: 40,
              ),
              Image(
                image: ImageUtils.instance
                    .getImageNetWork(AppImages.logoLarkLogin),
                width: 40,
                height: 40,
              ),
              Image(
                image: ImageUtils.instance
                    .getImageNetWork(AppImages.logoTeleLogin),
                width: 40,
                height: 40,
              ),
              SizedBox(width: 8),
              Text('và nhiều hơn thế!!!'),
            ],
          ),
        ],
      ),
    ),
    Container(
      width: 600,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Sử dụng bộ API Service của chúng tôi để tích hợp và\nquản trị trực tiếp trên hệ thống của bạn.',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.step5Login),
            width: 400,
            height: 260,
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF415FEB),
                Color(0xFF131C3B),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              'Tích hợp dịch vụ VietQR\nvào hệ thống của bạn',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              html.window.open('https://api.vietqr.vn/', 'new tab');
            },
            child: Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF458BF8),
                    Color(0xFFFF8021),
                    Color(0xFFFF3751),
                    Color(0xFFC958DB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    'Truy cập trang tài liệu kết nối API Service',
                    style: TextStyle(
                      color: Color(0xFF458BF8),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
  ];

  Widget _buildSlide() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: 600,
        height: 600,
        child: Row(
          children: [
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _containers,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_containers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    width: 10,
                    height: index == _currentPage ? 20 : 10,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? const Color(0xFF3048A1)
                          : AppColor.GREY_TEXT.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrLogin() {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Image(
            image: ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
            width: 170,
          ),
          const SizedBox(
            height: 40,
          ),
          BoxLayout(
            width: 340,
            height: 340,
            borderRadius: 20,
            alignment: Alignment.center,
            bgColor: AppColor.WHITE,
            padding: const EdgeInsets.all(8),
            child: QrImageView(
              data: qrValue,
              size: 305,
              embeddedImage:
                  const AssetImage('assets/images/ic-viet-qr-small.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(30, 30),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 40)),
          const Text(
            'Đăng nhập bằng QR Code',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          const SizedBox(
            width: 300,
            child: Text(
              // 'Sử dụng ứng dụng VietQR trên điện thoại để quét mã đăng nhập.',
              'Ứng dụng VietQR VN',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemUser(InfoUserDTO infoUserDTO, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _userDTO = infoUserDTO;
            phoneNoController.text = infoUserDTO.phoneNo;
            openPinDialog(context);
          },
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.GREY_BUTTON),
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                    image:
                        ImageUtils.instance.getImageNetWork(infoUserDTO.imgId),
                    fit: BoxFit.cover)),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          infoUserDTO.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          infoUserDTO.phoneNo,
          style: const TextStyle(color: AppColor.GREY_TEXT),
        ),
      ],
    );
  }

  Widget _buildFormLoginMobileWeb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 480,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
                width: 160,
              ),
            ),
            BorderLayout(
              bgColor: AppColor.WHITE,
              borderColor: AppColor.WHITE,
              isError: false,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('+84'),
                  ),
                  Container(
                    width: 1,
                    color: AppColor.BLACK.withOpacity(0.3),
                    height: 42,
                  ),
                  Expanded(
                    child: TextFieldWidget(
                      height: 42,
                      isObscureText: false,
                      autoFocus: true,
                      hintText: 'Nhập số điện thoại',
                      contentPadding:
                          const EdgeInsets.only(bottom: 6, left: 12),
                      fontSize: 14,
                      controller: phoneNoController,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.done,
                      inputFormatter: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onSubmitted: (value) {
                        if (value.toString().isNotEmpty) {
                          _loginBloc.add(CheckExistPhone(
                              phone: phoneNoController.text.trim()));
                        }
                      },
                      onChange: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 24)),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    height: 40,
                    text: 'Tiếp tục',
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      if (phoneNoController.text.isNotEmpty) {
                        _loginBloc.add(
                            CheckExistPhone(phone: phoneNoController.text));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildLoginMobileWeb(LoginProvider provider) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: SizedBox(
  //       height: 500,
  //       child: PageView(
  //         controller: pageController,
  //         physics: const NeverScrollableScrollPhysics(),
  //         children: [
  //           _buildFormLoginMobileWeb(),
  //           _buildListAccountMobileWeb(provider),
  //           _buildInputPassLoginMobileWeb(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoginMobileWeb(LoginProvider provider) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _redirectIfWeb();
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 500,
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildFormLoginMobileWeb(),
            _buildListAccountMobileWeb(provider),
            _buildInputPassLoginMobileWeb(),
          ],
        ),
      ),
    );
  }

  void _redirectIfWeb() {
    // Chỉ chạy khi nền tảng là Web
    if (identical(0, 0.0)) {
      html.window.location.href = 'https://api.vietqr.vn';
    }
  }

  Widget _buildListAccountMobileWeb(LoginProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
              width: 160,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: provider.listInfoUsers.map((e) {
                int index = provider.listInfoUsers.indexOf(e);
                return _buildItemUserLoginMobileWeb(e, index);
              }).toList(),
            ),
          ),
          InkWell(
            onTap: () {
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuart,
              );
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColor.BLUE_TEXT)),
              child: const Text(
                'Đăng nhập bằng tài khoản khác',
                style: TextStyle(color: AppColor.BLUE_TEXT),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuart,
              );
            },
            child: const Text(
              'Đăng nhập bằng tài khoản trước đó',
              style: TextStyle(
                  color: AppColor.BLUE_TEXT,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputPassLoginMobileWeb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, ${_userDTO.fullName}!',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    _userDTO.phoneNo,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Spacer(),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
                width: 80,
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const Text('Vui lòng nhập mật khẩu để đăng nhập'),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40,
            child: PinCodeInput(
              obscureText: true,
              autoFocus: true,
              fillWidth: 40,
              clBorderErr: AppColor.BLUE_TEXT,
              inactiveFillColor: AppColor.TRANSPARENT,
              selectedFillColor: AppColor.TRANSPARENT,
              onCompleted: (data) {
                AccountLoginDTO dto = AccountLoginDTO(
                  phoneNo: _userDTO.phoneNo,
                  email: '',
                  password: EncryptUtils.instance.encrypted(
                    phoneNoController.text,
                    data,
                  ),
                  device: '',
                  fcmToken: '',
                  platform: '',
                );

                _loginBloc.add(
                  LoginEventByPhone(dto: dto),
                );
              },
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOutQuart,
                    );
                  },
                  child: const Text(
                    'Đổi số điện thoại',
                    style: TextStyle(color: AppColor.BLUE_TEXT, fontSize: 13),
                  )),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  height: 40,
                  text: 'Đăng nhập',
                  borderRadius: 5,
                  textColor: AppColor.WHITE,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () {
                    if (_passwordController.text.isNotEmpty) {
                      AccountLoginDTO dto = AccountLoginDTO(
                        phoneNo: _userDTO.phoneNo,
                        email: '',
                        password: EncryptUtils.instance.encrypted(
                          phoneNoController.text,
                          _passwordController.text,
                        ),
                        device: '',
                        fcmToken: '',
                        platform: '',
                      );

                      _loginBloc.add(
                        LoginEventByPhone(dto: dto),
                      );
                    } else {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Nhập mật khẩu',
                          msg: 'Bạn vui lòng nhập mật khẩu trước để đăng nhập');
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuart,
              );
            },
            child: const Text(
              'Đăng nhập bằng tài khoản trước đó',
              style: TextStyle(
                  color: AppColor.BLUE_TEXT,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemUserLoginMobileWeb(InfoUserDTO infoUserDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _userDTO = infoUserDTO;
        });

        phoneNoController.text = infoUserDTO.phoneNo;
        pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutQuart,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: AppColor.WHITE),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.GREY_BUTTON),
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: ImageUtils.instance
                          .getImageNetWork(infoUserDTO.imgId),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoUserDTO.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  infoUserDTO.phoneNo,
                  style: const TextStyle(color: AppColor.GREY_TEXT),
                ),
              ],
            )),
            const Icon(
              Icons.arrow_forward,
              size: 18,
              color: AppColor.BLUE_TEXT,
            )
          ],
        ),
      ),
    );
  }
}
