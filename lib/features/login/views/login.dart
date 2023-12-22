import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/descede.dart';
import 'package:VietQR/commons/utils/encrypt_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/header/menu_login.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/login/blocs/login_bloc.dart';
import 'package:VietQR/features/login/events/login_event.dart';
import 'package:VietQR/features/login/frames/login_frame.dart';
import 'package:VietQR/features/login/provider/login_provider.dart';
import 'package:VietQR/features/login/states/login_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_login_dto.dart';
import 'package:VietQR/models/info_user_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../models/account_login_method_dto.dart';
import '../widgets/login_by_card_widget.dart';

class Login extends StatefulWidget {
  final String pathHistory;
  const Login({Key? key, this.pathHistory = ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  static final TextEditingController phoneNoController =
      TextEditingController();

  final LoginBloc _loginBloc = LoginBloc();
  static String code = '';
  AESConvert des = AESConvert();
  InfoUserDTO _userDTO = InfoUserDTO();
  String qrValue = '';

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    context.push('/home');
                  }
                }
                if (state is LoginQRSuccessfulState) {
                  Navigator.of(context).pop();
                  context.push('/home');
                }
                if (state is ExistPhoneState) {
                  Navigator.of(context).pop();
                  _userDTO = state.infoUserDTO;

                  openPinDialog(context);
                }
                if (state is NotExistPhoneState) {
                  Navigator.of(context).pop();

                  //show msg dialog
                  DialogWidget.instance.openMsgDialog(
                    title: 'Đăng nhập không thành công',
                    msg: 'Tài khoản không tồn tại',
                  );
                }
                if (state is LoginFailedState) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  //pop loading dialog
                  Navigator.of(context).pop();

                  //show msg dialog
                  DialogWidget.instance.openMsgDialog(
                    title: 'Đăng nhập không thành công',
                    msg: 'Tài khoản đăng nhập hoặc mật khẩu không hợp lệ',
                  );
                }
              }),
              child: LoginFrame(
                width: width,
                height: height,
                menuTop: const MenuLogin(),
                widget1: _buildWidget1(
                    width: width,
                    isResized: PlatformUtils.instance.resizeWhen(width, 750),
                    height: 604,
                    provider: provider),
                widget2: _buildQrLogin(),
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
      '0769231213',
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
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
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColor.BLUE_TEXT),
                  ),
                ),
              ),
            ),
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
            child: QrImage(
              data: qrValue,
              size: 305,
              embeddedImage:
                  ImageUtils.instance.getImageNetWork(AppImages.icVietQrLogin),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(30, 30),
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
              'Sử dụng ứng dụng VietQR trên điện thoại để quét mã đăng nhập.',
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
}
