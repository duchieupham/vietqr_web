import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/ambient_avatar_widget.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/checkbox_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/information_user/blocs/information_user_bloc.dart';
import 'package:VietQR/features/information_user/events/information_user_event.dart';

import 'package:VietQR/features/information_user/frame/user_information_frame.dart';
import 'package:VietQR/features/information_user/states/information_user_state.dart';
import 'package:VietQR/features/information_user/views/popup_change_pass.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/services/providers/add_business_provider.dart';
import 'package:VietQR/services/providers/user_information_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class UserInformationView extends StatelessWidget {
  UserInformationView({super.key});

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalIdController =
      TextEditingController(text: '');
  final TextEditingController _oldNationalIdController =
      TextEditingController(text: '');

  static String _birthDate = '';
  static String _nationalDate = '';
  static late InformationUserBloc _userInformationBloc;
  initPage(BuildContext context) {
    _userInformationBloc = BlocProvider.of(context);
    _userInformationBloc.add(GetInformationUserEvent(
        userId: UserInformationHelper.instance.getUserId()));
    final AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();
    if (accountInformationDTO.lastName.isNotEmpty &&
        _lastNameController.text.isEmpty) {
      _lastNameController.value = _lastNameController.value
          .copyWith(text: accountInformationDTO.lastName);
    }
    if (accountInformationDTO.middleName.isNotEmpty &&
        _middleNameController.text.isEmpty) {
      _middleNameController.value = _middleNameController.value
          .copyWith(text: accountInformationDTO.middleName);
    }
    if (accountInformationDTO.firstName.isNotEmpty &&
        _firstNameController.text.isEmpty) {
      _firstNameController.value = _firstNameController.value
          .copyWith(text: accountInformationDTO.firstName);
    }
    if (accountInformationDTO.email.isNotEmpty &&
        _emailController.text.isEmpty) {
      _emailController.value =
          _emailController.value.copyWith(text: accountInformationDTO.email);
    }
    _birthDate = accountInformationDTO.birthDate;
    if (accountInformationDTO.nationalDate.isEmpty) {
      _nationalDate = '22/11/1970';
    } else {
      _nationalDate = accountInformationDTO.nationalDate;
    }

    if (accountInformationDTO.address.isNotEmpty &&
        _addressController.text.isEmpty) {
      _addressController.value = _addressController.value
          .copyWith(text: accountInformationDTO.address);
    }
    if (accountInformationDTO.nationalId.isNotEmpty &&
        _nationalIdController.text.isEmpty) {
      _nationalIdController.value = _nationalIdController.value
          .copyWith(text: accountInformationDTO.nationalId);
    }
    if (accountInformationDTO.oldNationalId.isNotEmpty &&
        _oldNationalIdController.text.isEmpty) {
      _oldNationalIdController.value = _oldNationalIdController.value
          .copyWith(text: accountInformationDTO.oldNationalId);
    }
  }

  String getTextBirtDate() {
    if (_birthDate == '22/11/1970') {
      return 'Chọn ngày sinh';
    } else {
      return _birthDate;
    }
  }

  String getTextNationalDate() {
    if (_nationalDate.isEmpty) {
      return 'Chọn ngày cấp CCCD';
    } else {
      return _nationalDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    initPage(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: UserInformationFrame(
        widget1: [
          _buildAvatarWidget(context),
          _buildButtonLeft(context),
        ],
        widget2: [_buildWidgetRight(context)],
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 180;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Consumer<AddBusinessProvider>(
        builder: (context, provider, child) {
          return (provider.bytesData != null)
              ? AmbientAvatarWidget(
                  imgId: imgId,
                  size: size,
                  imageFile: provider.bytesData,
                )
              : (imgId.isEmpty)
                  ? ClipOval(
                      child: SizedBox(
                        width: size,
                        height: size,
                        child: Image.asset('assets/images/ic-avatar.png'),
                      ),
                    )
                  : AmbientAvatarWidget(imgId: imgId, size: size);
        },
      ),
    );
  }

  Widget _buildButtonLeft(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        ButtonWidget(
          height: 40,
          borderRadius: 8,
          text: 'Cập nhật ảnh đại diện',
          textColor: DefaultTheme.BLUE_TEXT,
          bgColor: Theme.of(context).cardColor,
          function: () async {
            DialogWidget.instance.openMsgDialog(
              title: 'Tính năng đang bảo trì',
              msg: 'Vui lòng thử lại sau',
            );
            // Provider.of<AddBusinessProvider>(context, listen: false)
            //     .openImagePicker(upload: (byteData) async {
            //   await Future.delayed(const Duration(milliseconds: 200), () {
            //     String userId = UserInformationHelper.instance.getUserId();
            //     String imgId = UserInformationHelper.instance
            //         .getAccountInformation()
            //         .imgId;
            //     _userInformationBloc.add(
            //       UserEditAvatarEvent(
            //           userId: userId, imgId: imgId, imageByte: byteData),
            //     );
            //   });
            // });
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        ButtonWidget(
          text: 'Đổi mật khẩu',
          height: 40,
          borderRadius: 8,
          textColor: DefaultTheme.BLUE_TEXT,
          bgColor: Theme.of(context).cardColor,
          function: () {
            DialogWidget.instance.openPopup(
                child: ModalUpdatePassword(
                  passWord: (pass) {
                    _userInformationBloc.add(
                      InformationUserEditPassEvent(
                        userId: UserInformationHelper.instance.getUserId(),
                        phoneNo: UserInformationHelper.instance.getPhoneNo(),
                        oldPassword: pass['oldPass'],
                        newPassword: pass['newPass'],
                      ),
                    );
                  },
                ),
                width: 450,
                height: 500);
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        ButtonIconWidget(
          width: double.infinity,
          height: 40,
          icon: Icons.remove_circle_outline_rounded,
          title: 'Xoá tài khoản',
          function: () {
            DialogWidget.instance.openBoxWebConfirm(
              title: 'Xác nhận xoá tài khoản',
              confirmText: 'Đồng ý',
              imageAsset: 'assets/images/ic-warning.png',
              description:
                  'Tài khoản của bạn sẽ bị vô hiệu hoá và không thể đăng nhập lại vào hệ thống',
              confirmFunction: () {
                Navigator.pop(context);
                String userId = UserInformationHelper.instance.getUserId();
                _userInformationBloc.add(UserDeActiveEvent(userId: userId));
              },
              confirmColor: DefaultTheme.RED_TEXT,
            );
          },
          bgColor: Theme.of(context).cardColor.withOpacity(0.6),
          textColor: DefaultTheme.RED_TEXT,
        ),
      ],
    );
  }

  Widget _buildWidgetRight(BuildContext context) {
    return BlocListener<InformationUserBloc, InformationUserState>(
      listener: ((context, state) {
        if (state is InformationUserLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is InformationUserSuccessfulState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgSuccessDialog(
              title: 'Thành công', msg: 'Bạn đã cập nhật thông tin thành công');
        }
        if (state is InformationUserFailedState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgDialog(
              title: 'Không thể cập nhật thông tin', msg: state.msg);
        }

        if (state is InformationUserPasswordFailedState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể cập nhật Mật khẩu',
            msg: state.msg,
          );
        }
        if (state is InformationUserPasswordSuccessfulState) {
          //pop loading dialog
          Navigator.pop(context);
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgSuccessDialog(
              title: 'Thành công', msg: 'Bạn đã thay đổi mật khẩu thành công');
        }
        if (state is UserDeActiveFailedState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể xoá tài khoản',
            msg: state.message,
          );
        }
        if (state is InformationUserAvatarFailedState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể cập nhật ảnh đại diện',
            msg: state.message,
          );
        }
      }),
      child: Consumer<UserInformationProvider>(
          builder: (context, provider, child) {
        return Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            BoxLayout(
              width: double.infinity,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFieldWidget(
                    textfieldType: TextfieldType.LABEL,
                    fontSize: 14,
                    isObscureText: false,
                    title: 'Họ',
                    hintText: 'Nhập họ',
                    textAlign: TextAlign.right,
                    controller: _lastNameController,
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: (vavlue) {
                      provider.setAvailableUpdate(true);
                    },
                  ),
                  const DividerWidget(width: double.infinity),
                  TextFieldWidget(
                    textfieldType: TextfieldType.LABEL,
                    isObscureText: false,
                    title: 'Tên đệm',
                    fontSize: 14,
                    hintText: 'Nhập tên đệm',
                    textAlign: TextAlign.right,
                    controller: _middleNameController,
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: (vavlue) {
                      provider.setAvailableUpdate(true);
                    },
                  ),
                  const DividerWidget(width: double.infinity),
                  TextFieldWidget(
                    textfieldType: TextfieldType.LABEL,
                    isObscureText: false,
                    fontSize: 14,
                    textAlign: TextAlign.right,
                    title: 'Tên',
                    hintText: 'Nhập tên',
                    controller: _firstNameController,
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.next,
                    onChange: (vavlue) {
                      provider.setAvailableUpdate(true);
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: provider.firstNameErr,
              child: const Padding(
                padding: EdgeInsets.only(top: 5, left: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Tên không được bỏ trống.',
                    style: TextStyle(
                      color: DefaultTheme.RED_TEXT,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            BoxLayout(
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Ngày sinh',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        DialogWidget.instance.openDateTimePickerDialog(context,
                            (date) {
                          provider.setAvailableUpdate(true);
                          _birthDate =
                              TimeUtils.instance.formatDate(date.toString());
                        }, TimeUtils.instance.getDateFromString(_birthDate));
                      },
                      child: Text(
                        getTextBirtDate(),
                        style: const TextStyle(fontSize: 14),
                      )),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            BoxLayout(
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  const Text(
                    'Giới tính',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Nam',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  CheckBoxWidget(
                    check: (provider.gender == 0),
                    size: 20,
                    function: () {
                      provider.setAvailableUpdate(true);
                      provider.updateGender(0);
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  const Text(
                    'Nữ',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  CheckBoxWidget(
                    check: (provider.gender != 0),
                    size: 20,
                    function: () {
                      provider.setAvailableUpdate(true);
                      provider.updateGender(1);
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            BoxLayout(
              width: double.infinity,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  BoxLayout(
                    borderRadius: 8,
                    // height: 55,
                    padding: EdgeInsets.zero,
                    child: TextFieldWidget(
                      textfieldType: TextfieldType.LABEL,
                      isObscureText: false,
                      title: 'Email',
                      hintText: 'user@gmail.com',
                      controller: _emailController,
                      fontSize: 14,
                      textAlign: TextAlign.right,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                      onChange: (vavlue) {
                        provider.setAvailableUpdate(true);
                      },
                    ),
                  ),
                  if (provider.isValidEmailErr)
                    const Padding(
                      padding: EdgeInsets.only(top: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Email không đúng định dạng',
                          style: TextStyle(
                            color: DefaultTheme.RED_TEXT,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  const DividerWidget(width: double.infinity),
                  BoxLayout(
                    borderRadius: 8,
                    // height: 55,
                    padding: EdgeInsets.zero,
                    child: TextFieldWidget(
                      titleWidth: 150,
                      textfieldType: TextfieldType.LABEL,
                      isObscureText: false,
                      title: 'Căn cước công dân',
                      hintText: 'Nhập căn cước công dân',
                      controller: _nationalIdController,
                      fontSize: 14,
                      textAlign: TextAlign.right,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                      onChange: (vavlue) {
                        provider.setAvailableUpdate(true);
                      },
                    ),
                  ),
                  const DividerWidget(width: double.infinity),
                  BoxLayout(
                    borderRadius: 8,
                    // height: 55,
                    padding: EdgeInsets.zero,
                    child: TextFieldWidget(
                      titleWidth: 160,
                      textfieldType: TextfieldType.LABEL,
                      isObscureText: false,
                      title: 'Chứng minh nhân dân cũ',
                      hintText: 'Nhập chứng minh nhân dân cũ',
                      controller: _oldNationalIdController,
                      fontSize: 14,
                      textAlign: TextAlign.right,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                      onChange: (vavlue) {
                        provider.setAvailableUpdate(true);
                      },
                    ),
                  ),
                  const DividerWidget(width: double.infinity),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Ngày cấp Căn cước công dân',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              DialogWidget.instance
                                  .openDateTimePickerDialog(context, (date) {
                                provider.setAvailableUpdate(true);
                                _nationalDate = TimeUtils.instance
                                    .formatDate(date.toString());
                              },
                                      TimeUtils.instance
                                          .getDateFromString(_nationalDate));
                            },
                            child: Text(
                              getTextNationalDate(),
                              style: const TextStyle(fontSize: 14),
                            )),
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            BoxLayout(
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 90,
                    child: Text(
                      'Địa chỉ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TextField(
                          maxLines: 10,
                          controller: _addressController,
                          textInputAction: TextInputAction.done,
                          maxLength: 1000,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Nhập địa chỉ thường trú',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                          onChanged: (value) {
                            provider.setAvailableUpdate(true);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                top: 10,
              ),
              child: Visibility(
                visible: provider.availableUpdate,
                child: ButtonWidget(
                  height: 40,
                  borderRadius: 8,
                  text: 'Cập nhật',
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.BLUE_CARD,
                  function: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    provider.updateErrors(_firstNameController.text.isEmpty);
                    provider.updateEmailErrors(_emailController.text);
                    if (provider.isValidUpdate()) {
                      AccountInformationDTO accountInformationDTO =
                          AccountInformationDTO(
                        userId: UserInformationHelper.instance.getUserId(),
                        firstName: _firstNameController.text,
                        middleName: _middleNameController.text,
                        lastName: _lastNameController.text,
                        birthDate: _birthDate,
                        gender: provider.gender,
                        address: _addressController.text,
                        email: _emailController.text,
                        nationalDate: _nationalDate,
                        nationalId: _nationalIdController.text,
                        oldNationalId: _oldNationalIdController.text,
                        imgId: UserInformationHelper.instance
                            .getAccountInformation()
                            .imgId,
                        phoneNo: '',
                      );
                      _userInformationBloc.add(
                        InformationUserEditEvent(
                          dto: accountInformationDTO,
                        ),
                      );
                      provider.reset();
                    }
                  },
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
