import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/branch/blocs/branch_bloc.dart';
import 'package:VietQR/features/branch/events/branch_event.dart';
import 'package:VietQR/features/branch/states/branch_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/branch_member_insert_dto.dart';
import 'package:VietQR/models/business_member_dto.dart';
import 'package:VietQR/services/providers/search_clear_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AddBranchMemberWidget extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final String branchId;
  final String businessId;
  final Function reloadListMember;
  final SearchClearProvider searchClearProvider = SearchClearProvider(false);
  final _formAddMemberKey = GlobalKey<FormState>();
  String message = '';
  BusinessMemberDTO dto = BusinessMemberDTO(
    userId: '',
    status: '',
    existed: TypeAddMember.MORE.existed,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

  AddBranchMemberWidget(
      {super.key,
      required this.branchId,
      required this.businessId,
      required this.reloadListMember});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 50,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Thêm thành viên',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    reset(context);
                    reloadListMember();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: AppColor.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          BlocListener<BranchBloc, BranchState>(
            listener: (context, state) {
              if (state is BranchInsertMemberLoadingState) {
                Provider.of<SearchProvider>(context, listen: false)
                    .updateExisted(TypeAddMember.AWAIT);
              }
              if (state is BranchInsertMemberSuccessState) {
                Provider.of<SearchProvider>(context, listen: false)
                    .updateExisted(TypeAddMember.ADDED);
              }

              if (state is BranchSeachMemberSuccessState) {
                message = '';
                Provider.of<SearchProvider>(context, listen: false)
                    .updateDTO(state.dto);
                Provider.of<SearchProvider>(context, listen: false)
                    .updateExisted(state.dto.typeMember);
              }
              if (state is BranchSearchMemberNotFoundState) {
                message = state.message;
                Provider.of<SearchProvider>(context, listen: false)
                    .updateDTO(dto);
                Provider.of<SearchProvider>(context, listen: false)
                    .updateExisted(dto.existed);
              }
            },
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kết quả tìm kiếm',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    (message.trim().isNotEmpty && provider.dto.userId.isEmpty)
                        ? BoxLayout(
                            width: width,
                            borderRadius: 5,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            bgColor: Theme.of(context).canvasColor,
                            child: Text(
                              message,
                            ),
                          )
                        : (provider.dto.userId.isNotEmpty &&
                                message.trim().isEmpty)
                            ? _buildSearchItem(
                                context: context,
                                dto: provider.dto,
                                existed: provider.typeMember,
                              )
                            : const SizedBox(),
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          Form(
            key: _formAddMemberKey,
            child: BorderLayout(
              width: width,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              isError: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 15,
                    color: Theme.of(context).hintColor,
                  ),
                  TextFieldWidget(
                    titleWidth: 80,
                    width: width - 110,
                    isObscureText: false,
                    hintText: 'Nhập số điện thoại',
                    controller: nameController,
                    inputType: TextInputType.number,
                    autoFocus: false,
                    keyboardAction: TextInputAction.done,
                    onChange: (text) {
                      if (nameController.text.isNotEmpty) {
                        searchClearProvider.updateClearSearch(true);
                      } else {
                        searchClearProvider.updateClearSearch(false);
                      }
                      if (nameController.text.length >= 10 &&
                          nameController.text.length <= 12) {
                        context.read<BranchBloc>().add(BranchEventSearchMember(
                            phoneNo: nameController.text,
                            businessId: businessId));
                      } else {
                        message = '';
                        Provider.of<SearchProvider>(context, listen: false)
                            .updateDTO(dto);
                        Provider.of<SearchProvider>(context, listen: false)
                            .updateExisted(TypeAddMember.MORE);
                        context.read<BranchBloc>().add(BranchEventInitial());
                      }
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: searchClearProvider,
                    builder: (_, provider, child) {
                      return Visibility(
                        visible: provider == true,
                        child: InkWell(
                          onTap: () {
                            reset(context);
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 15,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildSearchItem(
      {required BuildContext context,
      required BusinessMemberDTO dto,
      required TypeAddMember existed}) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
                Text(dto.name.trim()),
                Text(dto.phoneNo),
              ],
            ),
          ),
          (existed == TypeAddMember.ADDED)
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.GREY_VIEW,
                  ),
                  child: Row(children: const [
                    Icon(
                      Icons.check_rounded,
                      color: AppColor.GREEN,
                      size: 13,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      'Đã thêm',
                      style: TextStyle(color: AppColor.GREEN),
                    )
                  ]),
                )
              : (existed == TypeAddMember.AWAIT)
                  ? Container(
                      color: AppColor.TRANSPARENT,
                      margin: const EdgeInsets.only(right: 8),
                      width: 24,
                      height: 24,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.GREEN,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        BranchMemberInsertDTO branchMemberInsertDTO =
                            BranchMemberInsertDTO(
                          branchId: branchId,
                          businessId: businessId,
                          userId: dto.userId,
                          role: 4,
                        );
                        context.read<BranchBloc>().add(BranchEventInsertMember(
                            dto: branchMemberInsertDTO));
                        // reset(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.GREEN,
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.add_rounded,
                              color: AppColor.WHITE,
                              size: 13,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                              'Thêm',
                              style: TextStyle(
                                color: AppColor.WHITE,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  void reset(BuildContext context) {
    nameController.clear();
    message = '';
    searchClearProvider.updateClearSearch(false);
    Provider.of<SearchProvider>(context, listen: false).updateDTO(dto);
    Provider.of<SearchProvider>(context, listen: false)
        .updateExisted(dto.typeMember);
  }
}
