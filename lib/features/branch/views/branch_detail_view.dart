import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/branch/blocs/branch_bloc.dart';
import 'package:VietQR/features/branch/events/branch_event.dart';
import 'package:VietQR/features/branch/states/branch_state.dart';
import 'package:VietQR/features/branch/widgets/add_branch_member_widget.dart';
import 'package:VietQR/features/branch/widgets/select_bank_connect_branch_widget.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_bank_branch_dto.dart';
import 'package:VietQR/models/account_bank_branch_insert_dto.dart';
import 'package:VietQR/models/branch_information_dto.dart';
import 'package:VietQR/models/branch_member_delete_dto.dart';
import 'package:VietQR/models/business_member_dto.dart';
import 'package:VietQR/services/providers/business_inforamtion_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BranchDetailView extends StatelessWidget {
  final String branchId;
  final String businessId;
  final String businessName;
  BranchDetailView(
      {super.key,
      required this.businessId,
      required this.branchId,
      required this.businessName});

  BranchInformationDTO branchInformationDTO = const BranchInformationDTO(
    id: '',
    businessId: '',
    code: '',
    name: '',
    address: '',
    isActive: false,
  );

  final List<AccountBankBranchDTO> banks = [];

  final List<Color> colors = [];

  final _formModalKey = GlobalKey<FormState>();

  void initialServices(BuildContext context, String branchId) {
    colors.clear();
    banks.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: BlocProvider(
        create: (BuildContext context) => BranchBloc(id: branchId)
          ..add(
            const BranchEventGetDetail(),
          )
          ..add(
            const BranchEventGetBanks(),
          )
          ..add(
            const BranchEventGetMembers(),
          ),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<BranchBloc, BranchState>(
                listener: (context, state) {
                  if (state is BranchDetailSuccessState) {
                    branchInformationDTO = state.dto;
                  }
                  if (state is BranchGetBanksSuccessState) {
                    banks.clear();
                    colors.clear();
                    if (banks.isEmpty) {
                      banks.addAll(state.list);
                      colors.addAll(state.colors);
                    }
                  }
                  if (state is BranchInsertMemberSuccessState ||
                      state is BranchDeleteMemberSuccessState) {
                    context
                        .read<BranchBloc>()
                        .add(const BranchEventGetMembers());
                  }

                  if (state is BranchDeleteMemberLoadingState) {
                    Provider.of<BusinessInformationProvider>(context,
                            listen: false)
                        .updateElementAtBusinessMember(state.index, true);
                  }

                  if (state is BranchDeleteMemberFailedState) {
                    if (state.updateAll) {
                      Provider.of<BusinessInformationProvider>(context,
                              listen: false)
                          .updateElementAtBusinessMember(state.index, false);
                    } else {
                      Provider.of<BusinessInformationProvider>(context,
                              listen: false)
                          .updateElementAtBusinessMember(state.index, false);
                    }
                  }

                  if (state is BranchConnectBankSuccessState ||
                      state is BranchRemoveBankSuccessState) {
                    initialServices(context, branchId);
                  }

                  if (state is BranchGetMembersLoadingState) {
                    Provider.of<BusinessInformationProvider>(context,
                            listen: false)
                        .updateLoadingGetMember(true);
                  }

                  if (state is BranchGetMembersSuccessState) {
                    Provider.of<BusinessInformationProvider>(context,
                            listen: false)
                        .updateBusinessMember(state.list);
                    if (state.list.isNotEmpty) {
                      Future.delayed(
                        const Duration(milliseconds: 0),
                        () {
                          //update user role
                          int userRole = 0;
                          if (state.list
                              .where((element) =>
                                  element.userId ==
                                  UserInformationHelper.instance.getUserId())
                              .isNotEmpty) {
                            userRole = state.list
                                .where((element) =>
                                    element.userId ==
                                    UserInformationHelper.instance.getUserId())
                                .first
                                .role;
                            Provider.of<BusinessInformationProvider>(context,
                                    listen: false)
                                .updateUserRole(userRole);
                          }
                        },
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 8),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: [
                            _buildTitle(
                              context: context,
                              title: 'Thông tin chi nhánh',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: BoxLayout(
                                child: Column(
                                  children: [
                                    _buildElementInformation(
                                      context: context,
                                      title: 'Chi nhánh',
                                      description: branchInformationDTO.name,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child:
                                          DividerWidget(width: double.infinity),
                                    ),
                                    _buildElementInformation(
                                      context: context,
                                      title: 'Doanh nghiệp',
                                      description: businessName,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child:
                                          DividerWidget(width: double.infinity),
                                    ),
                                    _buildElementInformation(
                                      context: context,
                                      title: 'Code',
                                      description: branchInformationDTO.code,
                                      isCopy: true,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child:
                                          DividerWidget(width: double.infinity),
                                    ),
                                    _buildElementInformation(
                                      context: context,
                                      title: 'Địa chỉ',
                                      description: branchInformationDTO.address,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            _buildTitle(
                              context: context,
                              title: 'Tài khoản ngân hàng',
                            ),
                            (banks.isEmpty)
                                ? BoxLayout(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: ImageUtils.instance
                                              .getImageNetWork(
                                                  AppImages.icCard),
                                        ),
                                        const Text(
                                          'Chưa có tài khoản ngân hàng được kết nối.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        Consumer<BusinessInformationProvider>(
                                          builder: (context, provider, child) {
                                            return (provider.userRole == 5)
                                                ? ButtonIconWidget(
                                                    width: 580,
                                                    icon: Icons.add_rounded,
                                                    title:
                                                        'Kết nối TK ngân hàng với doanh nghiệp',
                                                    function: () {
                                                      DialogWidget.instance
                                                          .showModalBottomContent(
                                                        context: context,
                                                        widget:
                                                            SelectBankConnectBranchWidget(
                                                          branchBloc:
                                                              context.read<
                                                                  BranchBloc>(),
                                                          branchId: branchId,
                                                          businessId:
                                                              businessId,
                                                        ),
                                                        height: 400,
                                                      );
                                                    },
                                                    bgColor: AppColor.GREEN,
                                                    textColor: AppColor.WHITE,
                                                  )
                                                : const SizedBox();
                                          },
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: banks.length,
                                    itemBuilder: (context, index) {
                                      final int userRole = Provider.of<
                                                  BusinessInformationProvider>(
                                              context,
                                              listen: false)
                                          .userRole;
                                      return _buildElementBank(
                                        context: context,
                                        dto: banks[index],
                                        color: colors[index],
                                        userRole: userRole,
                                      );
                                    },
                                  ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Consumer<BusinessInformationProvider>(
                                builder: (context, provider, child) {
                              return Column(
                                children: [
                                  _buildTitle(
                                    context: context,
                                    title: 'Danh sách thành viên',
                                    label: (provider.businessMembers.isEmpty)
                                        ? null
                                        : '${provider.businessMembers.length} thành viên',
                                    color: AppColor.BLUE_TEXT,
                                    icon: Icons.people_alt_rounded,
                                  ),
                                  if (provider.isLoadingGetMember)
                                    Container(
                                      margin: const EdgeInsets.only(top: 24),
                                      color: AppColor.TRANSPARENT,
                                      width: 36,
                                      height: 36,
                                      child: const CircularProgressIndicator(
                                        color: AppColor.GREEN,
                                      ),
                                    )
                                  else
                                    (provider.businessMembers.isEmpty)
                                        ? BoxLayout(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 30)),
                                                const Icon(
                                                  Icons.people_outline_rounded,
                                                  size: 40,
                                                  color: AppColor.BLUE_TEXT,
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 30)),
                                                const Text(
                                                  'Chưa có tài khoản ngân hàng được kết nối.',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10)),
                                                (provider.userRole == 5)
                                                    ? ButtonIconWidget(
                                                        width: 580,
                                                        icon: Icons.add_rounded,
                                                        title:
                                                            'Thêm thành viên',
                                                        function: () async {
                                                          await DialogWidget
                                                              .instance
                                                              .showModelBottomSheet(
                                                            context: context,
                                                            height: 500,
                                                            widget:
                                                                AddBranchMemberWidget(
                                                              branchId:
                                                                  branchId,
                                                              businessId:
                                                                  businessId,
                                                              reloadListMember:
                                                                  () {
                                                                context
                                                                    .read<
                                                                        BranchBloc>()
                                                                    .add(
                                                                        const BranchEventGetMembers());
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        bgColor: AppColor.GREEN,
                                                        textColor:
                                                            AppColor.WHITE,
                                                      )
                                                    : const SizedBox(),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10)),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                provider.businessMembers.length,
                                            itemBuilder: (context, index) {
                                              final int userRole =
                                                  provider.userRole;
                                              return _buildElementMember(
                                                  index: index,
                                                  context: context,
                                                  dto: provider
                                                      .businessMembers[index],
                                                  userRole: userRole);
                                            },
                                          ),
                                ],
                              );
                            }),
                            const Padding(padding: EdgeInsets.only(bottom: 50)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
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
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElementMember(
      {required BuildContext context,
      required BusinessMemberDTO dto,
      required int index,
      required int userRole}) {
    final double width = MediaQuery.of(context).size.width;

    final bool isDelete = (userRole != 4 && userRole != 0) ? true : false;
    return BoxLayout(
      width: width,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          (dto.imgId.isNotEmpty)
              ? Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                )
              : ClipOval(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Image(
                        image: ImageUtils.instance
                            .getImageNetWork(AppImages.personalRelation)),
                  ),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dto.name.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  dto.phoneNo,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              getRoleName(dto.role),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          if (isDelete) ...[
            Consumer<BusinessInformationProvider>(
                builder: (context, provider, child) {
              return dto.isDelete
                  ? Container(
                      color: AppColor.TRANSPARENT,
                      margin: const EdgeInsets.only(left: 10),
                      width: 16,
                      height: 16,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.GREEN,
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          BranchMemberDeleteDTO branchMemberDeleteDTO =
                              BranchMemberDeleteDTO(
                            userId: dto.userId,
                            businessId: businessId,
                          );
                          context.read<BranchBloc>().add(BranchEventRemove(
                              dto: branchMemberDeleteDTO, index: index));
                        },
                        child: BoxLayout(
                          width: 30,
                          height: 30,
                          borderRadius: 15,
                          bgColor: Theme.of(context).canvasColor,
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            Icons.remove_circle_outline_rounded,
                            color: AppColor.RED_TEXT,
                            size: 12,
                          ),
                        ),
                      ),
                    );
            }),
          ]
        ],
      ),
    );
  }

  Widget _buildElementBank(
      {required BuildContext context,
      required AccountBankBranchDTO dto,
      required Color color,
      required int userRole}) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDelete = (userRole != 4 && userRole != 0) ? true : false;
    return BoxLayout(
      width: width,
      padding: (isDelete)
          ? const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20)
          : const EdgeInsets.only(left: 20, right: 20, top: 20),
      margin: const EdgeInsets.only(bottom: 10),
      bgColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dto.bankCode} - ${dto.bankAccount}',
                        style: const TextStyle(
                          color: AppColor.WHITE,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        dto.bankName,
                        style: const TextStyle(
                          color: AppColor.WHITE,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Text(
            dto.userBankName.toUpperCase(),
            style: const TextStyle(
              color: AppColor.WHITE,
              fontSize: 15,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 3)),
          Text(
            'Trạng thái: ${(dto.authenticated) ? 'Đã liên kết' : 'Chưa liên kết'}',
            style: const TextStyle(
              color: AppColor.WHITE,
              fontSize: 12,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          if (!isDelete) ...[
            DividerWidget(width: width),
            ButtonIconWidget(
              width: width,
              height: 40,
              icon: Icons.info_rounded,
              title: 'Chi tiết',
              textSize: 15,
              function: () {
                // Navigator.pushNamed(
                //   context,
                //   Routes.BANK_CARD_DETAIL_VEW,
                //   arguments: {
                //     'bankId': dto.bankId,
                //   },
                // );
              },
              bgColor: AppColor.TRANSPARENT,
              textColor: AppColor.WHITE,
            ),
          ],
          if (isDelete) ...[
            SizedBox(
              width: width,
              child: Row(
                children: [
                  ButtonIconWidget(
                    width: width / 2 - 35,
                    height: 30,
                    icon: Icons.info_rounded,
                    title: 'Chi tiết',
                    textSize: 12,
                    function: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.BANK_CARD_DETAIL_VEW,
                      //   arguments: {
                      //     'bankId': dto.bankId,
                      //   },
                      // );
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                    textColor: AppColor.WHITE,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  ButtonIconWidget(
                    width: width / 2 - 35,
                    height: 30,
                    textSize: 12,
                    icon: Icons.remove_circle_outline_rounded,
                    title: 'Huỷ kết nối',
                    function: () {
                      String userId =
                          UserInformationHelper.instance.getUserId();
                      AccountBankBranchInsertDTO accountBankBranchInsertDTO =
                          AccountBankBranchInsertDTO(
                        userId: userId,
                        bankId: dto.bankId,
                        businessId: businessId,
                        branchId: branchId,
                      );
                      Provider.of<BranchBloc>(context).add(
                          BranchEventRemoveBank(
                              dto: accountBankBranchInsertDTO));
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.3),
                    textColor: AppColor.WHITE,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildElementInformation({
    required BuildContext context,
    required String title,
    required String description,
    bool? isCopy,
    bool? isDescriptionBold,
    Color? descriptionColor,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontWeight: (isDescriptionBold != null && isDescriptionBold)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (descriptionColor != null)
                    ? descriptionColor
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
          if (isCopy != null && isCopy)
            InkWell(
              onTap: () async {
                await FlutterClipboard.copy(description).then(
                  (value) => Fluttertoast.showToast(
                    msg: 'Đã sao chép',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                    webBgColor: 'rgba(255, 255, 255)',
                    webPosition: 'center',
                  ),
                );
              },
              child: const Icon(
                Icons.copy_rounded,
                color: AppColor.GREY_TEXT,
                size: 15,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle({
    required BuildContext context,
    required String title,
    String? label,
    IconData? icon,
    Color? color,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (label != null) ...[
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color!.withOpacity(0.2),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 15,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String getRoleName(int role) {
    String result = '';
    if (role == 5) {
      result = 'Admin';
    } else if (role == 1) {
      result = 'Quản lý';
    } else if (role == 3) {
      result = 'Quản lý chi nhánh';
    } else {
      result = 'Thành viên';
    }
    return result;
  }
}
