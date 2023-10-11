import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class ModalUpdatePassword extends StatefulWidget {
  final Function(Map<String, dynamic>) passWord;
  const ModalUpdatePassword({super.key, required this.passWord});

  @override
  State<ModalUpdatePassword> createState() => _UserUpdatePasswordState();
}

class _UserUpdatePasswordState extends State<ModalUpdatePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPassController = TextEditingController();

  bool _isErrOldPass = false;
  bool _isErrNewPass = false;
  bool _isErrConfirmPass = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: width,
            child: Row(
              children: [
                const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).canvasColor.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: [
                TextFieldWidget(
                  width: width,
                  isObscureText: true,
                  textfieldType: TextfieldType.LABEL,
                  title: 'Mật khẩu cũ',
                  titleWidth: 120,
                  hintText: 'Mật khẩu hiện tại',
                  controller: _oldPasswordController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.next,
                  onChange: (vavlue) {},
                ),
                const Divider(
                  height: 0.5,
                  color: AppColor.GREY_LIGHT,
                ),
                TextFieldWidget(
                  width: width,
                  isObscureText: true,
                  textfieldType: TextfieldType.LABEL,
                  title: 'Mật khẩu mới',
                  titleWidth: 120,
                  hintText: 'Bao gồm 6 số',
                  controller: _newPasswordController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.next,
                  onChange: (vavlue) {},
                ),
                const Divider(
                  height: 0.5,
                  color: AppColor.GREY_LIGHT,
                ),
                TextFieldWidget(
                  width: width,
                  isObscureText: true,
                  textfieldType: TextfieldType.LABEL,
                  title: 'Xác nhận lại',
                  titleWidth: 120,
                  hintText: 'Xác nhận lại Mật khẩu mới',
                  controller: _confirmPassController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.next,
                  onChange: (vavlue) {},
                ),
                Visibility(
                  visible: _isErrOldPass,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5, right: 30),
                    child: Text(
                      'Mật khẩu cũ không đúng định dạng.',
                      style:
                          TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isErrNewPass,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5, right: 30),
                    child: Text(
                      'Mật khẩu mới bao gồm 6 số.',
                      style:
                          TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isErrConfirmPass,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5, right: 30),
                    child: Text(
                      'Xác nhận Mật khẩu không trùng khớp.',
                      style:
                          TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ButtonWidget(
              width: width - 40,
              text: 'Cập nhật',
              textColor: AppColor.WHITE,
              bgColor: AppColor.GREEN,
              function: () {
                _checkValidateOldPass();
                _checkValidateNewPass();
                _checkValidateConfirmPass();
                if (!_isErrOldPass && !_isErrNewPass && !_isErrConfirmPass) {
                  Map<String, dynamic> data = {
                    'oldPass': _oldPasswordController.text,
                    'newPass': _newPasswordController.text
                  };
                  widget.passWord(data);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _checkValidateOldPass() {
    if (_oldPasswordController.text.isEmpty ||
        _oldPasswordController.text.length < 6) {
      setState(() {
        _isErrOldPass = true;
      });
    } else {
      setState(() {
        _isErrOldPass = false;
      });
    }
  }

  void _checkValidateNewPass() {
    if (_newPasswordController.text.isEmpty ||
        _newPasswordController.text.length < 6) {
      setState(() {
        _isErrNewPass = true;
      });
    } else {
      setState(() {
        _isErrNewPass = false;
      });
    }
  }

  void _checkValidateConfirmPass() {
    if (_confirmPassController.text != _newPasswordController.text) {
      setState(() {
        _isErrConfirmPass = true;
      });
    } else {
      setState(() {
        _isErrConfirmPass = false;
      });
    }
  }
}
