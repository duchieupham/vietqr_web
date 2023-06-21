import 'dart:io';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:VietQR/commons/utils/file_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/business/blocs/business_information_bloc.dart';
import 'package:VietQR/features/business/events/business_information_event.dart';
import 'package:VietQR/features/business/states/business_information_state.dart';
import 'package:VietQR/features/business/widgets/add_business_member_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/branch_text_controller_dto.dart';
import 'package:VietQR/models/business_information_insert_dto.dart';
import 'package:VietQR/models/business_member_dto.dart';
import 'package:VietQR/services/providers/add_business_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBusinessView extends StatelessWidget {
  static final TextEditingController businessNameContorller =
      TextEditingController();
  static final TextEditingController addressController =
      TextEditingController();
  static final TextEditingController taxCodeController =
      TextEditingController();
  static final TextEditingController memberController = TextEditingController();

  static final ImagePicker imagePicker = ImagePicker();
  static late BusinessInformationBloc businessInformationBloc;

  const AddBusinessView({super.key});

  void initialServices(BuildContext context) {
    if (!Provider.of<AddBusinessProvider>(context, listen: false).isInitial) {
      businessInformationBloc = BlocProvider.of(context);
      String userId = UserInformationHelper.instance.getUserId();
      String name = UserInformationHelper.instance.getUserFullname();
      String phoneNo = UserInformationHelper.instance.getPhoneNo();
      String imgId =
          UserInformationHelper.instance.getAccountInformation().imgId;
      //role = 5: admin
      //role = 1: manager
      int role = 5;
      BusinessMemberDTO memberDTO = BusinessMemberDTO(
        userId: userId,
        name: name,
        role: role,
        phoneNo: phoneNo,
        imgId: imgId,
        //for checking user found or not
        status: '',
        existed: 0,
      );
      Future.delayed(const Duration(milliseconds: 0), () {
        Provider.of<AddBusinessProvider>(context, listen: false)
            .addMemberList(memberDTO);
        Provider.of<AddBusinessProvider>(context, listen: false)
            .setInitial(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: BlocListener<BusinessInformationBloc, BusinessInformationState>(
        listener: (context, state) {
          if (state is BusinessInformationLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is BusinessInformationInsertSuccessfulState) {
            Navigator.pop(context);
            reset(context);
            Fluttertoast.showToast(
              msg: 'Tạo thông tin doanh nghiệp thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
            Navigator.pop(context);
          }
          if (state is BusinessInformationInsertFailedState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Lỗi',
              msg: state.msg,
            );
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 185,
              child: Stack(
                children: [
                  Consumer<AddBusinessProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        width: double.infinity,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                          image: (provider.bytesData != null)
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.memory(
                                    provider.bytesData!,
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ).image)
                              : null,
                        ),
                      );
                    },
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          child: InkWell(
                              onTap: () {
                                reset(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(top: 8, right: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).cardColor),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                ),
                              )),
                        ),
                      ),
                      const Spacer(),
                      Consumer<AddBusinessProvider>(
                        builder: (context, provider, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: (provider.bytesData != null)
                                ? Image.memory(
                                    provider.bytesData!,
                                    fit: BoxFit.fitHeight,
                                    width: 80,
                                    height: 80,
                                  )
                                : Image.asset(
                                    'assets/images/ic-avatar-business.png',
                                    width: 80,
                                    fit: BoxFit.fitHeight,
                                    height: 80,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ButtonWidget(
                    width: double.infinity,
                    height: 40,
                    borderRadius: 10,
                    text: 'Cập nhật ảnh bìa',
                    textColor: DefaultTheme.GREEN,
                    bgColor: Theme.of(context).cardColor,
                    function: () async {
                      await imagePicker
                          .pickImage(source: ImageSource.gallery)
                          .then(
                        (pickedFile) {
                          if (pickedFile != null) {
                            File? file = File(pickedFile.path);
                            File? compressedFile =
                                FileUtils.instance.compressImage(file);
                            // Provider.of<AddBusinessProvider>(context,
                            //         listen: false)
                            //     .setCover(compressedFile);
                          }
                        },
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ButtonWidget(
                    width: double.infinity,
                    height: 40,
                    borderRadius: 10,
                    text: 'Cập nhật ảnh đại diện',
                    textColor: DefaultTheme.GREEN,
                    bgColor: Theme.of(context).cardColor,
                    function: () async {
                      await imagePicker
                          .pickImage(source: ImageSource.gallery)
                          .then(
                        (pickedFile) {
                          if (pickedFile != null) {
                            File? file = File(pickedFile.path);
                            File? compressedFile =
                                FileUtils.instance.compressImage(file);
                            // Provider.of<AddBusinessProvider>(context,
                            //         listen: false)
                            //     .setImage(compressedFile);
                          }
                        },
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Lưu ý:\n-   Các trường có dấu \u002A là bắt buộc.\n-   Nếu doanh nghiệp/tổ chức của bạn không bao gồm chi nhánh nào, thì một chi nhánh mặc định tương ứng với tên và địa chỉ doanh nghiệp sẽ được tạo.\n-   Các quản trị viên sẽ được nhận tất cả thông báo giao dịch từ các chi nhánh thuộc doanh nghiệp này.',
                    style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      height: 1.5,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Thông tin doanh nghiệp',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  BoxLayout(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFieldWidget(
                          autoFocus: false,
                          textfieldType: TextfieldType.LABEL,
                          titleWidth: 120,
                          isObscureText: false,
                          title: 'Tên doanh nghiệp \u002A',
                          hintText: 'Nhập tên doanh nghiệp',
                          fontSize: 13,
                          controller: businessNameContorller,
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onChange: (text) {},
                        ),
                        const DividerWidget(width: double.infinity),
                        TextFieldWidget(
                          autoFocus: false,
                          textfieldType: TextfieldType.LABEL,
                          titleWidth: 120,
                          isObscureText: false,
                          title: 'Địa chỉ \u002A',
                          hintText: 'Địa chỉ doanh nghiệp',
                          fontSize: 13,
                          controller: addressController,
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onChange: (text) {},
                        ),
                        const DividerWidget(width: double.infinity),
                        TextFieldWidget(
                          autoFocus: false,
                          textfieldType: TextfieldType.LABEL,
                          titleWidth: 120,
                          isObscureText: false,
                          title: 'Mã số thuế',
                          hintText: 'Mã số thuế của doanh nghiệp',
                          fontSize: 13,
                          controller: taxCodeController,
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.done,
                          onChange: (text) {},
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      const Text(
                        'Quản trị viên',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await DialogWidget.instance.showModalBottomContent(
                            widget: AddBusinessMemberWidget(
                              memberController: memberController,
                            ),
                            height: height * 0.4,
                          );
                        },
                        child: const Text(
                          'Thêm thành viên',
                          style: TextStyle(
                            color: DefaultTheme.GREEN,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<AddBusinessProvider>(
                    builder: (context, provider, child) {
                      return Visibility(
                        visible: provider.memberList.isNotEmpty,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.memberList.length,
                          itemBuilder: (context, index) {
                            return _buildMemberList(
                              context: context,
                              dto: provider.memberList[index],
                              index: index,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      const Text(
                        'Chi nhánh',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Provider.of<AddBusinessProvider>(context,
                                  listen: false)
                              .addTextController(
                            BranchTextController(
                              name: TextEditingController(),
                              address: TextEditingController(),
                            ),
                          );
                        },
                        child: const Text(
                          'Thêm chi nhánh',
                          style: TextStyle(
                            color: DefaultTheme.GREEN,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  Consumer<AddBusinessProvider>(
                    builder: (context, provider, child) {
                      return Visibility(
                        visible: provider.branchTextControllers.isNotEmpty,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.branchTextControllers.length,
                          itemBuilder: (context, index) {
                            return _buildAddBranchForm(
                              context: context,
                              controller: provider.branchTextControllers[index],
                              index: index,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: ButtonWidget(
                text: 'Lưu',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  if (isValidForm(context: context)) {
                    String userId = UserInformationHelper.instance.getUserId();
                    List<MemberBusinessInsertDTO> members = [];
                    List<BranchBusinessInsertDTO> branchs = [];
                    File? image;
                    // Provider.of<AddBusinessProvider>(context, listen: false)
                    //     .imageFile;
                    File? coverImage;
                    // Provider.of<AddBusinessProvider>(context, listen: false)
                    //     .coverImageFile;
                    List<BusinessMemberDTO> memberList =
                        Provider.of<AddBusinessProvider>(context, listen: false)
                            .memberList;
                    List<BranchTextController> branchList =
                        Provider.of<AddBusinessProvider>(context, listen: false)
                            .branchTextControllers;
                    if (memberList.isNotEmpty) {
                      for (BusinessMemberDTO member in memberList) {
                        members.add(MemberBusinessInsertDTO(
                          userId: member.userId,
                          role: member.role.toString(),
                        ));
                      }
                    }
                    if (branchList.isNotEmpty) {
                      for (BranchTextController branch in branchList) {
                        BranchBusinessInsertDTO branchInsertDTO =
                            BranchBusinessInsertDTO(
                          address: branch.address.text,
                          name: branch.name.text,
                        );
                        branchs.add(branchInsertDTO);
                      }
                    }
                    BusinessInformationInsertDTO dto =
                        BusinessInformationInsertDTO(
                      userId: userId,
                      name: businessNameContorller.text,
                      address: addressController.text,
                      taxCode: taxCodeController.text,
                      image: image,
                      coverImage: coverImage,
                      members: members,
                      branchs: branchs,
                    );
                    businessInformationBloc
                        .add(BusinessInformationEventInsert(dto: dto));
                  }
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberList(
      {required BuildContext context,
      required BusinessMemberDTO dto,
      required int index}) {
    final bool isAdmin =
        (dto.userId == UserInformationHelper.instance.getUserId());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          (dto.imgId.isNotEmpty)
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                )
              : ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/ic-avatar.png'),
                  ),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dto.name),
                Text(dto.phoneNo),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: (isAdmin) ? DefaultTheme.BLUE_TEXT : DefaultTheme.ORANGE,
            ),
            child: Text(
              (isAdmin) ? 'Admin' : 'Quản lý',
              style: const TextStyle(
                color: DefaultTheme.WHITE,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          (isAdmin)
              ? const SizedBox()
              : InkWell(
                  onTap: () {
                    Provider.of<AddBusinessProvider>(context, listen: false)
                        .removeMemberList(index);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: DefaultTheme.RED_TEXT.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.remove_rounded,
                      color: DefaultTheme.WHITE,
                      size: 12,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAddBranchForm({
    required BuildContext context,
    required BranchTextController controller,
    required int index,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        BoxLayout(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextFieldWidget(
                autoFocus: false,
                textfieldType: TextfieldType.LABEL,
                titleWidth: 80,
                width: width,
                isObscureText: false,
                title: 'Tên \u002A',
                hintText: '',
                fontSize: 13,
                controller: controller.name,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                onChange: (text) {},
              ),
              DividerWidget(width: width),
              TextFieldWidget(
                autoFocus: false,
                textfieldType: TextfieldType.LABEL,
                titleWidth: 80,
                width: width,
                isObscureText: false,
                title: 'Địa chỉ \u002A',
                hintText: '',
                fontSize: 13,
                controller: controller.address,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: (text) {},
              ),
            ],
          ),
        ),
        Positioned(
          right: 20,
          child: InkWell(
            onTap: () {
              Provider.of<AddBusinessProvider>(context, listen: false)
                  .removeTextController(index);
            },
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: DefaultTheme.RED_TEXT.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.remove_rounded,
                color: DefaultTheme.WHITE,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isValidForm({required BuildContext context}) {
    bool check = false;
    bool isOpenDialog = false;
    List<BranchTextController> branchList =
        Provider.of<AddBusinessProvider>(context, listen: false)
            .branchTextControllers;
    if (businessNameContorller.text.isEmpty) {
      if (!isOpenDialog) {
        isOpenDialog = true;
        DialogWidget.instance.openMsgDialog(
            title: 'Nhập thông tin',
            msg: 'Vui lòng nhập tên doanh nghiệp.',
            function: () {
              isOpenDialog = false;
              Navigator.pop(context);
            });
      }
    } else if (addressController.text.isEmpty) {
      if (!isOpenDialog) {
        isOpenDialog = true;
        DialogWidget.instance.openMsgDialog(
            title: 'Nhập thông tin',
            msg: 'Vui lòng nhập địa chỉ doanh nghiệp.',
            function: () {
              isOpenDialog = false;
              Navigator.pop(context);
            });
      }
    } else if (branchList.isNotEmpty) {
      int countValid = 0;
      for (BranchTextController controller in branchList) {
        if (controller.name.text.isEmpty) {
          if (!isOpenDialog) {
            isOpenDialog = true;
            DialogWidget.instance.openMsgDialog(
                title: 'Nhập thông tin',
                msg: 'Vui lòng nhập tên chi nhánh.',
                function: () {
                  isOpenDialog = false;
                  Navigator.pop(context);
                });
          }
        } else if (controller.address.text.isEmpty) {
          if (!isOpenDialog) {
            isOpenDialog = true;
            DialogWidget.instance.openMsgDialog(
                title: 'Nhập thông tin',
                msg: 'Vui lòng nhập địa chỉ chi nhánh.',
                function: () {
                  isOpenDialog = false;
                  Navigator.pop(context);
                });
          }
        } else {
          countValid++;
        }
      }
      if (branchList.length == countValid) {
        check = true;
      }
    } else {
      check = true;
    }
    return check;
  }

  void reset(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<AddBusinessProvider>(context, listen: false).reset();
    });
    businessNameContorller.clear();
    addressController.clear();
    taxCodeController.clear();
    memberController.clear();
  }
}
