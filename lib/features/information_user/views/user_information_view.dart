import 'dart:io';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/file_utils.dart';
import 'package:VietQR/commons/widgets/ambient_avatar_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/information_user/blocs/information_user_bloc.dart';
import 'package:VietQR/features/information_user/events/information_user_event.dart';

import 'package:VietQR/features/information_user/frame/user_information_frame.dart';
import 'package:VietQR/services/providers/add_business_provider.dart';
import 'package:VietQR/services/providers/user_information_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserInformationView extends StatelessWidget {
  UserInformationView({super.key});
  final ImagePicker imagePicker = ImagePicker();
  static late InformationUserBloc _userInformationBloc;
  initPage(BuildContext context) {
    _userInformationBloc = BlocProvider.of(context);
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
        widget2: [],
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    double size = 120;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Consumer<UserInformationProvider>(
        builder: (context, provider, child) {
          return (provider.imageFile != null)
              ? AmbientAvatarWidget(
                  imgId: imgId,
                  size: size,
                  imageFile: provider.imageFile,
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
          textColor: DefaultTheme.GREEN,
          bgColor: Theme.of(context).cardColor.withOpacity(0.6),
          function: () async {
            // await Permission.mediaLibrary.request();
            await imagePicker.pickImage(source: ImageSource.gallery).then(
              (pickedFile) async {
                if (pickedFile != null) {
                  File? file = File(pickedFile.path);
                  File? compressedFile = FileUtils.instance.compressImage(file);
                  Provider.of<AddBusinessProvider>(context, listen: false)
                      .setImage(compressedFile);
                  await Future.delayed(const Duration(milliseconds: 200), () {
                    String userId = UserInformationHelper.instance.getUserId();
                    String imgId = UserInformationHelper.instance
                        .getAccountInformation()
                        .imgId;
                    _userInformationBloc.add(
                      UserEditAvatarEvent(
                          userId: userId, imgId: imgId, image: compressedFile),
                    );
                  });
                }
              },
            );
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        ButtonWidget(
          text: 'Đổi mật khẩu',
          height: 40,
          borderRadius: 8,
          textColor: DefaultTheme.GREEN,
          bgColor: Theme.of(context).cardColor.withOpacity(0.6),
          function: () {
            // Navigator.of(context)
            //     .pushNamed(Routes.UPDATE_PASSWORD);
          },
        ),
      ],
    );
  }
}
