import 'package:VietQR/commons/constants/configurations/route.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/sliver_header.dart';
import 'package:VietQR/features/branch/views/branch_detail_view.dart';
import 'package:VietQR/features/business/blocs/business_information_bloc.dart';
import 'package:VietQR/features/business/events/business_information_event.dart';
import 'package:VietQR/features/business/states/business_information_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/branch_filter_insert_dto.dart';
import 'package:VietQR/models/business_detail_dto.dart';
import 'package:VietQR/models/business_item_dto.dart';
import 'package:VietQR/models/transaction_branch_input_dto.dart';
import 'package:VietQR/services/providers/business_inforamtion_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BusinessInformationView extends StatelessWidget {
  final String heroId;
  final BusinessItemDTO dto;
  BusinessInformationView({super.key, required this.heroId, required this.dto});
  BusinessDetailDTO businessDetailDTO = const BusinessDetailDTO(
    id: '',
    name: '',
    address: '',
    code: '',
    imgId: '',
    coverImgId: '',
    taxCode: '',
    userRole: 0,
    managers: [],
    branchs: [],
    transactions: [],
    active: false,
  );
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    String userId = UserInformationHelper.instance.getUserId();

    return BlocProvider(
      create: (BuildContext context) => BusinessInformationBloc()
        ..add(
            BusinessGetDetailEvent(businessId: dto.businessId, userId: userId)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      collapsedHeight: 200,
                      floating: false,
                      expandedHeight: 80,
                      flexibleSpace: SliverHeader(
                        businessName: dto.name,
                        heroId: heroId,
                        imgId: dto.imgId,
                        coverImgId: dto.coverImgId,
                      ),
                    ),
                    // Widget được pin
                  ];
                },
                body: BlocConsumer<BusinessInformationBloc,
                    BusinessInformationState>(
                  listener: (context, state) {
                    if (state is BusinessGetDetailSuccessState) {
                      businessDetailDTO = state.dto;
                      String userId =
                          UserInformationHelper.instance.getUserId();
                      String businessId = businessDetailDTO.id;
                      int role = businessDetailDTO.userRole;
                      BranchFilterInsertDTO branchFilter =
                          BranchFilterInsertDTO(
                              userId: userId,
                              role: role,
                              businessId: businessId);
                      // _branchBloc
                      //     .add(BranchEventGetFilter(dto: branchFilter));

                      Future.delayed(const Duration(milliseconds: 0), () {
                        //update user role
                        int userRole = 0;
                        if (businessDetailDTO.managers
                            .where((element) =>
                                element.userId ==
                                UserInformationHelper.instance.getUserId())
                            .isNotEmpty) {
                          userRole = businessDetailDTO.managers
                              .where((element) =>
                                  element.userId ==
                                  UserInformationHelper.instance.getUserId())
                              .first
                              .role;
                          Provider.of<BusinessInformationProvider>(context,
                                  listen: false)
                              .updateUserRole(userRole);
                        }
                        //update for select box transaction
                        Provider.of<BusinessInformationProvider>(context,
                                listen: false)
                            .updateInput(
                          TransactionBranchInputDTO(
                              businessId: businessId,
                              branchId: 'all',
                              offset: 0),
                        );
                      });

                      Provider.of<BusinessInformationProvider>(context,
                              listen: false)
                          .updateBusinessId(businessId);
                    }
                  },
                  builder: (context, state) {
                    return ListView(
                      shrinkWrap: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Thông tin doanh nghiệp',
                          // functionName: 'Cập nhật',
                          // function: () {},
                        ),
                        BoxLayout(
                          width: width - 40,
                          borderRadius: 8,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: BoxLayout(
                            width: width,
                            child: Column(
                              children: [
                                _buildElementInformation(
                                  context: context,
                                  title: 'Code',
                                  description: businessDetailDTO.code,
                                  isCopy: true,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: DividerWidget(width: width),
                                ),
                                _buildElementInformation(
                                  context: context,
                                  title: 'Địa chỉ',
                                  description: businessDetailDTO.address,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: DividerWidget(width: width),
                                ),
                                _buildElementInformation(
                                  context: context,
                                  title: 'Mã số thuế',
                                  descriptionColor:
                                      (businessDetailDTO.taxCode.isEmpty)
                                          ? AppColor.GREY_TEXT
                                          : null,
                                  description:
                                      (businessDetailDTO.taxCode.isEmpty)
                                          ? 'Chưa cập nhật'
                                          : businessDetailDTO.taxCode,
                                  isCopy: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Quản trị viên',
                          label:
                              '${businessDetailDTO.managers.length} quản trị viên',
                          color: AppColor.BLUE_TEXT,
                          icon: Icons.people_alt_rounded,
                          // function: () {},
                          // functionName: 'Cập nhật',
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BoxLayout(
                          width: width - 40,
                          borderRadius: 8,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsetsDirectional.all(0),
                            itemCount: businessDetailDTO.managers.length,
                            itemBuilder: (context, index) {
                              return _buildMemberList(
                                  context: context,
                                  index: index,
                                  dto: businessDetailDTO.managers[index]);
                            },
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DividerWidget(width: width),
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Chi nhánh',
                          label:
                              '${businessDetailDTO.branchs.length} chi nhánh',
                          color: AppColor.GREEN,
                          icon: Icons.business_rounded,
                        ),
                        SizedBox(
                          width: width,
                          child: ListView.builder(
                            itemCount: businessDetailDTO.branchs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsetsDirectional.all(0),
                            itemBuilder: (context, index) {
                              return _buildBranchList(
                                context: context,
                                dto: businessDetailDTO.branchs[index],
                                index: index,
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _buildTitle(
                          context: context,
                          title: 'Giao dịch gần đây',
                          // functionName: 'Xem thêm',
                          // function: () {
                          //   Navigator.pushNamed(
                          //     context,
                          //     Routes.BUSINESS_TRANSACTION,
                          //   );
                          // },
                        ),
                        BoxLayout(
                          width: width - 40,
                          borderRadius: 8,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: BoxLayout(
                            width: width,
                            child: (businessDetailDTO.transactions.isEmpty)
                                ? const Center(
                                    child: Text(
                                      'Không có giao dịch nào',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    itemCount:
                                        businessDetailDTO.transactions.length +
                                            1,
                                    itemBuilder: (context, index) {
                                      return (index ==
                                              businessDetailDTO
                                                  .transactions.length)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: ButtonIconWidget(
                                                width: width,
                                                icon: Icons.more_horiz_rounded,
                                                title: 'Xem thêm',
                                                function: () {
                                                  // Navigator.pushNamed(
                                                  //   context,
                                                  //   Routes
                                                  //       .BUSINESS_TRANSACTION,
                                                  // );
                                                },
                                                bgColor:
                                                    AppColor.TRANSPARENT,
                                                textColor: AppColor.GREEN,
                                              ),
                                            )
                                          : _buildTransactionItem(
                                              context: context,
                                              dto: businessDetailDTO
                                                  .transactions[index],
                                              businessId: dto.businessId,
                                            );
                                    },
                                    separatorBuilder: (context, index) {
                                      return DividerWidget(width: width);
                                    },
                                  ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 50)),
                      ],
                    );
                  },
                ),

                // ],
              );
            }),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Provider.of<BusinessInformationProvider>(context,
                          listen: false)
                      .reset();
                  Navigator.pop(context, heroId);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required BusinessTransactionDTO dto,
    required String businessId,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        String userId = UserInformationHelper.instance.getUserId();
        Navigator.pushNamed(
          context,
          Routes.TRANSACTION_DETAIL,
          arguments: {
            'transactionId': dto.transactionId,
            'businessInformationBlocDetail':
                context.read<BusinessInformationBloc>(),
            'userId': userId,
            'businessId': businessId,
          },
        );
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                TransactionUtils.instance
                    .getIconStatus(dto.status, dto.tranStype),
                color: TransactionUtils.instance
                    .getColorStatus(dto.status, dto.type, dto.tranStype),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TransactionUtils.instance.getTransType(dto.tranStype)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: TransactionUtils.instance
                          .getColorStatus(dto.status, dto.type, dto.tranStype),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    'Đến TK: ${dto.bankAccount}',
                    style: const TextStyle(),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    dto.content.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.GREY_TEXT,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                TimeUtils.instance.formatDateFromInt(dto.time, true),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),

            // const Padding(padding: EdgeInsets.only(left: 5)),
            // Icon(
            //   TransactionUtils.instance.getIconStatus(dto.status),
            //   size: 15,
            //   color: TransactionUtils.instance.getColorStatus(dto.status),
            // ),
          ],
        ),
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
                fontSize: 16,
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

  Widget _buildBranchList({
    required BuildContext context,
    required BusinessBranchDTO dto,
    required int index,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return BoxLayout(
      width: width,
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          _buildElementInformation(
            context: context,
            title: 'Chi nhánh',
            description: dto.name,
            isDescriptionBold: true,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Code',
            description: dto.code,
            isCopy: true,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Địa chỉ',
            description: dto.address,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _buildElementInformation(
            context: context,
            title: 'Thành viên',
            descriptionColor: (dto.totalMember == 0)
                ? AppColor.GREY_TEXT
                : AppColor.BLUE_TEXT,
            description: (dto.totalMember == 0)
                ? 'Chưa có thành viên'
                : '${dto.totalMember} thành viên',
          ),
          // const Padding(padding: EdgeInsets.only(top: 10)),
          // _buildElementInformation(
          //   context: context,
          //   title: 'Quản lý',
          //   descriptionColor:
          //       (dto.manager.id.isEmpty) ? DefaultTheme.GREY_TEXT : null,
          //   description: (dto.manager.id.isEmpty)
          //       ? 'Chưa có quản lý'
          //       : '${dto.manager.lastName} ${dto.manager.middleName} ${dto.manager.firstName}'
          //           .trim(),
          // ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          (dto.banks.isNotEmpty)
              ? SizedBox(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text('TK đối soát'),
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: dto.banks.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: width - 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColor.WHITE,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: AppColor.GREY_TOP_TAB_BAR,
                                        width: 0.5,
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: ImageUtils.instance
                                            .getImageNetWork(
                                                dto.banks[index].imgId),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    '${dto.banks[index].bankCode} - ${dto.banks[index].bankAccount}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      await FlutterClipboard.copy(
                                              '${dto.banks[index].bankCode} - ${dto.banks[index].bankAccount}')
                                          .then(
                                        (value) => Fluttertoast.showToast(
                                          msg: 'Đã sao chép',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          textColor:
                                              Theme.of(context).hintColor,
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
                          },
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DividerWidget(width: width),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : _buildElementInformation(
                  context: context,
                  title: 'TK đối soát',
                  descriptionColor: AppColor.GREY_TEXT,
                  description: 'Chưa liên kết',
                ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          DividerWidget(width: width),
          ButtonIconWidget(
            width: width,
            height: 40,
            icon: Icons.info_rounded,
            title: 'Chi tiết',
            function: () {
              DialogWidget.instance.openPopup(
                child: BranchDetailView(
                  businessId: businessDetailDTO.id,
                  branchId: dto.id,
                  businessName: businessDetailDTO.name,
                ),
                width: 600,
                height: 800,
              );
            },
            bgColor: AppColor.TRANSPARENT,
            textColor: AppColor.BLUE_TEXT,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberList(
      {required BuildContext context,
      required BusinessManagerDTO dto,
      required int index}) {
    final double width = MediaQuery.of(context).size.width;
    final bool isAdmin = (dto.role == 0);
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                    child: Image.asset('assets/images/ic-avatar.png'),
                  ),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dto.lastName} ${dto.middleName} ${dto.firstName}'.trim(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  dto.phoneNo,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5),
            //   color: (isAdmin) ? DefaultTheme.BLUE_TEXT : DefaultTheme.ORANGE,
            // ),
            child: Text(
              (isAdmin) ? 'Admin' : 'Quản lý',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
        ],
      ),
    );
  }
}

class MyPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  MyPersistentHeaderDelegate({required this.child});

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 45.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColor.TRANSPARENT,
      alignment: Alignment.center,
      child: child, // Widget được pin
    );
  }

  @override
  bool shouldRebuild(covariant MyPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
